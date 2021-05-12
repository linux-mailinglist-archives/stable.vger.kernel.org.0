Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F0737C202
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhELPGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232933AbhELPCV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:02:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7A616141C;
        Wed, 12 May 2021 14:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831468;
        bh=3FY3LSJkyBVhVObknXBWwseho00yLrUhua+TlElKQHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DOSxVR6ZK3/FLmi62KMxWyXl+710uWQJa/KLZsAVNF+BY2FQI3gBwflwYIV/qFWnt
         7mnTbLjwco4KhkjybYMRAMC65OYerckqb4dDwywpbbqjlUA947Z4STp9QVJ8E4eZad
         VbzyQMGrVCOzZy946d0FgxggE1CKvxBSXxetSFdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 132/244] platform/x86: pmc_atom: Match all Beckhoff Automation baytrail boards with critclk_systems DMI table
Date:   Wed, 12 May 2021 16:48:23 +0200
Message-Id: <20210512144747.245473372@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
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
index 2b1a3a6ee8db..597cfabc0967 100644
--- a/drivers/platform/x86/pmc_atom.c
+++ b/drivers/platform/x86/pmc_atom.c
@@ -393,34 +393,10 @@ static const struct dmi_system_id critclk_systems[] = {
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



