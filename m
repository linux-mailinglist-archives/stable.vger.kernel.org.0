Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0A447ABC5
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234667AbhLTOjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:39:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47410 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234087AbhLTOiX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:38:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2D3BB80EDE;
        Mon, 20 Dec 2021 14:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DB3C36AE7;
        Mon, 20 Dec 2021 14:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011100;
        bh=H9YoIvwfbJHPZC6ivMdbbQJkpuKF68puiQgNv1RCO7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGBQ/DPVgrA0zT6XzGZ+5RORO6cZX5l1VvIF5IYc/Be2tfaJpSiIaGDxKFnkr18tV
         /LujzYxn9ZybrkyhKKUbQXJQY8kCY5d9ZVq1jl02mdCXC36sk6B3LYo9B8fZ47devQ
         1XouoLPBBFM9v3JVqqwkDbP0kuNv5uodqX1kUDaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 4.9 27/31] xen/blkfront: harden blkfront against event channel storms
Date:   Mon, 20 Dec 2021 15:34:27 +0100
Message-Id: <20211220143020.841423126@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143019.974513085@linuxfoundation.org>
References: <20211220143019.974513085@linuxfoundation.org>
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
@@ -1555,9 +1555,12 @@ static irqreturn_t blkif_interrupt(int i
 	struct blkfront_ring_info *rinfo = (struct blkfront_ring_info *)dev_id;
 	struct blkfront_info *info = rinfo->dev_info;
 	int error;
+	unsigned int eoiflag = XEN_EOI_FLAG_SPURIOUS;
 
-	if (unlikely(info->connected != BLKIF_STATE_CONNECTED))
+	if (unlikely(info->connected != BLKIF_STATE_CONNECTED)) {
+		xen_irq_lateeoi(irq, XEN_EOI_FLAG_SPURIOUS);
 		return IRQ_HANDLED;
+	}
 
 	spin_lock_irqsave(&rinfo->ring_lock, flags);
  again:
@@ -1573,6 +1576,8 @@ static irqreturn_t blkif_interrupt(int i
 		unsigned long id;
 		unsigned int op;
 
+		eoiflag = 0;
+
 		RING_COPY_RESPONSE(&rinfo->ring, i, &bret);
 		id = bret.id;
 
@@ -1684,6 +1689,8 @@ static irqreturn_t blkif_interrupt(int i
 
 	spin_unlock_irqrestore(&rinfo->ring_lock, flags);
 
+	xen_irq_lateeoi(irq, eoiflag);
+
 	return IRQ_HANDLED;
 
  err:
@@ -1691,6 +1698,8 @@ static irqreturn_t blkif_interrupt(int i
 
 	spin_unlock_irqrestore(&rinfo->ring_lock, flags);
 
+	/* No EOI in order to avoid further interrupts. */
+
 	pr_alert("%s disabled for further use\n", info->gd->disk_name);
 	return IRQ_HANDLED;
 }
@@ -1730,8 +1739,8 @@ static int setup_blkring(struct xenbus_d
 	if (err)
 		goto fail;
 
-	err = bind_evtchn_to_irqhandler(rinfo->evtchn, blkif_interrupt, 0,
-					"blkif", rinfo);
+	err = bind_evtchn_to_irqhandler_lateeoi(rinfo->evtchn, blkif_interrupt,
+						0, "blkif", rinfo);
 	if (err <= 0) {
 		xenbus_dev_fatal(dev, err,
 				 "bind_evtchn_to_irqhandler failed");


