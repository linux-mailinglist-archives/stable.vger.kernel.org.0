Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28AA61DE10
	for <lists+stable@lfdr.de>; Sat,  5 Nov 2022 21:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiKEUvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Nov 2022 16:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiKEUvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Nov 2022 16:51:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B32EE2A;
        Sat,  5 Nov 2022 13:51:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44E90B808CA;
        Sat,  5 Nov 2022 20:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9263C43142;
        Sat,  5 Nov 2022 20:51:08 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1orQ8f-007k8F-2r;
        Sat, 05 Nov 2022 16:51:37 -0400
Message-ID: <20221105205137.723843386@goodmis.org>
User-Agent: quilt/0.66
Date:   Sat, 05 Nov 2022 16:50:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Li Qiang <liq3ea@163.com>
Subject: [for-linus][PATCH 3/6] kprobe: reverse kp->flags when arm_kprobe failed
References: <20221105205049.462806482@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Qiang <liq3ea@163.com>

In aggregate kprobe case, when arm_kprobe failed,
we need set the kp->flags with KPROBE_FLAG_DISABLED again.
If not, the 'kp' kprobe will been considered as enabled
but it actually not enabled.

Link: https://lore.kernel.org/all/20220902155820.34755-1-liq3ea@163.com/

Fixes: 12310e343755 ("kprobes: Propagate error from arm_kprobe_ftrace()")
Cc: stable@vger.kernel.org
Signed-off-by: Li Qiang <liq3ea@163.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
---
 kernel/kprobes.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3220b0a2fb4a..cd9f5a66a690 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2429,8 +2429,11 @@ int enable_kprobe(struct kprobe *kp)
 	if (!kprobes_all_disarmed && kprobe_disabled(p)) {
 		p->flags &= ~KPROBE_FLAG_DISABLED;
 		ret = arm_kprobe(p);
-		if (ret)
+		if (ret) {
 			p->flags |= KPROBE_FLAG_DISABLED;
+			if (p != kp)
+				kp->flags |= KPROBE_FLAG_DISABLED;
+		}
 	}
 out:
 	mutex_unlock(&kprobe_mutex);
-- 
2.35.1
