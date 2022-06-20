Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4259551BC3
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345168AbiFTN0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344697AbiFTNZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:25:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE571AF16;
        Mon, 20 Jun 2022 06:10:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DE5C60A6D;
        Mon, 20 Jun 2022 13:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978B2C3411B;
        Mon, 20 Jun 2022 13:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730612;
        bh=fNMtNd/ZVAeJzffPN0WQglMzH9rYHRFh7UPCRvMC4n4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LFCNu0fetn5kBz6XifhWw3auHQPKiwrrl3TcKf+wO5ELFWlz0yV5XKvXsbbrVyg6A
         IprPURFOu+zcHFr3Dia3cjXgb98Swg6DKJ3oHrVhW5UpUemUL0sLBRFDJrLfCYcDvU
         JF49k3U2XHleozDH3D/HfrPPnTRLQ6G20pxnx2wQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Pawel Laszczak <pawell@cadence.com>,
        Jing Leng <jleng@ambarella.com>
Subject: [PATCH 5.15 088/106] usb: cdnsp: Fixed setting last_trb incorrectly
Date:   Mon, 20 Jun 2022 14:51:47 +0200
Message-Id: <20220620124726.993082471@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Leng <jleng@ambarella.com>

commit 5c7578c39c3fffe85b7d15ca1cf8cf7ac38ec0c1 upstream.

When ZLP occurs in bulk transmission, currently cdnsp will set last_trb
for the last two TRBs, it will trigger an error "ERROR Transfer event TRB
DMA ptr not part of current TD ...".

Fixes: e913aada0683 ("usb: cdnsp: Fixed issue with ZLP")
Cc: stable <stable@kernel.org>
Acked-by: Pawel Laszczak <pawell@cadence.com>
Signed-off-by: Jing Leng <jleng@ambarella.com>
Link: https://lore.kernel.org/r/20220609021134.1606-1-3090101217@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-ring.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -1941,13 +1941,16 @@ int cdnsp_queue_bulk_tx(struct cdnsp_dev
 		}
 
 		if (enqd_len + trb_buff_len >= full_len) {
-			if (need_zero_pkt)
-				zero_len_trb = !zero_len_trb;
-
-			field &= ~TRB_CHAIN;
-			field |= TRB_IOC;
-			more_trbs_coming = false;
-			preq->td.last_trb = ring->enqueue;
+			if (need_zero_pkt && !zero_len_trb) {
+				zero_len_trb = true;
+			} else {
+				zero_len_trb = false;
+				field &= ~TRB_CHAIN;
+				field |= TRB_IOC;
+				more_trbs_coming = false;
+				need_zero_pkt = false;
+				preq->td.last_trb = ring->enqueue;
+			}
 		}
 
 		/* Only set interrupt on short packet for OUT endpoints. */
@@ -1962,7 +1965,7 @@ int cdnsp_queue_bulk_tx(struct cdnsp_dev
 		length_field = TRB_LEN(trb_buff_len) | TRB_TD_SIZE(remainder) |
 			TRB_INTR_TARGET(0);
 
-		cdnsp_queue_trb(pdev, ring, more_trbs_coming | zero_len_trb,
+		cdnsp_queue_trb(pdev, ring, more_trbs_coming,
 				lower_32_bits(send_addr),
 				upper_32_bits(send_addr),
 				length_field,


