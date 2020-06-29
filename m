Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B23120DF2D
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732009AbgF2Ucw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:32:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732398AbgF2TZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90937253A9;
        Mon, 29 Jun 2020 15:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445274;
        bh=cPJjhIRuVR6ILETKUiSiAnd68luBbKR16bzeD9+IJi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fToyxOt/AQBwRlbqU/YTPfTbfQ2lXZrzl/WmzUM56A9InEIq3J0V+iTSVJDbqUhfR
         94tJbNATwCrgGHWgxwk9/H0KTGR7kS/n8fQEvxFwh751rWAHfdTkNzoqXvRg1vhleC
         Y2uxc4moUgYhEnMPjpq/BLwiB5JIHvvJURorfH0w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Riedmueller <s.riedmueller@phytec.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 053/191] watchdog: da9062: No need to ping manually before setting timeout
Date:   Mon, 29 Jun 2020 11:37:49 -0400
Message-Id: <20200629154007.2495120-54-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
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
index daeb645fcea8a..519419136ce8f 100644
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

