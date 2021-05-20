Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6147738A412
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbhETKA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:00:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234475AbhETJ6l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:58:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88935616E9;
        Thu, 20 May 2021 09:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503509;
        bh=pUJJ4wUIHWL4vh10+km6cznYWaz+FSFjThVROwc1ScA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMcUH+sgqGknvpGnQYQZXScO887+jyMztf3V+l2VdVL+5mw/m92kj6VfCrJYmHnla
         WYgMJGZUWvfMO7kopzC6KAWF4vk9DMR1DD+bLO5TJA7J/irhEtIBVmXfM2eDDK5Df3
         jHZ2FGRuqzfsDwin3ECKRTJ5S97sw2UHjdXomGoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 219/425] platform/x86: pmc_atom: Match all Beckhoff Automation baytrail boards with critclk_systems DMI table
Date:   Thu, 20 May 2021 11:19:48 +0200
Message-Id: <20210520092138.619478005@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
index 26351e9e0aaf..682fc49d172c 100644
--- a/drivers/platform/x86/pmc_atom.c
+++ b/drivers/platform/x86/pmc_atom.c
@@ -423,34 +423,10 @@ static const struct dmi_system_id critclk_systems[] = {
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



