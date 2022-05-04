Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF0651A8C5
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355970AbiEDRMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356948AbiEDRJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98354739D;
        Wed,  4 May 2022 09:56:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1F7BB82552;
        Wed,  4 May 2022 16:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8B9C385A5;
        Wed,  4 May 2022 16:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683393;
        bh=gsJsR9hIHdRHIG5DHXKcbKlv++R5++gW2cCn58NuCvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WR69ga17PI0ux+FhMuExGxgg5vvvAVD0Ea1bCPQJRY9Q8PWymjiv9oDVFUkLB6SQA
         DbJU9aVtWeB6OnfWMphtuX4lz/ZQvr4GS/A+T/IA95PLTUjnbj8Ch4fkNTiSg6JtrY
         KIq3SoBsnKBN3AgfgS/vvWFWD1gZD1FEWWNKRt7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 070/225] soc: imx: imx8m-blk-ctrl: Fix IMX8MN_DISPBLK_PD_ISI hang
Date:   Wed,  4 May 2022 18:45:08 +0200
Message-Id: <20220504153117.783718798@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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

From: Adam Ford <aford173@gmail.com>

[ Upstream commit e2aa165cd0163cef83cb295eb572aa9fb1604cf4 ]

The imx8mn clock list for the ISI lists four clocks, but DOMAIN_MAX_CLKS
was set to 3.  Because of this, attempts to enable the fourth clock failed,
threw some splat, and ultimately hung.

Fixes: 7f511d514e8c ("soc: imx: imx8m-blk-ctrl: add i.MX8MN DISP blk-ctrl")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/imx8m-blk-ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/imx/imx8m-blk-ctrl.c b/drivers/soc/imx/imx8m-blk-ctrl.c
index 511e74f0db8a..e096cca9f18a 100644
--- a/drivers/soc/imx/imx8m-blk-ctrl.c
+++ b/drivers/soc/imx/imx8m-blk-ctrl.c
@@ -49,7 +49,7 @@ struct imx8m_blk_ctrl_domain_data {
 	u32 mipi_phy_rst_mask;
 };
 
-#define DOMAIN_MAX_CLKS 3
+#define DOMAIN_MAX_CLKS 4
 
 struct imx8m_blk_ctrl_domain {
 	struct generic_pm_domain genpd;
-- 
2.35.1



