Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A21173CB1
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392050AbfGXULA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:11:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405084AbfGXT6a (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:58:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3E2F22AED;
        Wed, 24 Jul 2019 19:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998309;
        bh=+JtiHC55Zj93Ao+O1OZPUOCzDqan5lXt1YodqGL7VQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=spC8+NGxsl2uRvpetN6uDilNeHJ6I8zUiMasJuQl1N5LFIKfzh+qoTqQn8bq1Lkoy
         kcx+JWyvKMMOC6BgajVcsK/vjzXkpqHuSCXgMtEjECKvIpaK8ewIkGwOAwmaU7v8tb
         n0I5RgzmYY24IXUy00jKR5ITXVK/STZSTk8NnoPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Soeren Moch <smoch@web.de>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.1 320/371] rt2x00usb: fix rx queue hang
Date:   Wed, 24 Jul 2019 21:21:12 +0200
Message-Id: <20190724191748.030255385@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Soeren Moch <smoch@web.de>

commit 41a531ffa4c5aeb062f892227c00fabb3b4a9c91 upstream.

Since commit ed194d136769 ("usb: core: remove local_irq_save() around
 ->complete() handler") the handler rt2x00usb_interrupt_rxdone() is
not running with interrupts disabled anymore. So this completion handler
is not guaranteed to run completely before workqueue processing starts
for the same queue entry.
Be sure to set all other flags in the entry correctly before marking
this entry ready for workqueue processing. This way we cannot miss error
conditions that need to be signalled from the completion handler to the
worker thread.
Note that rt2x00usb_work_rxdone() processes all available entries, not
only such for which queue_work() was called.

This patch is similar to what commit df71c9cfceea ("rt2x00: fix order
of entry flags modification") did for TX processing.

This fixes a regression on a RT5370 based wifi stick in AP mode, which
suddenly stopped data transmission after some period of heavy load. Also
stopping the hanging hostapd resulted in the error message "ieee80211
phy0: rt2x00queue_flush_queue: Warning - Queue 14 failed to flush".
Other operation modes are probably affected as well, this just was
the used testcase.

Fixes: ed194d136769 ("usb: core: remove local_irq_save() around ->complete() handler")
Cc: stable@vger.kernel.org # 4.20+
Signed-off-by: Soeren Moch <smoch@web.de>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -367,15 +367,10 @@ static void rt2x00usb_interrupt_rxdone(s
 	struct queue_entry *entry = (struct queue_entry *)urb->context;
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 
-	if (!test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
+	if (!test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
 		return;
 
 	/*
-	 * Report the frame as DMA done
-	 */
-	rt2x00lib_dmadone(entry);
-
-	/*
 	 * Check if the received data is simply too small
 	 * to be actually valid, or if the urb is signaling
 	 * a problem.
@@ -384,6 +379,11 @@ static void rt2x00usb_interrupt_rxdone(s
 		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
 
 	/*
+	 * Report the frame as DMA done
+	 */
+	rt2x00lib_dmadone(entry);
+
+	/*
 	 * Schedule the delayed work for reading the RX status
 	 * from the device.
 	 */


