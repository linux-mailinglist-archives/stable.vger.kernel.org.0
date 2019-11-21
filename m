Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 558D1104779
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 01:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfKUAX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 19:23:29 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:59224 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfKUAX3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 19:23:29 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iXaFn-0001DS-9e; Thu, 21 Nov 2019 01:23:23 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id C418A1C0070;
        Thu, 21 Nov 2019 01:23:22 +0100 (CET)
Date:   Thu, 21 Nov 2019 00:23:22 -0000
From:   "tip-bot2 for Dmitry Safonov" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] time: Zero the upper 32-bits in
 __kernel_timespec on 32-bit
Cc:     Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Dmitry Safonov <dima@arista.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20191121000303.126523-1-dima@arista.com>
References: <20191121000303.126523-1-dima@arista.com>
MIME-Version: 1.0
Message-ID: <157429580269.21853.3914350918293284243.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/urgent branch of tip:

Commit-ID:     7b8474466ed97be458c825f34a85f2c2b84c3f95
Gitweb:        https://git.kernel.org/tip/7b8474466ed97be458c825f34a85f2c2b84c3f95
Author:        Dmitry Safonov <dima@arista.com>
AuthorDate:    Thu, 21 Nov 2019 00:03:03 
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Thu, 21 Nov 2019 01:17:58 +01:00

time: Zero the upper 32-bits in __kernel_timespec on 32-bit

On compat interfaces, the high order bits of nanoseconds should be zeroed
out. This is because the application code or the libc do not guarantee
zeroing of these. If used without zeroing, kernel might be at risk of using
timespec values incorrectly.

Originally it was handled correctly, but lost during is_compat_syscall()
cleanup. Revert the condition back to check CONFIG_64BIT.

Fixes: 98f76206b335 ("compat: Cleanup in_compat_syscall() callers")
Reported-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191121000303.126523-1-dima@arista.com
---
 kernel/time/time.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/time/time.c b/kernel/time/time.c
index 5c54ca6..83f403e 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -881,7 +881,8 @@ int get_timespec64(struct timespec64 *ts,
 	ts->tv_sec = kts.tv_sec;
 
 	/* Zero out the padding for 32 bit systems or in compat mode */
-	if (IS_ENABLED(CONFIG_64BIT_TIME) && in_compat_syscall())
+	if (IS_ENABLED(CONFIG_64BIT_TIME) && (!IS_ENABLED(CONFIG_64BIT) ||
+					      in_compat_syscall()))
 		kts.tv_nsec &= 0xFFFFFFFFUL;
 
 	ts->tv_nsec = kts.tv_nsec;
