Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1BD52A59C0
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729841AbgKCWKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 17:10:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:47684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729830AbgKCUh5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:37:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35A8B22226;
        Tue,  3 Nov 2020 20:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435876;
        bh=okUtknBXDR3m8kFSpNiwGs9o70vQOm9d8lcTQitAarE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0sFqNMmmUrpBHTvVaCvawK/rWH51aIhNXn82wZXMJMwDey98X/ZWMyyXtsD1fIuMM
         e+D6s0Au0oOpCs4HJDDqbFczWlDcPddRAqUdkerL9qdNqe1Mt4NMLTQM2fFlfv6k/M
         1AdQp53DTwnNPGuoQont56dpHjrnFjnUDhe0jl7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Grall <julien@xen.org>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Wei Liu <wl@xen.org>
Subject: [PATCH 5.9 008/391] xen/pvcallsback: use lateeoi irq binding
Date:   Tue,  3 Nov 2020 21:30:59 +0100
Message-Id: <20201103203348.631748937@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit c8d647a326f06a39a8e5f0f1af946eacfa1835f8 upstream.

In order to reduce the chance for the system becoming unresponsive due
to event storms triggered by a misbehaving pvcallsfront use the lateeoi
irq binding for pvcallsback and unmask the event channel only after
handling all write requests, which are the ones coming in via an irq.

This requires modifying the logic a little bit to not require an event
for each write request, but to keep the ioworker running until no
further data is found on the ring page to be processed.

This is part of XSA-332.

Cc: stable@vger.kernel.org
Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Reviewed-by: Wei Liu <wl@xen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/pvcalls-back.c |   76 +++++++++++++++++++++++++++------------------
 1 file changed, 46 insertions(+), 30 deletions(-)

--- a/drivers/xen/pvcalls-back.c
+++ b/drivers/xen/pvcalls-back.c
@@ -66,6 +66,7 @@ struct sock_mapping {
 	atomic_t write;
 	atomic_t io;
 	atomic_t release;
+	atomic_t eoi;
 	void (*saved_data_ready)(struct sock *sk);
 	struct pvcalls_ioworker ioworker;
 };
@@ -87,7 +88,7 @@ static int pvcalls_back_release_active(s
 				       struct pvcalls_fedata *fedata,
 				       struct sock_mapping *map);
 
-static void pvcalls_conn_back_read(void *opaque)
+static bool pvcalls_conn_back_read(void *opaque)
 {
 	struct sock_mapping *map = (struct sock_mapping *)opaque;
 	struct msghdr msg;
@@ -107,17 +108,17 @@ static void pvcalls_conn_back_read(void
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
@@ -141,7 +142,7 @@ static void pvcalls_conn_back_read(void
 	ret = inet_recvmsg(map->sock, &msg, wanted, MSG_DONTWAIT);
 	WARN_ON(ret > wanted);
 	if (ret == -EAGAIN) /* shouldn't happen */
-		return;
+		return true;
 	if (!ret)
 		ret = -ENOTCONN;
 	spin_lock_irqsave(&map->sock->sk->sk_receive_queue.lock, flags);
@@ -160,10 +161,10 @@ static void pvcalls_conn_back_read(void
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
@@ -180,7 +181,7 @@ static void pvcalls_conn_back_write(stru
 	array_size = XEN_FLEX_RING_SIZE(map->ring_order);
 	size = pvcalls_queued(prod, cons, array_size);
 	if (size == 0)
-		return;
+		return false;
 
 	memset(&msg, 0, sizeof(msg));
 	msg.msg_flags |= MSG_DONTWAIT;
@@ -198,12 +199,11 @@ static void pvcalls_conn_back_write(stru
 
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
@@ -216,9 +216,13 @@ static void pvcalls_conn_back_write(stru
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
@@ -227,6 +231,7 @@ static void pvcalls_back_ioworker(struct
 		struct pvcalls_ioworker, register_work);
 	struct sock_mapping *map = container_of(ioworker, struct sock_mapping,
 		ioworker);
+	unsigned int eoi_flags = XEN_EOI_FLAG_SPURIOUS;
 
 	while (atomic_read(&map->io) > 0) {
 		if (atomic_read(&map->release) > 0) {
@@ -234,10 +239,18 @@ static void pvcalls_back_ioworker(struct
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
@@ -334,12 +347,9 @@ static struct sock_mapping *pvcalls_new_
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
@@ -873,15 +883,18 @@ static irqreturn_t pvcalls_back_event(in
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
 
@@ -891,12 +904,15 @@ static irqreturn_t pvcalls_back_conn_eve
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
 
@@ -932,7 +948,7 @@ static int backend_connect(struct xenbus
 		goto error;
 	}
 
-	err = bind_interdomain_evtchn_to_irq(dev->otherend_id, evtchn);
+	err = bind_interdomain_evtchn_to_irq_lateeoi(dev->otherend_id, evtchn);
 	if (err < 0)
 		goto error;
 	fedata->irq = err;


