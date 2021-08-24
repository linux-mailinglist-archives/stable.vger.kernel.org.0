Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38DD13F66A6
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbhHXR0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:26:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239937AbhHXRYA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:24:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1EAE61B27;
        Tue, 24 Aug 2021 17:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824629;
        bh=yGpHqiBGaRE9YFKtU/zWC4lpZWxkBtcp73H+QXL0ftM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h2TqydCxzSfv9jveYQCDu8ZI5pnM6Rg2AgKZ0fvZJZ0LUaG7xTH98hnfAvcfOIWQo
         DCLLqr+TMq7BQlMj1+rpUKk3WE8qVFmWwFYRLvtwKHrg6gV5oqhv70d8VxgYM3w786
         Lge7qtMs03JJT8M7XuMt97DJR7TflbwEi79na9WAwW1+Tz70FoYLAradblFxOhxxpI
         yZ/N7elQKaK7jL5aoJ0PsvGNyfq/foFZwvURZDLKFFMUwVfFz+ZUolfxlkmfLvUGIS
         JIUZugxMteH+uMbnxm0ik9f5Jty3Af+wziK5mXTVL+qUvj9pY03WmRe+jHRn3Dr5ra
         1lQUgzd3Jl5fg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 60/84] cpufreq: armada-37xx: forbid cpufreq for 1.2 GHz variant
Date:   Tue, 24 Aug 2021 13:02:26 -0400
Message-Id: <20210824170250.710392-61-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 484f2b7c61b9ae58cc00c5127bcbcd9177af8dfe ]

The 1.2 GHz variant of the Armada 3720 SOC is unstable with DVFS: when
the SOC boots, the WTMI firmware sets clocks and AVS values that work
correctly with 1.2 GHz CPU frequency, but random crashes occur once
cpufreq driver starts scaling.

We do not know currently what is the reason:
- it may be that the voltage value for L0 for 1.2 GHz variant provided
  by the vendor in the OTP is simply incorrect when scaling is used,
- it may be that some delay is needed somewhere,
- it may be something else.

The most sane solution now seems to be to simply forbid the cpufreq
driver on 1.2 GHz variant.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: 92ce45fb875d ("cpufreq: Add DVFS support for Armada 37xx")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/armada-37xx-cpufreq.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/armada-37xx-cpufreq.c b/drivers/cpufreq/armada-37xx-cpufreq.c
index a36452bd9612..31b5655419b4 100644
--- a/drivers/cpufreq/armada-37xx-cpufreq.c
+++ b/drivers/cpufreq/armada-37xx-cpufreq.c
@@ -102,7 +102,11 @@ struct armada_37xx_dvfs {
 };
 
 static struct armada_37xx_dvfs armada_37xx_dvfs[] = {
-	{.cpu_freq_max = 1200*1000*1000, .divider = {1, 2, 4, 6} },
+	/*
+	 * The cpufreq scaling for 1.2 GHz variant of the SOC is currently
+	 * unstable because we do not know how to configure it properly.
+	 */
+	/* {.cpu_freq_max = 1200*1000*1000, .divider = {1, 2, 4, 6} }, */
 	{.cpu_freq_max = 1000*1000*1000, .divider = {1, 2, 4, 5} },
 	{.cpu_freq_max = 800*1000*1000,  .divider = {1, 2, 3, 4} },
 	{.cpu_freq_max = 600*1000*1000,  .divider = {2, 4, 5, 6} },
-- 
2.30.2

