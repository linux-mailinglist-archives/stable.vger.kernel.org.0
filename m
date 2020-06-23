Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A15F12061EA
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392854AbgFWUwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:52:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392699AbgFWUrh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:47:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A2C82098B;
        Tue, 23 Jun 2020 20:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945257;
        bh=uqj9LlV6wpnyksVFlwbmyPsNGWszrcyh1dI43T+emtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wUJkMCPOkHFC/rVgOibuCxmw4WIs3KNaeJr8wq2kRdTuGxLovrOJPMjbk8FIuNQAc
         1ovUL6TgCCAOpZQ4pNWhjqvXNJdogRdTgHNLFA+anIaFFT+1nE5WMHk5D6TPWNHR08
         XYT8FiAI6PTyEtvROz7ZVBD/7B/mV0xrrF32VK18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stefan Riedmueller <s.riedmueller@phytec.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 070/136] watchdog: da9062: No need to ping manually before setting timeout
Date:   Tue, 23 Jun 2020 21:58:46 +0200
Message-Id: <20200623195307.202137941@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Riedmueller <s.riedmueller@phytec.de>

[ Upstream commit a0948ddba65f4f6d3cfb5e2b84685485d0452966 ]

There is actually no need to ping the watchdog before disabling it
during timeout change. Disabling the watchdog already takes care of
resetting the counter.

This fixes an issue during boot when the userspace watchdog handler takes
over and the watchdog is already running. Opening the watchdog in this case
leads to the first ping and directly after that without the required
heartbeat delay a second ping issued by the set_timeout call. Due to the
missing delay this resulted in a reset.

Signed-off-by: Stefan Riedmueller <s.riedmueller@phytec.de>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Link: https://lore.kernel.org/r/20200403130728.39260-3-s.riedmueller@phytec.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/da9062_wdt.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/watchdog/da9062_wdt.c b/drivers/watchdog/da9062_wdt.c
index 79383ff620199..1443386bb590b 100644
--- a/drivers/watchdog/da9062_wdt.c
+++ b/drivers/watchdog/da9062_wdt.c
@@ -94,11 +94,6 @@ static int da9062_wdt_update_timeout_register(struct da9062_watchdog *wdt,
 					      unsigned int regval)
 {
 	struct da9062 *chip = wdt->hw;
-	int ret;
-
-	ret = da9062_reset_watchdog_timer(wdt);
-	if (ret)
-		return ret;
 
 	return regmap_update_bits(chip->regmap,
 				  DA9062AA_CONTROL_D,
-- 
2.25.1



