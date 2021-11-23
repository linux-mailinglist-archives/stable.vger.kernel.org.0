Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C39745A0CD
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 12:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbhKWLFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 06:05:08 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:37462 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235673AbhKWLFH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 06:05:07 -0500
Date:   Tue, 23 Nov 2021 11:01:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637665318;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y+oX2OITdqipqOQE08AxFDVOuJoEEjjNBJJ3k5+eZcI=;
        b=YlbHiluUitdiJdlCu5LZ3Wa6eF7EUMeaMSUjyyOcbja8iVOF4H4UFOBQXLxpzcf/R0zfHa
        SGthxTiYZ3w18y48Bw8JTloisiBdJohUrQpEdU4T6TCTcZQMjexs5+52PUMoIO2ckvk3jL
        XHt2t6GZz+ONZTr/TytayCCina9ay76L9WoczdUhvWo/MLi7b74Y63S5jYd4RH3YpJUeHk
        9Q3pk9LZo49yz1nFizAfxJKCOKY7hdqHP8jylYGOdv2eQNjeE87QjYfmGYa1VtKy2cN/Od
        HnXOxex9qWSghzGulwKEm535nmNKDZtdn/Oh0aGBBNE6tWVMmPl5FcPCWVS8dg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637665318;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y+oX2OITdqipqOQE08AxFDVOuJoEEjjNBJJ3k5+eZcI=;
        b=COZu4klu0TDSZoxQN5YeiKQZtE0u5+uHvPvH96bXF37h8gaWC5FYeowYTamQLs0GgvoWsO
        Ru6epnNh05CucyBg==
From:   "tip-bot2 for Andrey Ryabinin" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: sched/core] cputime, cpuacct: Include guest time in user time
 in cpuacct.stat
Cc:     Andrey Ryabinin <arbn@yandex-team.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Tejun Heo <tj@kernel.org>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20211115164607.23784-1-arbn@yandex-team.com>
References: <20211115164607.23784-1-arbn@yandex-team.com>
MIME-Version: 1.0
Message-ID: <163766531756.11128.2497713509765772870.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the sched/core branch of tip:

Commit-ID:     9731698ecb9c851f353ce2496292ff9fcea39dff
Gitweb:        https://git.kernel.org/tip/9731698ecb9c851f353ce2496292ff9fcea39dff
Author:        Andrey Ryabinin <arbn@yandex-team.com>
AuthorDate:    Mon, 15 Nov 2021 19:46:04 +03:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Tue, 23 Nov 2021 09:55:22 +01:00

cputime, cpuacct: Include guest time in user time in cpuacct.stat

cpuacct.stat in no-root cgroups shows user time without guest time
included int it. This doesn't match with user time shown in root
cpuacct.stat and /proc/<pid>/stat. This also affects cgroup2's cpu.stat
in the same way.

Make account_guest_time() to add user time to cgroup's cpustat to
fix this.

Fixes: ef12fefabf94 ("cpuacct: add per-cgroup utime/stime statistics")
Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211115164607.23784-1-arbn@yandex-team.com
---
 kernel/sched/cputime.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 872e481..042a6db 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -148,10 +148,10 @@ void account_guest_time(struct task_struct *p, u64 cputime)
 
 	/* Add guest time to cpustat. */
 	if (task_nice(p) > 0) {
-		cpustat[CPUTIME_NICE] += cputime;
+		task_group_account_field(p, CPUTIME_NICE, cputime);
 		cpustat[CPUTIME_GUEST_NICE] += cputime;
 	} else {
-		cpustat[CPUTIME_USER] += cputime;
+		task_group_account_field(p, CPUTIME_USER, cputime);
 		cpustat[CPUTIME_GUEST] += cputime;
 	}
 }
