Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F260647AB6C
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbhLTOgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:36:40 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:51734 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233763AbhLTOge (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:36:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9DD18CE110C;
        Mon, 20 Dec 2021 14:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67607C36AE8;
        Mon, 20 Dec 2021 14:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640010991;
        bh=man+0ueV1g91q32w1KcrSorf6LfwBGLx54Op6ZT18s4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CbJXdhjgIQvos4Oh4bXmAolek1fH5MI7L+TovZZ1ok5H/WGcwCsWGAbkH9/cYxsJ6
         tKfpWQQ7wqJuq52x9hE6cBk2Lo67eUH9W81lkDOvAH1wHEOurVFEuriNjDByOyql6i
         5bsNM9wyCMnU/DhX+RI6eUaFSxW85ia6uartOkj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 4.4 20/23] xen/blkfront: harden blkfront against event channel storms
Date:   Mon, 20 Dec 2021 15:34:21 +0100
Message-Id: <20211220143018.496834879@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143017.842390782@linuxfoundation.org>
References: <20211220143017.842390782@linuxfoundation.org>
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
 drivers/block/xen-blkfront.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1319,11 +1319,13 @@ static irqreturn_t blkif_interrupt(int i
 	unsigned long flags;
 	struct blkfront_info *info = (struct blkfront_info *)dev_id;
 	int error;
+	unsigned int eoiflag = XEN_EOI_FLAG_SPURIOUS;
 
 	spin_lock_irqsave(&info->io_lock, flags);
 
 	if (unlikely(info->connected != BLKIF_STATE_CONNECTED)) {
 		spin_unlock_irqrestore(&info->io_lock, flags);
+		xen_irq_lateeoi(irq, XEN_EOI_FLAG_SPURIOUS);
 		return IRQ_HANDLED;
 	}
 
@@ -1340,6 +1342,8 @@ static irqreturn_t blkif_interrupt(int i
 		unsigned long id;
 		unsigned int op;
 
+		eoiflag = 0;
+
 		RING_COPY_RESPONSE(&info->ring, i, &bret);
 		id   = bret.id;
 
@@ -1444,6 +1448,8 @@ static irqreturn_t blkif_interrupt(int i
 
 	spin_unlock_irqrestore(&info->io_lock, flags);
 
+	xen_irq_lateeoi(irq, eoiflag);
+
 	return IRQ_HANDLED;
 
  err:
@@ -1451,6 +1457,8 @@ static irqreturn_t blkif_interrupt(int i
 
 	spin_unlock_irqrestore(&info->io_lock, flags);
 
+	/* No EOI in order to avoid further interrupts. */
+
 	pr_alert("%s disabled for further use\n", info->gd->disk_name);
 	return IRQ_HANDLED;
 }
@@ -1489,8 +1497,8 @@ static int setup_blkring(struct xenbus_d
 	if (err)
 		goto fail;
 
-	err = bind_evtchn_to_irqhandler(info->evtchn, blkif_interrupt, 0,
-					"blkif", info);
+	err = bind_evtchn_to_irqhandler_lateeoi(info->evtchn, blkif_interrupt,
+						0, "blkif", info);
 	if (err <= 0) {
 		xenbus_dev_fatal(dev, err,
 				 "bind_evtchn_to_irqhandler failed");


