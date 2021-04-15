Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74B93608CE
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 14:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbhDOME0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 08:04:26 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:59446 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbhDOMEZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 08:04:25 -0400
Date:   Thu, 15 Apr 2021 12:04:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1618488242;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HjW+fGapdaU/U7cAdKjWGX9kgg5+XP8t8iSoVF1oxc8=;
        b=Iff7JdEf0Id0S6CIX/5SVKyk2PAS/KHd0HBH/8BuchsKy2e4JXwFCkdrP/hVLxtC6m99nc
        FjbNQa76evJjqSkwFDpidZ+B+dQDd+p2f0K20NkgV0MVvKlaZWZ1qEO2+nlOGIEfMeJEuZ
        pu2X/o9aZiqIHZYvDVxtKWvx7hlNew9vtTTQl/qnQGBEgUpGlGUNDPu3GBFu6fgubfF7Ga
        qCu4AWo5tbNvwqZFZCt51ir7KwY7uCA4b/krTgVtvyRqXQevnwgAj5Rox0666xIhVmI+CJ
        3XnXCuquYc0Iv0x558pSzoU49OYPMJLvEV6IKcqIxbSGjpEy5TRpxRthqwGaAg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1618488242;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HjW+fGapdaU/U7cAdKjWGX9kgg5+XP8t8iSoVF1oxc8=;
        b=vJ8g/sz3eK09LTCIvfRXjxZdRd8UDI9lLx7XlEmO90DUXXz/VsB1aWWQigDS1oKxY3naG6
        DgAHHEred1eUHTBQ==
From:   "thermal-bot for brian-sy yang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-pm@vger.kernel.org
To:     linux-pm@vger.kernel.org
Subject: [thermal: thermal/next] thermal/drivers/cpufreq_cooling: Fix slab OOB issue
Cc:     "brian-sy yang" <brian-sy.yang@mediatek.com>,
        Michael Kao <michael.kao@mediatek.com>,
        Lukasz Luba <lukasz.luba@arm.com>, stable@vger.kernel.org,
        #v5.7@tip-bot2.tec.linutronix.de,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        rui.zhang@intel.com, amitk@kernel.org
In-Reply-To: <20201229050831.19493-1-michael.kao@mediatek.com>
References: <20201229050831.19493-1-michael.kao@mediatek.com>
MIME-Version: 1.0
Message-ID: <161848824126.29796.11373237838275688493.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the thermal/next branch of thermal:

Commit-ID:     34ab17cc6c2c1ac93d7e5d53bb972df9a968f085
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/thermal/linux.git//34ab17cc6c2c1ac93d7e5d53bb972df9a968f085
Author:        brian-sy yang <brian-sy.yang@mediatek.com>
AuthorDate:    Tue, 29 Dec 2020 13:08:31 +08:00
Committer:     Daniel Lezcano <daniel.lezcano@linaro.org>
CommitterDate: Thu, 15 Apr 2021 13:21:42 +02:00

thermal/drivers/cpufreq_cooling: Fix slab OOB issue

Slab OOB issue is scanned by KASAN in cpu_power_to_freq().
If power is limited below the power of OPP0 in EM table,
it will cause slab out-of-bound issue with negative array
index.

Return the lowest frequency if limited power cannot found
a suitable OPP in EM table to fix this issue.

Backtrace:
[<ffffffd02d2a37f0>] die+0x104/0x5ac
[<ffffffd02d2a5630>] bug_handler+0x64/0xd0
[<ffffffd02d288ce4>] brk_handler+0x160/0x258
[<ffffffd02d281e5c>] do_debug_exception+0x248/0x3f0
[<ffffffd02d284488>] el1_dbg+0x14/0xbc
[<ffffffd02d75d1d4>] __kasan_report+0x1dc/0x1e0
[<ffffffd02d75c2e0>] kasan_report+0x10/0x20
[<ffffffd02d75def8>] __asan_report_load8_noabort+0x18/0x28
[<ffffffd02e6fce5c>] cpufreq_power2state+0x180/0x43c
[<ffffffd02e6ead80>] power_actor_set_power+0x114/0x1d4
[<ffffffd02e6fac24>] allocate_power+0xaec/0xde0
[<ffffffd02e6f9f80>] power_allocator_throttle+0x3ec/0x5a4
[<ffffffd02e6ea888>] handle_thermal_trip+0x160/0x294
[<ffffffd02e6edd08>] thermal_zone_device_check+0xe4/0x154
[<ffffffd02d351cb4>] process_one_work+0x5e4/0xe28
[<ffffffd02d352f44>] worker_thread+0xa4c/0xfac
[<ffffffd02d360124>] kthread+0x33c/0x358
[<ffffffd02d289940>] ret_from_fork+0xc/0x18

Fixes: 371a3bc79c11b ("thermal/drivers/cpufreq_cooling: Fix wrong frequency converted from power")
Signed-off-by: brian-sy yang <brian-sy.yang@mediatek.com>
Signed-off-by: Michael Kao <michael.kao@mediatek.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Cc: stable@vger.kernel.org #v5.7
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20201229050831.19493-1-michael.kao@mediatek.com
---
 drivers/thermal/cpufreq_cooling.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/cpufreq_cooling.c b/drivers/thermal/cpufreq_cooling.c
index f3d3084..eeb4e4b 100644
--- a/drivers/thermal/cpufreq_cooling.c
+++ b/drivers/thermal/cpufreq_cooling.c
@@ -116,7 +116,7 @@ static u32 cpu_power_to_freq(struct cpufreq_cooling_device *cpufreq_cdev,
 {
 	int i;
 
-	for (i = cpufreq_cdev->max_level; i >= 0; i--) {
+	for (i = cpufreq_cdev->max_level; i > 0; i--) {
 		if (power >= cpufreq_cdev->em->table[i].power)
 			break;
 	}
