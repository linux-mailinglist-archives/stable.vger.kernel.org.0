Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 662F14D672
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbfFTSIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:08:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728445AbfFTSIJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:08:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB58421530;
        Thu, 20 Jun 2019 18:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054089;
        bh=55nd4aDpkQL1z1L91wINU7ZA7x024voUYjIyKe4/TGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cHpnHa945AzUf6gxqlFMvOMI3fXg+3l7m0SvHQuEQSCeHmxKfcwLD3Jx9ORr2u5fw
         wkgPZDTedBxpYmJ3XMGScKa3X8d86Xi8fuQsTYxfav1i7tDF/9+QZpzm9wQnf0mHAS
         ptrhtOL83iVVea1aM3vZ/HatF8b2m0t1r1fIbGHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 15/45] clk: ti: clkctrl: Fix clkdm_clk handling
Date:   Thu, 20 Jun 2019 19:57:17 +0200
Message-Id: <20190620174334.527439076@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174328.608036501@linuxfoundation.org>
References: <20190620174328.608036501@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1cc54078d104f5b4d7e9f8d55362efa5a8daffdb ]

We need to always call clkdm_clk_enable() and clkdm_clk_disable() even
the clkctrl clock(s) enabled for the domain do not have any gate register
bits. Otherwise clockdomains may never get enabled except when devices get
probed with the legacy "ti,hwmods" devicetree property.

Fixes: 88a172526c32 ("clk: ti: add support for clkctrl clocks")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/clkctrl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/ti/clkctrl.c b/drivers/clk/ti/clkctrl.c
index 53e71d0503ec..82e4d5cccf84 100644
--- a/drivers/clk/ti/clkctrl.c
+++ b/drivers/clk/ti/clkctrl.c
@@ -124,9 +124,6 @@ static int _omap4_clkctrl_clk_enable(struct clk_hw *hw)
 	int ret;
 	union omap4_timeout timeout = { 0 };
 
-	if (!clk->enable_bit)
-		return 0;
-
 	if (clk->clkdm) {
 		ret = ti_clk_ll_ops->clkdm_clk_enable(clk->clkdm, hw->clk);
 		if (ret) {
@@ -138,6 +135,9 @@ static int _omap4_clkctrl_clk_enable(struct clk_hw *hw)
 		}
 	}
 
+	if (!clk->enable_bit)
+		return 0;
+
 	val = ti_clk_ll_ops->clk_readl(&clk->enable_reg);
 
 	val &= ~OMAP4_MODULEMODE_MASK;
@@ -166,7 +166,7 @@ static void _omap4_clkctrl_clk_disable(struct clk_hw *hw)
 	union omap4_timeout timeout = { 0 };
 
 	if (!clk->enable_bit)
-		return;
+		goto exit;
 
 	val = ti_clk_ll_ops->clk_readl(&clk->enable_reg);
 
-- 
2.20.1



