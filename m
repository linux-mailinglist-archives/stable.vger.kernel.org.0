Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA312B60F6
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbgKQNOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:14:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:45286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730049AbgKQNOZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:14:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5C2124199;
        Tue, 17 Nov 2020 13:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618864;
        bh=nDLzIC3PMwi5RFCptIFIID9du6F4ViMDbe2cyj0h2FY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fE5NMp3W6PY9GqpjaKrIDI7LkKLIlTsow4zzjyODSYmK0KdAUH8osaqGl+Bhg6vpB
         //M9wuJ9Vy7tPTu/kQKzKq9dm8Zc+A6MMmttZmCTDV+29VxVhmC9KZWRTo8fZAGAXd
         TfXyEqKVS1c1rQMA9s4TlaWqPG65cVQ6+mYOnbSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeng Tao <prime.zeng@hisilicon.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 04/85] time: Prevent undefined behaviour in timespec64_to_ns()
Date:   Tue, 17 Nov 2020 14:04:33 +0100
Message-Id: <20201117122111.239433205@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122111.018425544@linuxfoundation.org>
References: <20201117122111.018425544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zeng Tao <prime.zeng@hisilicon.com>

[ Upstream commit cb47755725da7b90fecbb2aa82ac3b24a7adb89b ]

UBSAN reports:

Undefined behaviour in ./include/linux/time64.h:127:27
signed integer overflow:
17179869187 * 1000000000 cannot be represented in type 'long long int'
Call Trace:
 timespec64_to_ns include/linux/time64.h:127 [inline]
 set_cpu_itimer+0x65c/0x880 kernel/time/itimer.c:180
 do_setitimer+0x8e/0x740 kernel/time/itimer.c:245
 __x64_sys_setitimer+0x14c/0x2c0 kernel/time/itimer.c:336
 do_syscall_64+0xa1/0x540 arch/x86/entry/common.c:295

Commit bd40a175769d ("y2038: itimer: change implementation to timespec64")
replaced the original conversion which handled time clamping correctly with
timespec64_to_ns() which has no overflow protection.

Fix it in timespec64_to_ns() as this is not necessarily limited to the
usage in itimers.

[ tglx: Added comment and adjusted the fixes tag ]

Fixes: 361a3bf00582 ("time64: Add time64.h header and define struct timespec64")
Signed-off-by: Zeng Tao <prime.zeng@hisilicon.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1598952616-6416-1-git-send-email-prime.zeng@hisilicon.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/time64.h | 4 ++++
 kernel/time/itimer.c   | 4 ----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/time64.h b/include/linux/time64.h
index ad33260618f76..99ab4a686c301 100644
--- a/include/linux/time64.h
+++ b/include/linux/time64.h
@@ -189,6 +189,10 @@ static inline bool timespec64_valid_strict(const struct timespec64 *ts)
  */
 static inline s64 timespec64_to_ns(const struct timespec64 *ts)
 {
+	/* Prevent multiplication overflow */
+	if ((unsigned long long)ts->tv_sec >= KTIME_SEC_MAX)
+		return KTIME_MAX;
+
 	return ((s64) ts->tv_sec * NSEC_PER_SEC) + ts->tv_nsec;
 }
 
diff --git a/kernel/time/itimer.c b/kernel/time/itimer.c
index f26acef5d7b48..7f718565507b5 100644
--- a/kernel/time/itimer.c
+++ b/kernel/time/itimer.c
@@ -153,10 +153,6 @@ static void set_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
 	u64 oval, nval, ointerval, ninterval;
 	struct cpu_itimer *it = &tsk->signal->it[clock_id];
 
-	/*
-	 * Use the to_ktime conversion because that clamps the maximum
-	 * value to KTIME_MAX and avoid multiplication overflows.
-	 */
 	nval = ktime_to_ns(timeval_to_ktime(value->it_value));
 	ninterval = ktime_to_ns(timeval_to_ktime(value->it_interval));
 
-- 
2.27.0



