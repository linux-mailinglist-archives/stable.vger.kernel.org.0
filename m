Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 118F2593695
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239271AbiHOTMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343653AbiHOTJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:09:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0CA2AE6;
        Mon, 15 Aug 2022 11:36:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD1BC60FB8;
        Mon, 15 Aug 2022 18:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E29C433D6;
        Mon, 15 Aug 2022 18:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588569;
        bh=LReIQ89/CnA3hqpuGEtuig0bfblqLBYyZyH7Eeo99iI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UbvuNJsF2AuDcM0yb4vj/+LicC6Jt5DaC/yIHKtSCsnDHPQbS0QYKUtyWg3t/fvMw
         xFijbbIZYJUT3IukWNtQHF8OUXlZqHEtk8uV2n7VK+TPEzLBEIJ1Ndq5zUf+7juj/7
         NoqhpahkKeiEbeNdLRSqMWMEtTquTgAX2ESZz7pU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 445/779] clk: qcom: gcc-msm8939: Fix bimc_ddr_clk_src rcgr base address
Date:   Mon, 15 Aug 2022 20:01:29 +0200
Message-Id: <20220815180356.293797225@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 63d42708320d6d2ca9ed505123d50ff4a542c36f ]

Reviewing qcom docs for the 8939 we can see the command rcgr is pointing to
the wrong address. bimc_ddr_clk_src_rcgr is @ 0x01832024 not 0x01832004.

Fixes: 1664014e4679 ("clk: qcom: gcc-msm8939: Add MSM8939 Generic Clock Controller")
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220504163835.40130-3-bryan.odonoghue@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-msm8939.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-msm8939.c b/drivers/clk/qcom/gcc-msm8939.c
index 39ebb443ae3d..31568658d23d 100644
--- a/drivers/clk/qcom/gcc-msm8939.c
+++ b/drivers/clk/qcom/gcc-msm8939.c
@@ -632,7 +632,7 @@ static struct clk_rcg2 system_noc_bfdcd_clk_src = {
 };
 
 static struct clk_rcg2 bimc_ddr_clk_src = {
-	.cmd_rcgr = 0x32004,
+	.cmd_rcgr = 0x32024,
 	.hid_width = 5,
 	.parent_map = gcc_xo_gpll0_bimc_map,
 	.clkr.hw.init = &(struct clk_init_data){
-- 
2.35.1



