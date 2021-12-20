Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA41047AD88
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237682AbhLTOws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:52:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42236 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236750AbhLTOuq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:50:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84D25611AB;
        Mon, 20 Dec 2021 14:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63291C36AE8;
        Mon, 20 Dec 2021 14:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011844;
        bh=3AyQpVaUmqLkLNvFjtb1HRqMs1Y9ovxAvsSh3xdmabo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZVZ45+Zz91rvxPprj2inIfnpkKgVtD62mj9EwYrKFHhSxAUUsLE67EmNoHqgIV7V
         NuUThWeRiIYd8pqe63g7VjWS/LuvvkSv1TvsuBiUHpR9Fc4zJ5zF5a2zONl0UM30r4
         D+TQxUS8Bs33YOrmPyZ5Ob64vaCEgFXBiNUkv3NQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 5.10 95/99] xen/blkfront: harden blkfront against event channel storms
Date:   Mon, 20 Dec 2021 15:35:08 +0100
Message-Id: <20211220143032.597120021@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 0fd08a34e8e3b67ec9bd8287ac0facf8374b844a upstream.

The Xen blkfront driver is still vulnerable for an attack via excessive
number of events sent by the backend. Fix that by using lateeoi event
channels.

This is part of XSA-391

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/xen-blkfront.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1573,9 +1573,12 @@ static irqreturn_t blkif_interrupt(int i
 	unsigned long flags;
 	struct blkfront_ring_info *rinfo = (struct blkfront_ring_info *)dev_id;
 	struct blkfront_info *info = rinfo->dev_info;
+	unsigned int eoiflag = XEN_EOI_FLAG_SPURIOUS;
 
-	if (unlikely(info->connected != BLKIF_STATE_CONNECTED))
+	if (unlikely(info->connected != BLKIF_STATE_CONNECTED)) {
+		xen_irq_lateeoi(irq, XEN_EOI_FLAG_SPURIOUS);
 		return IRQ_HANDLED;
+	}
 
 	spin_lock_irqsave(&rinfo->ring_lock, flags);
  again:
@@ -1591,6 +1594,8 @@ static irqreturn_t blkif_interrupt(int i
 		unsigned long id;
 		unsigned int op;
 
+		eoiflag = 0;
+
 		RING_COPY_RESPONSE(&rinfo->ring, i, &bret);
 		id = bret.id;
 
@@ -1707,6 +1712,8 @@ static irqreturn_t blkif_interrupt(int i
 
 	spin_unlock_irqrestore(&rinfo->ring_lock, flags);
 
+	xen_irq_lateeoi(irq, eoiflag);
+
 	return IRQ_HANDLED;
 
  err:
@@ -1714,6 +1721,8 @@ static irqreturn_t blkif_interrupt(int i
 
 	spin_unlock_irqrestore(&rinfo->ring_lock, flags);
 
+	/* No EOI in order to avoid further interrupts. */
+
 	pr_alert("%s disabled for further use\n", info->gd->disk_name);
 	return IRQ_HANDLED;
 }
@@ -1753,8 +1762,8 @@ static int setup_blkring(struct xenbus_d
 	if (err)
 		goto fail;
 
-	err = bind_evtchn_to_irqhandler(rinfo->evtchn, blkif_interrupt, 0,
-					"blkif", rinfo);
+	err = bind_evtchn_to_irqhandler_lateeoi(rinfo->evtchn, blkif_interrupt,
+						0, "blkif", rinfo);
 	if (err <= 0) {
 		xenbus_dev_fatal(dev, err,
 				 "bind_evtchn_to_irqhandler failed");


