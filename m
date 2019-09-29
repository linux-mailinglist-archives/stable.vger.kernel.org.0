Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9333C152E
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729468AbfI2OBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:01:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730075AbfI2OBm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:01:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49ADB2086A;
        Sun, 29 Sep 2019 14:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765702;
        bh=/N4BNUim2ujhrBzUpyfOBCNZJx17ZezEr41HEe4TTRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gruy2G3fuFI3T7L55Gp/ba3qEQvysbUu049K+bs0NY1Srr7wOQUBRdvuiyngtDdNP
         LuD7RqMkREKYKIhr1VRRs7cpqpdKb3S6pPKdc+ccdZfB9zksaHhWRgz/BZLszHW3fq
         5J4PBuH5NfcwWubev3b6cycMQcldXlCG6ORhXGz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Abel Vesa <abel.vesa@nxp.com>, Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.2 20/45] clk: imx: imx8mm: fix audio pll setting
Date:   Sun, 29 Sep 2019 15:55:48 +0200
Message-Id: <20190929135030.441236419@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135024.387033930@linuxfoundation.org>
References: <20190929135024.387033930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

commit 053a4ffe298836bb973d2cba59f82fff60c7db5b upstream.

The AUDIO PLL max support 650M, so the original clk settings violate
spec. This patch makes the output 786432000 -> 393216000,
and 722534400 -> 361267200 to aligned with NXP vendor kernel without any
impact on audio functionality and go within 650MHz PLL limit.

Cc: <stable@vger.kernel.org>
Fixes: ba5625c3e272 ("clk: imx: Add clock driver support for imx8mm")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Acked-by: Abel Vesa <abel.vesa@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/imx/clk-imx8mm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/clk/imx/clk-imx8mm.c
+++ b/drivers/clk/imx/clk-imx8mm.c
@@ -55,8 +55,8 @@ static const struct imx_pll14xx_rate_tab
 };
 
 static const struct imx_pll14xx_rate_table imx8mm_audiopll_tbl[] = {
-	PLL_1443X_RATE(786432000U, 655, 5, 2, 23593),
-	PLL_1443X_RATE(722534400U, 301, 5, 1, 3670),
+	PLL_1443X_RATE(393216000U, 262, 2, 3, 9437),
+	PLL_1443X_RATE(361267200U, 361, 3, 3, 17511),
 };
 
 static const struct imx_pll14xx_rate_table imx8mm_videopll_tbl[] = {


