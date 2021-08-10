Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056C33E815D
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236418AbhHJR65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:58:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236202AbhHJR4y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:56:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D5016137C;
        Tue, 10 Aug 2021 17:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617519;
        bh=XI4yZmb/YbLobD+9gCBu7ovxoYNC8S5xDSrcjK9bZJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DO32IDNVb9vdbjxhjOvnJGkyk3qnQdkrHD9DBLPwSt8yJhe3a2cmKoHGSdM2Oq38W
         lTktqABqpC2zi8OGaqAPy4GHiBb9QH4h4HYezybZtgw3pnUvJcGGs8jjKUNdpxi2xm
         5PaVUW6ptPT7kZ3tVxM3ti1ZRD5Mrr8nhTswNqN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pawel Laszczak <pawell@cadence.com>,
        Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.13 093/175] usb: cdnsp: Fixed issue with ZLP
Date:   Tue, 10 Aug 2021 19:30:01 +0200
Message-Id: <20210810173004.019786072@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

commit e913aada06830338633fb8524733b0ad3d38a7c1 upstream.

The condition "if (need_zero_pkt && zero_len_trb)" was always false
and it caused that TRB for ZLP was not prepared.

Fix causes that after preparing last TRB in TD, the driver prepares
additional TD with ZLP when a ZLP is required.

Cc: <stable@vger.kernel.org>
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20210623072728.41275-1-pawell@gli-login.cadence.com
Signed-off-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-ring.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -1932,15 +1932,13 @@ int cdnsp_queue_bulk_tx(struct cdnsp_dev
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
@@ -1955,7 +1953,7 @@ int cdnsp_queue_bulk_tx(struct cdnsp_dev
 		length_field = TRB_LEN(trb_buff_len) | TRB_TD_SIZE(remainder) |
 			TRB_INTR_TARGET(0);
 
-		cdnsp_queue_trb(pdev, ring, more_trbs_coming | need_zero_pkt,
+		cdnsp_queue_trb(pdev, ring, more_trbs_coming | zero_len_trb,
 				lower_32_bits(send_addr),
 				upper_32_bits(send_addr),
 				length_field,


