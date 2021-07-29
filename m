Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504623D9DC8
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 08:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbhG2Goy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 02:44:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234079AbhG2Gox (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 02:44:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9E096103A;
        Thu, 29 Jul 2021 06:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627541090;
        bh=T6gQSXvlQBIr+SfzJrppPF5qAK8LmNAlJOUYd4tfaaI=;
        h=Subject:To:From:Date:From;
        b=OKKnC7xvAf0USwODCRhRtGrWIJX8+H+5BLW5nKeUAe56Fibr+osqiClNITiw80rLC
         pIzUNefKMABvh5T9n30MeYX5yg9ldcLD4osAWQekTrE63RzDZZJFyQ69OxnNZ+63dc
         ToZgIGQSjAplSgJuRZRX2aGsN1blhCNIkRuDaG1k=
Subject: patch "usb: cdnsp: Fixed issue with ZLP" added to usb-linus
To:     pawell@cadence.com, peter.chen@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 29 Jul 2021 08:44:36 +0200
Message-ID: <1627541076192114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdnsp: Fixed issue with ZLP

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e913aada06830338633fb8524733b0ad3d38a7c1 Mon Sep 17 00:00:00 2001
From: Pawel Laszczak <pawell@cadence.com>
Date: Wed, 23 Jun 2021 09:27:28 +0200
Subject: usb: cdnsp: Fixed issue with ZLP

The condition "if (need_zero_pkt && zero_len_trb)" was always false
and it caused that TRB for ZLP was not prepared.

Fix causes that after preparing last TRB in TD, the driver prepares
additional TD with ZLP when a ZLP is required.

Cc: <stable@vger.kernel.org>
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20210623072728.41275-1-pawell@gli-login.cadence.com
Signed-off-by: Peter Chen <peter.chen@kernel.org>
---
 drivers/usb/cdns3/cdnsp-ring.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
index 68972746e363..1b1438457fb0 100644
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -1932,15 +1932,13 @@ int cdnsp_queue_bulk_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
 		}
 
 		if (enqd_len + trb_buff_len >= full_len) {
-			if (need_zero_pkt && zero_len_trb) {
-				zero_len_trb = true;
-			} else {
-				field &= ~TRB_CHAIN;
-				field |= TRB_IOC;
-				more_trbs_coming = false;
-				need_zero_pkt = false;
-				preq->td.last_trb = ring->enqueue;
-			}
+			if (need_zero_pkt)
+				zero_len_trb = !zero_len_trb;
+
+			field &= ~TRB_CHAIN;
+			field |= TRB_IOC;
+			more_trbs_coming = false;
+			preq->td.last_trb = ring->enqueue;
 		}
 
 		/* Only set interrupt on short packet for OUT endpoints. */
@@ -1955,7 +1953,7 @@ int cdnsp_queue_bulk_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
 		length_field = TRB_LEN(trb_buff_len) | TRB_TD_SIZE(remainder) |
 			TRB_INTR_TARGET(0);
 
-		cdnsp_queue_trb(pdev, ring, more_trbs_coming | need_zero_pkt,
+		cdnsp_queue_trb(pdev, ring, more_trbs_coming | zero_len_trb,
 				lower_32_bits(send_addr),
 				upper_32_bits(send_addr),
 				length_field,
-- 
2.32.0


