Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4910E4EF38A
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349738AbiDAO5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348340AbiDAOwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:52:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D592B4A76;
        Fri,  1 Apr 2022 07:42:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78FCAB82500;
        Fri,  1 Apr 2022 14:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D84C3410F;
        Fri,  1 Apr 2022 14:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824151;
        bh=K6FeWVmXG3xj/jlF00WeWCIZWm/+qO1HLrMEDR0Tuiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eAAebSeTQE6bOzHvG74nLXeG6f4eGq4EyxC7OHCLdFFQ0Dy6oIDsfACb5jS4/0jlC
         /PA9IKu7H8T0Gk1iVFEPqY81gmNCl9P+1kTtdCcyAYy/IyB9NGV8hpulfBcy/uJFw8
         niiPIxLKgtTO0MOYFFrKQfcFkW8Th5xSuNKCyemJHHgGeoc0AmPOJSSGbPrMq/DDZa
         z3P83foyDeSluw7HNf76G7CzdFk8vMibctVSDiYZkNTxlTatcn+zVk71P6OclLRA2h
         5kGkxD/po81yCsmFTWyPWkKnZCLpDZtJwdKtFUjG7SzCprv4Pvo5ZxM9o038NoebWx
         ZOnSiy0gyCo8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wayne Chang <waynec@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, balbi@kernel.org,
        thierry.reding@gmail.com, jonathanh@nvidia.com,
        yangyingliang@huawei.com, chunfeng.yun@mediatek.com,
        rikard.falkeborn@gmail.com, jakobkoschel@gmail.com,
        linux-usb@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/65] usb: gadget: tegra-xudc: Fix control endpoint's definitions
Date:   Fri,  1 Apr 2022 10:41:07 -0400
Message-Id: <20220401144206.1953700-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144206.1953700-1-sashal@kernel.org>
References: <20220401144206.1953700-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wayne Chang <waynec@nvidia.com>

[ Upstream commit 7bd42fb95eb4f98495ccadf467ad15124208ec49 ]

According to the Tegra Technical Reference Manual, the seq_num
field of control endpoint is not [31:24] but [31:27]. Bit 24
is reserved and bit 26 is splitxstate.

The change fixes the wrong control endpoint's definitions.

Signed-off-by: Wayne Chang <waynec@nvidia.com>
Link: https://lore.kernel.org/r/20220107091349.149798-1-waynec@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/tegra-xudc.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/tegra-xudc.c b/drivers/usb/gadget/udc/tegra-xudc.c
index 1dd0d50c6b56..de178bf264c2 100644
--- a/drivers/usb/gadget/udc/tegra-xudc.c
+++ b/drivers/usb/gadget/udc/tegra-xudc.c
@@ -272,8 +272,10 @@ BUILD_EP_CONTEXT_RW(deq_hi, deq_hi, 0, 0xffffffff)
 BUILD_EP_CONTEXT_RW(avg_trb_len, tx_info, 0, 0xffff)
 BUILD_EP_CONTEXT_RW(max_esit_payload, tx_info, 16, 0xffff)
 BUILD_EP_CONTEXT_RW(edtla, rsvd[0], 0, 0xffffff)
-BUILD_EP_CONTEXT_RW(seq_num, rsvd[0], 24, 0xff)
+BUILD_EP_CONTEXT_RW(rsvd, rsvd[0], 24, 0x1)
 BUILD_EP_CONTEXT_RW(partial_td, rsvd[0], 25, 0x1)
+BUILD_EP_CONTEXT_RW(splitxstate, rsvd[0], 26, 0x1)
+BUILD_EP_CONTEXT_RW(seq_num, rsvd[0], 27, 0x1f)
 BUILD_EP_CONTEXT_RW(cerrcnt, rsvd[1], 18, 0x3)
 BUILD_EP_CONTEXT_RW(data_offset, rsvd[2], 0, 0x1ffff)
 BUILD_EP_CONTEXT_RW(numtrbs, rsvd[2], 22, 0x1f)
@@ -1554,6 +1556,9 @@ static int __tegra_xudc_ep_set_halt(struct tegra_xudc_ep *ep, bool halt)
 		ep_reload(xudc, ep->index);
 
 		ep_ctx_write_state(ep->context, EP_STATE_RUNNING);
+		ep_ctx_write_rsvd(ep->context, 0);
+		ep_ctx_write_partial_td(ep->context, 0);
+		ep_ctx_write_splitxstate(ep->context, 0);
 		ep_ctx_write_seq_num(ep->context, 0);
 
 		ep_reload(xudc, ep->index);
@@ -2809,7 +2814,10 @@ static void tegra_xudc_reset(struct tegra_xudc *xudc)
 	xudc->setup_seq_num = 0;
 	xudc->queued_setup_packet = false;
 
-	ep_ctx_write_seq_num(ep0->context, xudc->setup_seq_num);
+	ep_ctx_write_rsvd(ep0->context, 0);
+	ep_ctx_write_partial_td(ep0->context, 0);
+	ep_ctx_write_splitxstate(ep0->context, 0);
+	ep_ctx_write_seq_num(ep0->context, 0);
 
 	deq_ptr = trb_virt_to_phys(ep0, &ep0->transfer_ring[ep0->deq_ptr]);
 
-- 
2.34.1

