Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED0932A2EC2
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 16:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgKBP5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 10:57:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:39132 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbgKBP5J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 10:57:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604332627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aHhSVjfqr9ZR9UohvYydF4lVSyQsdo39sUs9DXsFNho=;
        b=k35iTBf2kiWJ2MX7/0JX8Cy/9dZMpT9jj2zadmmmPyazHqqHQNXk5txPrM6aEJ7GN74IQs
        q29ept5byfFEjCRFASsP+dxTBHz8avFx0IIrvV+jCY5F9seJJGK75Pb3YfrmrbMUDh2yB6
        dNKXppT6s/GGnaBaMmTuJdOePYFfsL4=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 109CFB11B
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 15:57:07 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH 09/14] xen/pvcallsback: use lateeoi irq binding
Date:   Mon,  2 Nov 2020 16:57:00 +0100
Message-Id: <20201102155705.8578-10-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201102155705.8578-1-jgross@suse.com>
References: <20201102155705.8578-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In order to reduce the chance for the system becoming unresponsive due
to event storms triggered by a misbehaving pvcallsfront use the lateeoi
irq binding for pvcallsback and unmask the event channel only after
handling all write requests, which are the ones coming in via an irq.

This requires modifying the logic a little bit to not require an event
for each write request, but to keep the ioworker running until no
further data is found on the ring page to be processed.

This is part of XSA-332.

This is upstream commit c8d647a326f06a39a8e5f0f1af946eacfa1835f8

Cc: stable@vger.kernel.org
Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Reviewed-by: Wei Liu <wl@xen.org>
---
 drivers/xen/pvcalls-back.c | 76 +++++++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 30 deletions(-)

diff --git a/drivers/xen/pvcalls-back.c b/drivers/xen/pvcalls-back.c
index 62a0c4111dc4..b13d03aba791 100644
--- a/drivers/xen/pvcalls-back.c
+++ b/drivers/xen/pvcalls-back.c
@@ -75,6 +75,7 @@ struct sock_mapping {
 	atomic_t write;
 	atomic_t io;
 	atomic_t release;
+	atomic_t eoi;
 	void (*saved_data_ready)(struct sock *sk);
 	struct pvcalls_ioworker ioworker;
 };
@@ -96,7 +97,7 @@ static int pvcalls_back_release_active(struct xenbus_device *dev,
 				       struct pvcalls_fedata *fedata,
 				       struct sock_mapping *map);
 
-static void pvcalls_conn_back_read(void *opaque)
+static bool pvcalls_conn_back_read(void *opaque)
 {
 	struct sock_mapping *map = (struct sock_mapping *)opaque;
 	struct msghdr msg;
@@ -116,17 +117,17 @@ static void pvcalls_conn_back_read(void *opaque)
 	virt_mb();
 
 	if (error)
-		return;
+		return false;
 
 	size = pvcalls_queued(prod, cons, array_size);
 	if (size >= array_size)
-		return;
+		return false;
 	spin_lock_irqsave(&map->sock->sk->sk_receive_queue.lock, flags);
 	if (skb_queue_empty(&map->sock->sk->sk_receive_queue)) {
 		atomic_set(&map->read, 0);
 		spin_unlock_irqrestore(&map->sock->sk->sk_receive_queue.lock,
 				flags);
-		return;
+		return true;
 	}
 	spin_unlock_irqrestore(&map->sock->sk->sk_receive_queue.lock, flags);
 	wanted = array_size - size;
@@ -154,7 +155,7 @@ static void pvcalls_conn_back_read(void *opaque)
 	ret = inet_recvmsg(map->sock, &msg, wanted, MSG_DONTWAIT);
 	WARN_ON(ret > wanted);
 	if (ret == -EAGAIN) /* shouldn't happen */
-		return;
+		return true;
 	if (!ret)
 		ret = -ENOTCONN;
 	spin_lock_irqsave(&map->sock->sk->sk_receive_queue.lock, flags);
@@ -173,10 +174,10 @@ static void pvcalls_conn_back_read(void *opaque)
 	virt_wmb();
 	notify_remote_via_irq(map->irq);
 
-	return;
+	return true;
 }
 
