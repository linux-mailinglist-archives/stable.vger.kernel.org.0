Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F95F65D5A8
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234813AbjADOaj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234818AbjADOaM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:30:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CFB1742B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C572BB81673
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B76C433F2;
        Wed,  4 Jan 2023 14:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672842608;
        bh=zS7NlKqR0YON6Sq6KDE3v2BPfIL4bjsEJ8BjOfg7lZ8=;
        h=Subject:To:Cc:From:Date:From;
        b=g8t7cdrRzjKrciw/X/naBEIehEffGxBVaufyDdaIERaPG8We0CvMR97FCuF2E+iJP
         68eDWNOIuwaU4QQupILYp0A/S1vjRk+IXxyJXTURv4ljz1S9ZarGuKaGTgnSYUi+Jk
         CV/6fPvUs+zRjOAIvOZP+/26JN61FlyiXExPiqUk=
Subject: FAILED: patch "[PATCH] riscv: stacktrace: Fixup ftrace_graph_ret_addr retp argument" failed to apply to 5.4-stable tree
To:     guoren@kernel.org, guoren@linux.alibaba.com, palmer@rivosinc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:29:57 +0100
Message-ID: <1672842597249122@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

5c3022e4a616 ("riscv: stacktrace: Fixup ftrace_graph_ret_addr retp argument")
f766f77a74f5 ("riscv/stacktrace: Fix stack output without ra on the stack top")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5c3022e4a616d800cf5f4c3a981d7992179e44a1 Mon Sep 17 00:00:00 2001
From: Guo Ren <guoren@kernel.org>
Date: Wed, 9 Nov 2022 01:49:36 -0500
Subject: [PATCH] riscv: stacktrace: Fixup ftrace_graph_ret_addr retp argument

The 'retp' is a pointer to the return address on the stack, so we
must pass the current return address pointer as the 'retp'
argument to ftrace_push_return_trace(). Not parent function's
return address on the stack.

Fixes: b785ec129bd9 ("riscv/ftrace: Add HAVE_FUNCTION_GRAPH_RET_ADDR_PTR support")
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/r/20221109064937.3643993-2-guoren@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 08d11a53f39e..bcfe9eb55f80 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -58,7 +58,7 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 		} else {
 			fp = frame->fp;
 			pc = ftrace_graph_ret_addr(current, NULL, frame->ra,
-						   (unsigned long *)(fp - 8));
+						   &frame->ra);
 		}
 
 	}

