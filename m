Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A9A4172D5
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344526AbhIXMvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:51:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344534AbhIXMuX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:50:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 797576134F;
        Fri, 24 Sep 2021 12:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487701;
        bh=1Yee01YOa6CqWiZK9ouQScFRToVKWvCJRIJUdRJVjAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ULQcADGAnOowoKtiKmLfE1PJiTUFDoR/hAsGnNsYLbIFwyNhhRdUZk4DdWlWHELxz
         tgk7zLnq6LEHhqU9GHMHo8yTaOoaKO6lf4onmRSyggb170OU0BmJsNNPShiqxhplYr
         3wGFlp3Pxe4maDwWoRSigmj+xgw6NMS05074rOfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        syzbot+e68c89a9510c159d9684@syzkaller.appspotmail.com
Subject: [PATCH 4.19 14/34] profiling: fix shift-out-of-bounds bugs
Date:   Fri, 24 Sep 2021 14:44:08 +0200
Message-Id: <20210924124330.431710043@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124329.965218583@linuxfoundation.org>
References: <20210924124329.965218583@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit 2d186afd04d669fe9c48b994c41a7405a3c9f16d upstream.

Syzbot reported shift-out-of-bounds bug in profile_init().
The problem was in incorrect prof_shift. Since prof_shift value comes from
userspace we need to clamp this value into [0, BITS_PER_LONG -1]
boundaries.

Second possible shiht-out-of-bounds was found by Tetsuo:
sample_step local variable in read_profile() had "unsigned int" type,
but prof_shift allows to make a BITS_PER_LONG shift. So, to prevent
possible shiht-out-of-bounds sample_step type was changed to
"unsigned long".

Also, "unsigned short int" will be sufficient for storing
[0, BITS_PER_LONG] value, that's why there is no need for
"unsigned long" prof_shift.

Link: https://lkml.kernel.org/r/20210813140022.5011-1-paskripkin@gmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-and-tested-by: syzbot+e68c89a9510c159d9684@syzkaller.appspotmail.com
Suggested-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/profile.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -40,7 +40,8 @@ struct profile_hit {
 #define NR_PROFILE_GRP		(NR_PROFILE_HIT/PROFILE_GRPSZ)
 
 static atomic_t *prof_buffer;
-static unsigned long prof_len, prof_shift;
+static unsigned long prof_len;
+static unsigned short int prof_shift;
 
 int prof_on __read_mostly;
 EXPORT_SYMBOL_GPL(prof_on);
@@ -66,8 +67,8 @@ int profile_setup(char *str)
 		if (str[strlen(sleepstr)] == ',')
 			str += strlen(sleepstr) + 1;
 		if (get_option(&str, &par))
-			prof_shift = par;
-		pr_info("kernel sleep profiling enabled (shift: %ld)\n",
+			prof_shift = clamp(par, 0, BITS_PER_LONG - 1);
+		pr_info("kernel sleep profiling enabled (shift: %u)\n",
 			prof_shift);
 #else
 		pr_warn("kernel sleep profiling requires CONFIG_SCHEDSTATS\n");
@@ -77,21 +78,21 @@ int profile_setup(char *str)
 		if (str[strlen(schedstr)] == ',')
 			str += strlen(schedstr) + 1;
 		if (get_option(&str, &par))
-			prof_shift = par;
-		pr_info("kernel schedule profiling enabled (shift: %ld)\n",
+			prof_shift = clamp(par, 0, BITS_PER_LONG - 1);
+		pr_info("kernel schedule profiling enabled (shift: %u)\n",
 			prof_shift);
 	} else if (!strncmp(str, kvmstr, strlen(kvmstr))) {
 		prof_on = KVM_PROFILING;
 		if (str[strlen(kvmstr)] == ',')
 			str += strlen(kvmstr) + 1;
 		if (get_option(&str, &par))
-			prof_shift = par;
-		pr_info("kernel KVM profiling enabled (shift: %ld)\n",
+			prof_shift = clamp(par, 0, BITS_PER_LONG - 1);
+		pr_info("kernel KVM profiling enabled (shift: %u)\n",
 			prof_shift);
 	} else if (get_option(&str, &par)) {
-		prof_shift = par;
+		prof_shift = clamp(par, 0, BITS_PER_LONG - 1);
 		prof_on = CPU_PROFILING;
-		pr_info("kernel profiling enabled (shift: %ld)\n",
+		pr_info("kernel profiling enabled (shift: %u)\n",
 			prof_shift);
 	}
 	return 1;
@@ -467,7 +468,7 @@ read_profile(struct file *file, char __u
 	unsigned long p = *ppos;
 	ssize_t read;
 	char *pnt;
-	unsigned int sample_step = 1 << prof_shift;
+	unsigned long sample_step = 1UL << prof_shift;
 
 	profile_flip_buffers();
 	if (p >= (prof_len+1)*sizeof(unsigned int))


