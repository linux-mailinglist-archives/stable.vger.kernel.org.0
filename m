Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94CA95DBF1
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 04:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbfGCCSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 22:18:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728276AbfGCCSc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 22:18:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 034B621874;
        Wed,  3 Jul 2019 02:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120311;
        bh=blrMzjnG4BFCaJAhYzSyPoEnFsnOWYXtexx/u2A++Cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CTJJxUXVJ+yppHlHyp7GB9nNyWx7rftCPbfX21vd8afSzyotQmOi49MbY7egKu539
         0x+ukxKW66mGg/p0JhBA4B3ZTemG0RkSWx1oU3tnKBElV4Xf73M+83qs32C2khLf8w
         3etm1TKA5E85+eD6R8oab6KUrgNgWxX8af3UFjqI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eiichi Tsukata <devel@etsukata.com>,
        Thomas Gleixner <tglx@linutronix.de>, peterz@infradead.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 12/13] cpu/hotplug: Fix out-of-bounds read when setting fail state
Date:   Tue,  2 Jul 2019 22:18:13 -0400
Message-Id: <20190703021814.18385-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703021814.18385-1-sashal@kernel.org>
References: <20190703021814.18385-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eiichi Tsukata <devel@etsukata.com>

[ Upstream commit 33d4a5a7a5b4d02915d765064b2319e90a11cbde ]

Setting invalid value to /sys/devices/system/cpu/cpuX/hotplug/fail
can control `struct cpuhp_step *sp` address, results in the following
global-out-of-bounds read.

Reproducer:

  # echo -2 > /sys/devices/system/cpu/cpu0/hotplug/fail

KASAN report:

  BUG: KASAN: global-out-of-bounds in write_cpuhp_fail+0x2cd/0x2e0
  Read of size 8 at addr ffffffff89734438 by task bash/1941

  CPU: 0 PID: 1941 Comm: bash Not tainted 5.2.0-rc6+ #31
  Call Trace:
   write_cpuhp_fail+0x2cd/0x2e0
   dev_attr_store+0x58/0x80
   sysfs_kf_write+0x13d/0x1a0
   kernfs_fop_write+0x2bc/0x460
   vfs_write+0x1e1/0x560
   ksys_write+0x126/0x250
   do_syscall_64+0xc1/0x390
   entry_SYSCALL_64_after_hwframe+0x49/0xbe
  RIP: 0033:0x7f05e4f4c970

  The buggy address belongs to the variable:
   cpu_hotplug_lock+0x98/0xa0

  Memory state around the buggy address:
   ffffffff89734300: fa fa fa fa 00 00 00 00 00 00 00 00 00 00 00 00
   ffffffff89734380: fa fa fa fa 00 00 00 00 00 00 00 00 00 00 00 00
  >ffffffff89734400: 00 00 00 00 fa fa fa fa 00 00 00 00 fa fa fa fa
                                          ^
   ffffffff89734480: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   ffffffff89734500: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

Add a sanity check for the value written from user space.

Fixes: 1db49484f21ed ("smp/hotplug: Hotplug state fail injection")
Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: peterz@infradead.org
Link: https://lkml.kernel.org/r/20190627024732.31672-1-devel@etsukata.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cpu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 127a69b8b192..5a10390b09de 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1944,6 +1944,9 @@ static ssize_t write_cpuhp_fail(struct device *dev,
 	if (ret)
 		return ret;
 
+	if (fail < CPUHP_OFFLINE || fail > CPUHP_ONLINE)
+		return -EINVAL;
+
 	/*
 	 * Cannot fail STARTING/DYING callbacks.
 	 */
-- 
2.20.1

