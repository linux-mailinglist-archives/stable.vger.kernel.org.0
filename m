Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A240635764
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238028AbiKWJlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238061AbiKWJl2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:41:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190ACD5A0D
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:39:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD3B861A02
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973BEC433D6;
        Wed, 23 Nov 2022 09:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196340;
        bh=HQscL/X2mZZMiD2EO9LRp3Z7Z2YTMW1b4xrCZaLOm+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O1T/dln7CFLXqF41IeZq8feVq1TtoXNI8FPvb66pFG3EnTyIlyHhyQcgNPC/WfD7h
         Y/G5g901yiBiTDnLy68BavPMAwB/pBQ0CU7/PCLPpML5tZm5gkGuhw6TN4jXKs/WTk
         TeDP4kLvr08O5c9FdBm45g7ph6T2BmHJQizOMZ9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhao Gongyi <zhaogongyi@huawei.com>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Li Huafei <lihuafei1@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 166/181] kprobes: Skip clearing aggrprobes post_handler in kprobe-on-ftrace case
Date:   Wed, 23 Nov 2022 09:52:09 +0100
Message-Id: <20221123084609.517856993@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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

From: Li Huafei <lihuafei1@huawei.com>

[ Upstream commit 5dd7caf0bdc5d0bae7cf9776b4d739fb09bd5ebb ]

In __unregister_kprobe_top(), if the currently unregistered probe has
post_handler but other child probes of the aggrprobe do not have
post_handler, the post_handler of the aggrprobe is cleared. If this is
a ftrace-based probe, there is a problem. In later calls to
disarm_kprobe(), we will use kprobe_ftrace_ops because post_handler is
NULL. But we're armed with kprobe_ipmodify_ops. This triggers a WARN in
__disarm_kprobe_ftrace() and may even cause use-after-free:

  Failed to disarm kprobe-ftrace at kernel_clone+0x0/0x3c0 (error -2)
  WARNING: CPU: 5 PID: 137 at kernel/kprobes.c:1135 __disarm_kprobe_ftrace.isra.21+0xcf/0xe0
  Modules linked in: testKprobe_007(-)
  CPU: 5 PID: 137 Comm: rmmod Not tainted 6.1.0-rc4-dirty #18
  [...]
  Call Trace:
   <TASK>
   __disable_kprobe+0xcd/0xe0
   __unregister_kprobe_top+0x12/0x150
   ? mutex_lock+0xe/0x30
   unregister_kprobes.part.23+0x31/0xa0
   unregister_kprobe+0x32/0x40
   __x64_sys_delete_module+0x15e/0x260
   ? do_user_addr_fault+0x2cd/0x6b0
   do_syscall_64+0x3a/0x90
   entry_SYSCALL_64_after_hwframe+0x63/0xcd
   [...]

For the kprobe-on-ftrace case, we keep the post_handler setting to
identify this aggrprobe armed with kprobe_ipmodify_ops. This way we
can disarm it correctly.

Link: https://lore.kernel.org/all/20221112070000.35299-1-lihuafei1@huawei.com/

Fixes: 0bc11ed5ab60 ("kprobes: Allow kprobes coexist with livepatch")
Reported-by: Zhao Gongyi <zhaogongyi@huawei.com>
Suggested-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kprobes.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 55fffb7e6f1c..23af2f8e8563 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1760,7 +1760,13 @@ static int __unregister_kprobe_top(struct kprobe *p)
 				if ((list_p != p) && (list_p->post_handler))
 					goto noclean;
 			}
-			ap->post_handler = NULL;
+			/*
+			 * For the kprobe-on-ftrace case, we keep the
+			 * post_handler setting to identify this aggrprobe
+			 * armed with kprobe_ipmodify_ops.
+			 */
+			if (!kprobe_ftrace(ap))
+				ap->post_handler = NULL;
 		}
 noclean:
 		/*
-- 
2.35.1



