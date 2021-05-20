Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1C438A6E6
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237304AbhETKbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:31:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237045AbhETK33 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:29:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C01B61C3A;
        Thu, 20 May 2021 09:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504281;
        bh=LdD+ZUYfvzHxZiSBwdzdSmm41ilw312hMDHiNRqdreY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TxHxfevhTB3b5L9YwySApfdN74wxNsBDZKZTD2HH0sn8S3/nPgWRe3NhTnfpYuFIJ
         hO+gEwrMZW/XBP/4qmwUGjZ9n5m2RaLcn5bhMfIHA05CFx5GInTgxO7z1DV0cj/XJP
         uxfFdbBGilHqyNnWEKfuONian0KLXbVcb6x7sp0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 175/323] platform/x86: pmc_atom: Match all Beckhoff Automation baytrail boards with critclk_systems DMI table
Date:   Thu, 20 May 2021 11:21:07 +0200
Message-Id: <20210520092126.116384324@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>

[ Upstream commit d21e5abd3a005253eb033090aab2e43bce090d89 ]

pmc_plt_clk* clocks are used for ethernet controllers, so need to stay
turned on. This adds the affected board family to critclk_systems DMI
table, so the clocks are marked as CLK_CRITICAL and not turned off.

This replaces the previously listed boards with a match for the whole
device family CBxx63. CBxx63 matches only baytrail devices.
There are new affected boards that would otherwise need to be listed.
There are unaffected boards in the family, but having the clocks
turned on is not an issue.

Fixes: 648e921888ad ("clk: x86: Stop marking clocks as CLK_IS_CRITICAL")
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>
Link: https://lore.kernel.org/r/20210412133006.397679-1-linux-kernel-dev@beckhoff.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/pmc_atom.c | 28 ++--------------------------
 1 file changed, 2 insertions(+), 26 deletions(-)

diff --git a/drivers/platform/x86/pmc_atom.c b/drivers/platform/x86/pmc_atom.c
index 92205b90c25c..d1d5ec3c0f14 100644
--- a/drivers/platform/x86/pmc_atom.c
+++ b/drivers/platform/x86/pmc_atom.c
@@ -453,34 +453,10 @@ static const struct dmi_system_id critclk_systems[] = {
 	},
 	{
 		/* pmc_plt_clk* - are used for ethernet controllers */
-		.ident = "Beckhoff CB3163",
+		.ident = "Beckhoff Baytrail",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Beckhoff Automation"),
-			DMI_MATCH(DMI_BOARD_NAME, "CB3163"),
-		},
-	},
-	{
-		/* pmc_plt_clk* - are used for ethernet controllers */
-		.ident = "Beckhoff CB4063",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Beckhoff Automation"),
-			DMI_MATCH(DMI_BOARD_NAME, "CB4063"),
-		},
-	},
-	{
-		/* pmc_plt_clk* - are used for ethernet controllers */
-		.ident = "Beckhoff CB6263",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Beckhoff Automation"),
-			DMI_MATCH(DMI_BOARD_NAME, "CB6263"),
-		},
-	},
-	{
-		/* pmc_plt_clk* - are used for ethernet controllers */
-		.ident = "Beckhoff CB6363",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Beckhoff Automation"),
-			DMI_MATCH(DMI_BOARD_NAME, "CB6363"),
+			DMI_MATCH(DMI_PRODUCT_FAMILY, "CBxx63"),
 		},
 	},
 	{
-- 
2.30.2



