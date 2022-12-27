Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94DCD656ECE
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbiL0UeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiL0Udq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:33:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E74DEC6;
        Tue, 27 Dec 2022 12:33:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8A86B811F8;
        Tue, 27 Dec 2022 20:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1ADC433A0;
        Tue, 27 Dec 2022 20:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173211;
        bh=h8V0wNLRTzMR6CwLsnCeF+if27/1odhhAs39sK6Of6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=joqHUzPvR7+YfhqP3i0nPuEWfJ9bh9vnsITrwXXpl+lcxpBizo3hhtltxOE/jtt9c
         vk0h8BzhKKPLhAZL0J8HOUJ4T01kSKO4EuGg3Ap/zQba7tSntZbmVOCXE2AMRpZfvQ
         DhVlEG20dyO3ganCZN/gqZjvkJfxCCWMFTXCkama0drOQGqrws6hKORZ4PoVYL0q78
         S+V0XcsTICpr4qvJFrjIBtEJcbDt6/0JmWZWza4P4QqKaaKKTcBh1arwLWuB184AKS
         R/PYxTC3RtMhWjoeqwFW8geGkAoRc2qYtTCOwQqTxtk9Z+nTbPRK452A27RpPaz2Mh
         hQZUe/1eBuZfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     wuqiang <wuqiang.matt@bytedance.com>,
        Solar Designer <solar@openwall.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>, naveen.n.rao@linux.ibm.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        rostedt@goodmis.org, corbet@lwn.net, linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 25/28] kprobes: kretprobe events missing on 2-core KVM guest
Date:   Tue, 27 Dec 2022 15:32:46 -0500
Message-Id: <20221227203249.1213526-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203249.1213526-1-sashal@kernel.org>
References: <20221227203249.1213526-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wuqiang <wuqiang.matt@bytedance.com>

[ Upstream commit 3b7ddab8a19aefc768f345fd3782af35b4a68d9b ]

Default value of maxactive is set as num_possible_cpus() for nonpreemptable
systems. For a 2-core system, only 2 kretprobe instances would be allocated
in default, then these 2 instances for execve kretprobe are very likely to
be used up with a pipelined command.

Here's the testcase: a shell script was added to crontab, and the content
of the script is:

  #!/bin/sh
  do_something_magic `tr -dc a-z < /dev/urandom | head -c 10`

cron will trigger a series of program executions (4 times every hour). Then
events loss would be noticed normally after 3-4 hours of testings.

The issue is caused by a burst of series of execve requests. The best number
of kretprobe instances could be different case by case, and should be user's
duty to determine, but num_possible_cpus() as the default value is inadequate
especially for systems with small number of cpus.

This patch enables the logic for preemption as default, thus increases the
minimum of maxactive to 10 for nonpreemptable systems.

Link: https://lore.kernel.org/all/20221110081502.492289-1-wuqiang.matt@bytedance.com/

Signed-off-by: wuqiang <wuqiang.matt@bytedance.com>
Reviewed-by: Solar Designer <solar@openwall.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/trace/kprobes.rst | 3 +--
 kernel/kprobes.c                | 8 ++------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/Documentation/trace/kprobes.rst b/Documentation/trace/kprobes.rst
index 48cf778a2468..fc7ce76eab65 100644
--- a/Documentation/trace/kprobes.rst
+++ b/Documentation/trace/kprobes.rst
@@ -131,8 +131,7 @@ For example, if the function is non-recursive and is called with a
 spinlock held, maxactive = 1 should be enough.  If the function is
 non-recursive and can never relinquish the CPU (e.g., via a semaphore
 or preemption), NR_CPUS should be enough.  If maxactive <= 0, it is
-set to a default value.  If CONFIG_PREEMPT is enabled, the default
-is max(10, 2*NR_CPUS).  Otherwise, the default is NR_CPUS.
+set to a default value: max(10, 2*NR_CPUS).
 
 It's not a disaster if you set maxactive too low; you'll just miss
 some probes.  In the kretprobe struct, the nmissed field is set to
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3050631e528d..95a456d3149e 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2213,13 +2213,9 @@ int register_kretprobe(struct kretprobe *rp)
 	rp->kp.post_handler = NULL;
 
 	/* Pre-allocate memory for max kretprobe instances */
-	if (rp->maxactive <= 0) {
-#ifdef CONFIG_PREEMPTION
+	if (rp->maxactive <= 0)
 		rp->maxactive = max_t(unsigned int, 10, 2*num_possible_cpus());
-#else
-		rp->maxactive = num_possible_cpus();
-#endif
-	}
+
 #ifdef CONFIG_KRETPROBE_ON_RETHOOK
 	rp->rh = rethook_alloc((void *)rp, kretprobe_rethook_handler);
 	if (!rp->rh)
-- 
2.35.1

