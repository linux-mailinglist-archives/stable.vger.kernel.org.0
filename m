Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386E365B0F6
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236050AbjABL3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236047AbjABL3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:29:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFBF654C
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:28:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A07A760F59
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1791C433EF;
        Mon,  2 Jan 2023 11:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658904;
        bh=HYHTOz+gZ8jJ07uHB+VCWckL1wzW/MmeNEyEI8TydXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+1G/jYC/dArIDKtFn2pPTabXtUcy3ZWCff5Hz3FarpkVezfC0lh6z8vHyFaj7bt2
         Qp+b929m5NdKViZKKirtUYl/7V98ZNMDNkAPYZbFXJGt8KB7LvzYqrlO+sSIBVFfgf
         GfDUNtHhf3VCh97xtdw7SgrtTMGLhwz++dV4kEr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, wuqiang <wuqiang.matt@bytedance.com>,
        Solar Designer <solar@openwall.com>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 44/74] kprobes: kretprobe events missing on 2-core KVM guest
Date:   Mon,  2 Jan 2023 12:22:17 +0100
Message-Id: <20230102110553.979933957@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f318bceda1e6..97d086b23ce8 100644
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
index 771fcce54fac..fb88278978fe 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2209,13 +2209,9 @@ int register_kretprobe(struct kretprobe *rp)
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



