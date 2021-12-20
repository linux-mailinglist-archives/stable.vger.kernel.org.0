Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24F147AD85
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237595AbhLTOwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:52:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238359AbhLTOu1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:50:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2625C08EACD;
        Mon, 20 Dec 2021 06:46:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B43AEB80EB3;
        Mon, 20 Dec 2021 14:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D90C36AE9;
        Mon, 20 Dec 2021 14:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011591;
        bh=xcvZNtq5DQJ1q7ae4zzeHJ+vdr7hWYLhtFeJ7q+YubA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wt8bA/1RrbU8O9AkB57eAETwwUfV65UyCuHqgf0PcmhX6Ttz9nGW1HkNiRQG4NOIk
         Cn8N5uxC3yOj85fujd75LZ5dpbWqgeB48/q2Mn1BsIHjj8qgenx8SBH9ZadyAUxlRu
         X09u8S5KYSUnlPmSRLTzU4mA/ldVqzFfmFqiMnTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 5.4 67/71] xen/blkfront: harden blkfront against event channel storms
Date:   Mon, 20 Dec 2021 15:34:56 +0100
Message-Id: <20211220143027.941275094@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
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
@@ -1565,9 +1565,12 @@ static irqreturn_t blkif_interrupt(int i
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
@@ -1583,6 +1586,8 @@ static irqreturn_t blkif_interrupt(int i
 		unsigned long id;
 		unsigned int op;
 
+		eoiflag = 0;
+
 		RING_COPY_RESPONSE(&rinfo->ring, i, &bret);
 		id = bret.id;
 
@@ -1698,6 +1703,8 @@ static irqreturn_t blkif_interrupt(int i
 
 	spin_unlock_irqrestore(&rinfo->ring_lock, flags);
 
+	xen_irq_lateeoi(irq, eoiflag);
+
 	return IRQ_HANDLED;
 
  err:
@@ -1705,6 +1712,8 @@ static irqreturn_t blkif_interrupt(int i
 
 	spin_unlock_irqrestore(&rinfo->ring_lock, flags);
 
+	/* No EOI in order to avoid further interrupts. */
+
 	pr_alert("%s disabled for further use\n", info->gd->disk_name);
 	return IRQ_HANDLED;
 }
@@ -1744,8 +1753,8 @@ static int setup_blkring(struct xenbus_d
 	if (err)
 		goto fail;
 
-	err = bind_evtchn_to_irqhandler(rinfo->evtchn, blkif_interrupt, 0,
-					"blkif", rinfo);
+	err = bind_evtchn_to_irqhandler_lateeoi(rinfo->evtchn, blkif_interrupt,
+						0, "blkif", rinfo);
 	if (err <= 0) {
 		xenbus_dev_fatal(dev, err,
 				 "bind_evtchn_to_irqhandler failed");


