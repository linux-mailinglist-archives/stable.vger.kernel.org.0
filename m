Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E006044FB
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbiJSMTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233176AbiJSMTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:19:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B631E1DF20;
        Wed, 19 Oct 2022 04:54:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F5BF6186B;
        Wed, 19 Oct 2022 09:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CCCC433B5;
        Wed, 19 Oct 2022 09:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170390;
        bh=YV9SNubNHp2LHE3ZQBiNdjtXaux/DEG9x6Hhp3wRTGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VXYO5drseuSGA3JIYxg6CoTOP0etYhzsfOBBiChh32t97Isg0ph0aj/0bXsrY7NMW
         xEhv4JwMUWs/AK8WlD9td6NL04YWQ+gbjbLoo01QCa78xGzgd2oQ50/bvkSIWRvrL7
         fvPxRQlC1/FyIYzIg1b7if7P8sM6VnEptZGgRJCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Ying <victor.liu@nxp.com>,
        Peng Fan <peng.fan@nxp.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 602/862] mailbox: imx: fix RST channel support
Date:   Wed, 19 Oct 2022 10:31:29 +0200
Message-Id: <20221019083316.545213987@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 7e5cd064f73ccecd2ac1aadca078394bd25ea3ce ]

Because IMX_MU_xCR_MAX was increased to 5, some mu cfgs were not updated
to include the CR register. Add the missed CR register to xcr array.

Fixes: 82ab513baed5 ("mailbox: imx: support RST channel")
Reported-by: Liu Ying <victor.liu@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Tested-by: Liu Ying <victor.liu@nxp.com> # i.MX8qm/qxp MEK boards boot
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/imx-mailbox.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mailbox/imx-mailbox.c b/drivers/mailbox/imx-mailbox.c
index 02922073c9ef..20f2ec880ad6 100644
--- a/drivers/mailbox/imx-mailbox.c
+++ b/drivers/mailbox/imx-mailbox.c
@@ -904,7 +904,7 @@ static const struct imx_mu_dcfg imx_mu_cfg_imx7ulp = {
 	.xTR	= 0x20,
 	.xRR	= 0x40,
 	.xSR	= {0x60, 0x60, 0x60, 0x60},
-	.xCR	= {0x64, 0x64, 0x64, 0x64},
+	.xCR	= {0x64, 0x64, 0x64, 0x64, 0x64},
 };
 
 static const struct imx_mu_dcfg imx_mu_cfg_imx8ulp = {
@@ -927,7 +927,7 @@ static const struct imx_mu_dcfg imx_mu_cfg_imx8ulp_s4 = {
 	.xTR	= 0x200,
 	.xRR	= 0x280,
 	.xSR	= {0xC, 0x118, 0x124, 0x12C},
-	.xCR	= {0x110, 0x114, 0x120, 0x128},
+	.xCR	= {0x8, 0x110, 0x114, 0x120, 0x128},
 };
 
 static const struct imx_mu_dcfg imx_mu_cfg_imx93_s4 = {
@@ -938,7 +938,7 @@ static const struct imx_mu_dcfg imx_mu_cfg_imx93_s4 = {
 	.xTR	= 0x200,
 	.xRR	= 0x280,
 	.xSR	= {0xC, 0x118, 0x124, 0x12C},
-	.xCR	= {0x110, 0x114, 0x120, 0x128},
+	.xCR	= {0x8, 0x110, 0x114, 0x120, 0x128},
 };
 
 static const struct imx_mu_dcfg imx_mu_cfg_imx8_scu = {
@@ -949,7 +949,7 @@ static const struct imx_mu_dcfg imx_mu_cfg_imx8_scu = {
 	.xTR	= 0x0,
 	.xRR	= 0x10,
 	.xSR	= {0x20, 0x20, 0x20, 0x20},
-	.xCR	= {0x24, 0x24, 0x24, 0x24},
+	.xCR	= {0x24, 0x24, 0x24, 0x24, 0x24},
 };
 
 static const struct imx_mu_dcfg imx_mu_cfg_imx8_seco = {
@@ -960,7 +960,7 @@ static const struct imx_mu_dcfg imx_mu_cfg_imx8_seco = {
 	.xTR	= 0x0,
 	.xRR	= 0x10,
 	.xSR	= {0x20, 0x20, 0x20, 0x20},
-	.xCR	= {0x24, 0x24, 0x24, 0x24},
+	.xCR	= {0x24, 0x24, 0x24, 0x24, 0x24},
 };
 
 static const struct of_device_id imx_mu_dt_ids[] = {
-- 
2.35.1



