Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B899B492F9
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbfFQVZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:25:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729035AbfFQVZu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:25:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AF7220673;
        Mon, 17 Jun 2019 21:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806749;
        bh=tpYiwEGQ67hUfP/N2MI6rulNvqudaMCDEMbf3KGmCNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQorDKUHkg7WH3fqkbyrAt5f63fAEBYBB5k7pt0f9U9pOXk70SaMKvosyDOthBjya
         FKZAg5Chl6Etgk0Hompz4M9Ck3J1PCqqMVDrAIMaAjdd6aVa9iJedeRy6AddazWWVl
         em1Z90WrnFmzrjZC5QXAJLtrwTATGyBTSxsAuSe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Semyon Verchenko <semverchenko@factor-ts.ru>
Subject: [PATCH 4.19 44/75] platform/x86: pmc_atom: Add Lex 3I380D industrial PC to critclk_systems DMI table
Date:   Mon, 17 Jun 2019 23:09:55 +0200
Message-Id: <20190617210754.461919748@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3d0818f5eba80fbe4c0addbfe6ddb2d19dc82cd4 ]

The Lex 3I380D industrial PC has 4 ethernet controllers on board
which need pmc_plt_clk0 - 3 to function, add it to the critclk_systems
DMI table, so that drivers/clk/x86/clk-pmc-atom.c will mark the clocks
as CLK_CRITICAL and they will not get turned off.

Fixes: 648e921888ad ("clk: x86: Stop marking clocks as CLK_IS_CRITICAL")
Reported-and-tested-by: Semyon Verchenko <semverchenko@factor-ts.ru>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/pmc_atom.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/pmc_atom.c b/drivers/platform/x86/pmc_atom.c
index c7039f52ad51..a311f48ce7c9 100644
--- a/drivers/platform/x86/pmc_atom.c
+++ b/drivers/platform/x86/pmc_atom.c
@@ -398,12 +398,21 @@ static int pmc_dbgfs_register(struct pmc_dev *pmc)
  */
 static const struct dmi_system_id critclk_systems[] = {
 	{
+		/* pmc_plt_clk0 is used for an external HSIC USB HUB */
 		.ident = "MPL CEC1x",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "MPL AG"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "CEC10 Family"),
 		},
 	},
+	{
+		/* pmc_plt_clk0 - 3 are used for the 4 ethernet controllers */
+		.ident = "Lex 3I380D",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Lex BayTrail"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "3I380D"),
+		},
+	},
 	{ /*sentinel*/ }
 };
 
-- 
2.20.1



