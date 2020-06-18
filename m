Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0F41FDED5
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732704AbgFRBbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:31:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731944AbgFRBbE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:31:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1DCB20773;
        Thu, 18 Jun 2020 01:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443863;
        bh=8W6kvC6JpX2I97mxdcnHI2EdMQdoHORQS6HfrtQPFY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rG5eIcP5ReH3OEdgJXT7oPC0tZRHN9VdiSWYQKBallIDf1HH3WPS9+4C5C+12yD/p
         lqxZNJsPPf3/x0L7QUFHd7ySOLZRiH58b/lvblCRwKS3CWjGN41aVny04TEPjvPgyo
         qehna657rpWvqbY5juwYi3ptEzVYmfFgckR6GBEE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Riedmueller <s.riedmueller@phytec.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>, linux-watchdog@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 45/60] watchdog: da9062: No need to ping manually before setting timeout
Date:   Wed, 17 Jun 2020 21:29:49 -0400
Message-Id: <20200618013004.610532-45-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618013004.610532-1-sashal@kernel.org>
References: <20200618013004.610532-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index daeb645fcea8..519419136ce8 100644
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