-static void pvcalls_conn_back_write(struct sock_mapping *map)
+static bool pvcalls_conn_back_write(struct sock_mapping *map)
 {
 	struct pvcalls_data_intf *intf = map->ring;
 	struct pvcalls_data *data = &map->data;
@@ -193,7 +194,7 @@ static void pvcalls_conn_back_write(struct sock_mapping *map)
 	array_size = XEN_FLEX_RING_SIZE(map->ring_order);
 	size = pvcalls_queued(prod, cons, array_size);
 	if (size == 0)
-		return;
+		return false;
 
 	memset(&msg, 0, sizeof(msg));
 	msg.msg_flags |= MSG_DONTWAIT;
@@ -215,12 +216,11 @@ static void pvcalls_conn_back_write(struct sock_mapping *map)
 
 	atomic_set(&map->write, 0);
 	ret = inet_sendmsg(map->sock, &msg, size);
-	if (ret == -EAGAIN || (ret >= 0 && ret < size)) {
+	if (ret == -EAGAIN) {
 		atomic_inc(&map->write);
 		atomic_inc(&map->io);
+		return true;
 	}
-	if (ret == -EAGAIN)
-		return;
 
 	/* write the data, then update the indexes */
 	virt_wmb();
@@ -233,9 +233,13 @@ static void pvcalls_conn_back_write(struct sock_mapping *map)
 	}
 	/* update the indexes, then notify the other end */
 	virt_wmb();
-	if (prod != cons + ret)
+	if (prod != cons + ret) {
 		atomic_inc(&map->write);
+		atomic_inc(&map->io);
+	}
 	notify_remote_via_irq(map->irq);
+
+	return true;
 }
 
 static void pvcalls_back_ioworker(struct work_struct *work)
@@ -244,6 +248,7 @@ static void pvcalls_back_ioworker(struct work_struct *work)
 		struct pvcalls_ioworker, register_work);
 	struct sock_mapping *map = container_of(ioworker, struct sock_mapping,
 		ioworker);
+	unsigned int eoi_flags = XEN_EOI_FLAG_SPURIOUS;
 
 	while (atomic_read(&map->io) > 0) {
 		if (atomic_read(&map->release) > 0) {
@@ -251,10 +256,18 @@ static void pvcalls_back_ioworker(struct work_struct *work)
 			return;
 		}
 
-		if (atomic_read(&map->read) > 0)
-			pvcalls_conn_back_read(map);
-		if (atomic_read(&map->write) > 0)
-			pvcalls_conn_back_write(map);
+		if (atomic_read(&map->read) > 0 &&
+		    pvcalls_conn_back_read(map))
+			eoi_flags = 0;
+		if (atomic_read(&map->write) > 0 &&
+		    pvcalls_conn_back_write(map))
+			eoi_flags = 0;
+
+		if (atomic_read(&map->eoi) > 0 && !atomic_read(&map->write)) {
+			atomic_set(&map->eoi, 0);
+			xen_irq_lateeoi(map->irq, eoi_flags);
+			eoi_flags = XEN_EOI_FLAG_SPURIOUS;
+		}
 
 		atomic_dec(&map->io);
 	}
@@ -351,12 +364,9 @@ static struct sock_mapping *pvcalls_new_active_socket(
 		goto out;
 	map->bytes = page;
 
-	ret = bind_interdomain_evtchn_to_irqhandler(fedata->dev->otherend_id,
-						    evtchn,
-						    pvcalls_back_conn_event,
-						    0,
-						    "pvcalls-backend",
-						    map);
+	ret = bind_interdomain_evtchn_to_irqhandler_lateeoi(
+			fedata->dev->otherend_id, evtchn,
+			pvcalls_back_conn_event, 0, "pvcalls-backend", map);
 	if (ret < 0)
 		goto out;
 	map->irq = ret;
@@ -890,15 +900,18 @@ static irqreturn_t pvcalls_back_event(int irq, void *dev_id)
 {
 	struct xenbus_device *dev = dev_id;
 	struct pvcalls_fedata *fedata = NULL;
+	unsigned int eoi_flags = XEN_EOI_FLAG_SPURIOUS;
 
-	if (dev == NULL)
-		return IRQ_HANDLED;
+	if (dev) {
+		fedata = dev_get_drvdata(&dev->dev);
+		if (fedata) {
+			pvcalls_back_work(fedata);
+			eoi_flags = 0;
+		}
+	}
 
-	fedata = dev_get_drvdata(&dev->dev);
-	if (fedata == NULL)
-		return IRQ_HANDLED;
+	xen_irq_lateeoi(irq, eoi_flags);
 
-	pvcalls_back_work(fedata);
 	return IRQ_HANDLED;
 }
 
@@ -908,12 +921,15 @@ static irqreturn_t pvcalls_back_conn_event(int irq, void *sock_map)
 	struct pvcalls_ioworker *iow;
 
 	if (map == NULL || map->sock == NULL || map->sock->sk == NULL ||
-		map->sock->sk->sk_user_data != map)
+		map->sock->sk->sk_user_data != map) {
+		xen_irq_lateeoi(irq, 0);
 		return IRQ_HANDLED;
+	}
 
 	iow = &map->ioworker;
 
 	atomic_inc(&map->write);
+	atomic_inc(&map->eoi);
 	atomic_inc(&map->io);
 	queue_work(iow->wq, &iow->register_work);
 
@@ -948,7 +964,7 @@ static int backend_connect(struct xenbus_device *dev)
 		goto error;
 	}
 
-	err = bind_interdomain_evtchn_to_irq(dev->otherend_id, evtchn);
+	err = bind_interdomain_evtchn_to_irq_lateeoi(dev->otherend_id, evtchn);
 	if (err < 0)
 		goto error;
 	fedata->irq = err;
-- 
2.26.2

