Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D615EA095
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236121AbiIZKkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236356AbiIZKjG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:39:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A5553D0C;
        Mon, 26 Sep 2022 03:22:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8661B80915;
        Mon, 26 Sep 2022 10:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4892DC433D6;
        Mon, 26 Sep 2022 10:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187767;
        bh=uL7SlwwZZ5lf4O8RXBnrMmtiQSNrVMXo+2zGJvQVkFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QXEBYjQ87ygReiCa05PDidLT01G/lPN66jZj09HXdEXgpb4mo8McViYDUsfqfaz7u
         cb3TFvf49CbS4rI2NL9W/S/8s58yvGcHT+zaMyRfecjJT18gcOgRSL2TF+FLOITSPF
         nXN5RnlvI0R3BWNhy/hVuW0pkoIJ54yt1aFCjf/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/120] usb: xhci-mtk: add only one extra CS for FS/LS INTR
Date:   Mon, 26 Sep 2022 12:11:09 +0200
Message-Id: <20220926100752.009518510@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

[ Upstream commit 1bf661daf6b084bc4d753f55b54f35dc98709685 ]

In USB2 Spec:
"11.18.5 TT Response Generation
In general, there will be two (or more) complete-split
transactions scheduled for a periodic endpoint.
However, for interrupt endpoints, the maximum size of
the full-/low-speed transaction guarantees that it can
never require more than two complete-split transactions.
Two complete-split transactions are only required
when the transaction spans a microframe boundary."

Due to the maxp is 64, and less then 188 (at most in one
microframe), seems never span boundary, so use only one CS
for FS/LS interrupt transfer, this will save some bandwidth.

Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/5b9ff09f53d23cf9e5c5437db4ffc18b798bf60c.1615170625.git.chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 548011957d1d ("usb: xhci-mtk: relax TT periodic bandwidth allocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mtk-sch.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/host/xhci-mtk-sch.c b/drivers/usb/host/xhci-mtk-sch.c
index 450fa22b7dc7..59ba25ca018d 100644
--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -408,13 +408,11 @@ static int check_sch_tt(struct usb_device *udev,
 {
 	struct mu3h_sch_tt *tt = sch_ep->sch_tt;
 	u32 extra_cs_count;
-	u32 fs_budget_start;
 	u32 start_ss, last_ss;
 	u32 start_cs, last_cs;
 	int i;
 
 	start_ss = offset % 8;
-	fs_budget_start = (start_ss + 1) % 8;
 
 	if (sch_ep->ep_type == ISOC_OUT_EP) {
 		last_ss = start_ss + sch_ep->cs_count - 1;
@@ -450,16 +448,14 @@ static int check_sch_tt(struct usb_device *udev,
 		if (sch_ep->ep_type == ISOC_IN_EP)
 			extra_cs_count = (last_cs == 7) ? 1 : 2;
 		else /*  ep_type : INTR IN / INTR OUT */
-			extra_cs_count = (fs_budget_start == 6) ? 1 : 2;
+			extra_cs_count = 1;
 
 		cs_count += extra_cs_count;
 		if (cs_count > 7)
 			cs_count = 7; /* HW limit */
 
-		for (i = 0; i < cs_count + 2; i++) {
-			if (test_bit(offset + i, tt->ss_bit_map))
-				return -ERANGE;
-		}
+		if (test_bit(offset, tt->ss_bit_map))
+			return -ERANGE;
 
 		sch_ep->cs_count = cs_count;
 		/* one for ss, the other for idle */
-- 
2.35.1



