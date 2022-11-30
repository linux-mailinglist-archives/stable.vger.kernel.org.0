Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949C663DEC9
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbiK3Sku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbiK3Skt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:40:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4068498977
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:40:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB5BAB81CA6
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BB0C433C1;
        Wed, 30 Nov 2022 18:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833645;
        bh=QI+SsreTKs5rxJGhRrfDkvSaD0nLatiDiVuNdJNGZKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W8lM8OSJjWNN8ZI36J3Dor6vdraOu1Qh1a4S2fNrCoNo0efNIQd2LqCAd/YXWi/3x
         5sAvuqPhx+r2INDM/reRssKXheFNLkPNhy2fd0zLn0/haWUzTH6uLu0ZgXJcTizdAm
         /Szpp5gIHjghYzIodSut9aGn1lqxyir2rUKpntxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pawel Laszczak <pawell@cadence.com>,
        Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.15 143/206] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Date:   Wed, 30 Nov 2022 19:23:15 +0100
Message-Id: <20221130180536.676761686@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

commit 7a21b27aafa3edead79ed97e6f22236be6b9f447 upstream.

Patch modifies the TD_SIZE in TRB before ZLP TRB.
The TD_SIZE in TRB before ZLP TRB must be set to 1 to force
processing ZLP TRB by controller.

cc: <stable@vger.kernel.org>
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20221115092218.421267-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-ring.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -1763,10 +1763,15 @@ static u32 cdnsp_td_remainder(struct cdn
 			      int trb_buff_len,
 			      unsigned int td_total_len,
 			      struct cdnsp_request *preq,
-			      bool more_trbs_coming)
+			      bool more_trbs_coming,
+			      bool zlp)
 {
 	u32 maxp, total_packet_count;
 
+	/* Before ZLP driver needs set TD_SIZE = 1. */
+	if (zlp)
+		return 1;
+
 	/* One TRB with a zero-length data packet. */
 	if (!more_trbs_coming || (transferred == 0 && trb_buff_len == 0) ||
 	    trb_buff_len == td_total_len)
@@ -1960,7 +1965,8 @@ int cdnsp_queue_bulk_tx(struct cdnsp_dev
 		/* Set the TRB length, TD size, and interrupter fields. */
 		remainder = cdnsp_td_remainder(pdev, enqd_len, trb_buff_len,
 					       full_len, preq,
-					       more_trbs_coming);
+					       more_trbs_coming,
+					       zero_len_trb);
 
 		length_field = TRB_LEN(trb_buff_len) | TRB_TD_SIZE(remainder) |
 			TRB_INTR_TARGET(0);
@@ -2025,7 +2031,7 @@ int cdnsp_queue_ctrl_tx(struct cdnsp_dev
 
 	if (preq->request.length > 0) {
 		remainder = cdnsp_td_remainder(pdev, 0, preq->request.length,
-					       preq->request.length, preq, 1);
+					       preq->request.length, preq, 1, 0);
 
 		length_field = TRB_LEN(preq->request.length) |
 				TRB_TD_SIZE(remainder) | TRB_INTR_TARGET(0);
@@ -2226,7 +2232,7 @@ static int cdnsp_queue_isoc_tx(struct cd
 		/* Set the TRB length, TD size, & interrupter fields. */
 		remainder = cdnsp_td_remainder(pdev, running_total,
 					       trb_buff_len, td_len, preq,
-					       more_trbs_coming);
+					       more_trbs_coming, 0);
 
 		length_field = TRB_LEN(trb_buff_len) | TRB_INTR_TARGET(0);
 


