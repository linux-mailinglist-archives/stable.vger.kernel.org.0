Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0C34F3373
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350520AbiDEJ6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344060AbiDEJRW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:17:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD3B20192;
        Tue,  5 Apr 2022 02:03:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAD72614E4;
        Tue,  5 Apr 2022 09:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFAE9C385A0;
        Tue,  5 Apr 2022 09:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149434;
        bh=4xVP+rc9dkDWqE/NBcuMen4mqzFB0WGjI6QqAFNahww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T1Q9oDFXx7Q10TYYQF6HatDxsJ0aXwmFvwsEmFBTy33aPzXwH4OZmuWycxdhOK5pZ
         sMsbTckQMX9ardQieD5gVq+0wuEe4fZ3RVfMDq/BG1U8lFse7XQHJbPYu3DOh0CNFX
         SVFTBhMZZPN5HMq1hPHXiQCLrw3wQdMTwIbbE0B8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Abel Vesa <abel.vesa@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0675/1017] clk: imx: off by one in imx_lpcg_parse_clks_from_dt()
Date:   Tue,  5 Apr 2022 09:26:28 +0200
Message-Id: <20220405070414.315845337@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 135efc3a76d127691afaf1864e4ab627bf09d53d ]

The > needs to be >= to prevent an off by one access.

Fixes: d5f1e6a2bb61 ("clk: imx: imx8qxp-lpcg: add parsing clocks from device tree")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Abel Vesa <abel.vesa@nxp.com>
Link: https://lore.kernel.org/r/20220228075014.GD13685@kili
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8qxp-lpcg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx8qxp-lpcg.c b/drivers/clk/imx/clk-imx8qxp-lpcg.c
index b23758083ce5..5e31a6a24b3a 100644
--- a/drivers/clk/imx/clk-imx8qxp-lpcg.c
+++ b/drivers/clk/imx/clk-imx8qxp-lpcg.c
@@ -248,7 +248,7 @@ static int imx_lpcg_parse_clks_from_dt(struct platform_device *pdev,
 
 	for (i = 0; i < count; i++) {
 		idx = bit_offset[i] / 4;
-		if (idx > IMX_LPCG_MAX_CLKS) {
+		if (idx >= IMX_LPCG_MAX_CLKS) {
 			dev_warn(&pdev->dev, "invalid bit offset of clock %d\n",
 				 i);
 			ret = -EINVAL;
-- 
2.34.1



