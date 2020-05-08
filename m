Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A811CAB8A
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgEHMoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:44:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729198AbgEHMod (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:44:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 436CF208D6;
        Fri,  8 May 2020 12:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941872;
        bh=+paItO5s4jfSbClbx7dPMpQsd3fzWtEyPMi442+bDpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YZzPISnW6X4f6KLTFqW+lrBBrXNlhMj/hFX96CKGffTVAJLifduGvxr5RI2TzPgAX
         QqEh8i1hg6ceXsS2lYLxZ5FR5wG0vbE0uCvc+JFgSAkqvK2ydlhKOv4geqFv4MI0Od
         /sHTkevuJX3MNAzc+74OZodJngKxsvn/Uf2Hcesg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dong Aisheng <aisheng.dong@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 4.4 206/312] clk: imx: clk-pllv3: fix incorrect handle of enet powerdown bit
Date:   Fri,  8 May 2020 14:33:17 +0200
Message-Id: <20200508123138.910534395@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dong Aisheng <aisheng.dong@nxp.com>

commit b3e76bdc0b2190e67427d31cd740debd01c03631 upstream.

After commit f53947456f98 ("ARM: clk: imx: update pllv3 to support imx7"),
the former used BM_PLL_POWER bit is not correct anymore for IMX7 ENET.
Instead, pll->powerdown holds the correct bit, so using powerdown bit
in clk_pllv3_{prepare | unprepare} functions.

Fixes: f53947456f98 ("ARM: clk: imx: update pllv3 to support imx7")
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/imx/clk-pllv3.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/clk/imx/clk-pllv3.c
+++ b/drivers/clk/imx/clk-pllv3.c
@@ -76,9 +76,9 @@ static int clk_pllv3_prepare(struct clk_
 
 	val = readl_relaxed(pll->base);
 	if (pll->powerup_set)
-		val |= BM_PLL_POWER;
+		val |= pll->powerdown;
 	else
-		val &= ~BM_PLL_POWER;
+		val &= ~pll->powerdown;
 	writel_relaxed(val, pll->base);
 
 	return clk_pllv3_wait_lock(pll);
@@ -91,9 +91,9 @@ static void clk_pllv3_unprepare(struct c
 
 	val = readl_relaxed(pll->base);
 	if (pll->powerup_set)
-		val &= ~BM_PLL_POWER;
+		val &= ~pll->powerdown;
 	else
-		val |= BM_PLL_POWER;
+		val |= pll->powerdown;
 	writel_relaxed(val, pll->base);
 }
 


