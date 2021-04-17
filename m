Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F14836301C
	for <lists+stable@lfdr.de>; Sat, 17 Apr 2021 15:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236465AbhDQM6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Apr 2021 08:58:18 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35160 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbhDQM6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Apr 2021 08:58:18 -0400
Date:   Sat, 17 Apr 2021 12:57:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1618664270;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m1X6+iqVb6LhkUi6QZrdTfAvny6WJ8s4Ht4CSC/bzHQ=;
        b=32mA8G1dRNTE6o7+44+8iajT6lCR0KHgzWQmKufcAurG9OGlpuSVH5HsPSOSwfcEhZ70ZI
        4Se5u8z72rzjDHlGiQBxrcqsRNv5Zzh9bjwaNEKz0i9OEpPAbENRaXb/Cd95fvSALCWsOI
        YlK0uU4NJJh0ZWo7nzmXLqMmaAF8plw/MwG6YDVclZhit20P4rZqQ5YlrBKxSvqpiEZ78G
        NmJm/l9S61eg91Wg37DfYB+u7FAL7do9MQaiJyiy0clLiYuR4aZswLQ9r5G0F09hR4lDfW
        HzpAa7K42ggWWwbcPEqOneG+sM+SKbtomL3JEjtNfmRfkzWNaQyOvqMtWdAZuw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1618664270;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m1X6+iqVb6LhkUi6QZrdTfAvny6WJ8s4Ht4CSC/bzHQ=;
        b=UtVtTp30I4WXcXtiAQxcZx6hwcTLBrNhOhxOB1pa64LeJ+ci2J6n3y6qBzcatGvDN815Xv
        WTDfzjbp1DTKryAw==
From:   "tip-bot2 for Chen Jun" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/core] posix-timers: Preserve return value in clock_adjtime32()
Cc:     Chen Jun <chenjun102@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210414030449.90692-1-chenjun102@huawei.com>
References: <20210414030449.90692-1-chenjun102@huawei.com>
MIME-Version: 1.0
Message-ID: <161866426986.29796.2792867256051825310.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/core branch of tip:

Commit-ID:     2d036dfa5f10df9782f5278fc591d79d283c1fad
Gitweb:        https://git.kernel.org/tip/2d036dfa5f10df9782f5278fc591d79d283c1fad
Author:        Chen Jun <chenjun102@huawei.com>
AuthorDate:    Wed, 14 Apr 2021 03:04:49 
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Sat, 17 Apr 2021 14:55:06 +02:00

posix-timers: Preserve return value in clock_adjtime32()

The return value on success (>= 0) is overwritten by the return value of
put_old_timex32(). That works correct in the fault case, but is wrong for
the success case where put_old_timex32() returns 0.

Just check the return value of put_old_timex32() and return -EFAULT in case
it is not zero.

[ tglx: Massage changelog ]

Fixes: 3a4d44b61625 ("ntp: Move adjtimex related compat syscalls to native counterparts")
Signed-off-by: Chen Jun <chenjun102@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Richard Cochran <richardcochran@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210414030449.90692-1-chenjun102@huawei.com
---
 kernel/time/posix-timers.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index bf540f5..dd5697d 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -1191,8 +1191,8 @@ SYSCALL_DEFINE2(clock_adjtime32, clockid_t, which_clock,
 
 	err = do_clock_adjtime(which_clock, &ktx);
 
-	if (err >= 0)
-		err = put_old_timex32(utp, &ktx);
+	if (err >= 0 && put_old_timex32(utp, &ktx))
+		return -EFAULT;
 
 	return err;
 }
