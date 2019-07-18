Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFBEA6C6EC
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390023AbfGRDLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:11:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389638AbfGRDK4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:10:56 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EE0F2173E;
        Thu, 18 Jul 2019 03:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419455;
        bh=S50crHlM90Om8iqHd3k+bo0yXA4w29zcfbIz8fh6KPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oWQ7l2JTpoVIYnwlim2tcWqQMKAG0mFFUk3UdDhNSBrOOhcuGD7w9X3mLLUhI7/Eq
         WKuW340XPgts+xtX/MQhrhJsk3lpPslYMtLf9mDyC1aeRNOiPGnYpkh0CnXb7AYcGQ
         fi0Zn/b53Je2/KUKvvThNWADBMxQOoj9/VkCNPUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eiichi Tsukata <devel@etsukata.com>,
        Thomas Gleixner <tglx@linutronix.de>, peterz@infradead.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 72/80] cpu/hotplug: Fix out-of-bounds read when setting fail state
Date:   Thu, 18 Jul 2019 12:02:03 +0900
Message-Id: <20190718030104.825807363@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030058.615992480@linuxfoundation.org>
References: <20190718030058.615992480@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index f370a0f43005..d768e15bef83 100644
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



