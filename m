Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C04378540
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbhEJK7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:59:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234001AbhEJKzo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:55:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78A216192C;
        Mon, 10 May 2021 10:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643397;
        bh=ZhuCGbi99ueUfGcvZCo8L1Za/9MQihnuSfx3f9Jvur4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUWPC9lAKCj4iBxyM51+ACz1EjGN2uUndW5z06p0YXY5tSf+lKHuWhi45XdG98j2j
         i1xGo+MzRQIYWYzmjHHOJXZ2J0rXdcAWM4ay2EvV+ivJaBN8gu3+CYX1WEhYfLzO0D
         SFjW8NsKynzCWKYTN9rbDJ4h+kbsZDzT/E58N938=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, brian-sy yang <brian-sy.yang@mediatek.com>,
        Michael Kao <michael.kao@mediatek.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.10 298/299] thermal/drivers/cpufreq_cooling: Fix slab OOB issue
Date:   Mon, 10 May 2021 12:21:35 +0200
Message-Id: <20210510102014.767545140@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: brian-sy yang <brian-sy.yang@mediatek.com>

commit 34ab17cc6c2c1ac93d7e5d53bb972df9a968f085 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/cpufreq_cooling.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thermal/cpufreq_cooling.c
+++ b/drivers/thermal/cpufreq_cooling.c
@@ -123,7 +123,7 @@ static u32 cpu_power_to_freq(struct cpuf
 {
 	int i;
 
-	for (i = cpufreq_cdev->max_level; i >= 0; i--) {
+	for (i = cpufreq_cdev->max_level; i > 0; i--) {
 		if (power >= cpufreq_cdev->em->table[i].power)
 			break;
 	}


