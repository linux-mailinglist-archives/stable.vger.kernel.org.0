Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 667C35AAF83
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236508AbiIBMjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237356AbiIBMjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:39:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1723BA1A74;
        Fri,  2 Sep 2022 05:30:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFAEDB82AA3;
        Fri,  2 Sep 2022 12:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2774AC433C1;
        Fri,  2 Sep 2022 12:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121720;
        bh=GuzXSFrL/EBvMxMZXb2JOrr+YkM+uKtUf0mRfOOrHEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AYt9DSztylV8zpd6cZcWTc9OA83VCViHYcmxlI9GcgT2We4eqsrW9SJwsDAHGevQ5
         LfYlrLzUEiantoueES1HYgOiqXvyoMcqy0K6qgWmt7P2gRKnw07ySlGxfnkVYz75x9
         NZzqKvnDPLTYKgUkmQ2Qo9g0VI/V1CiavvwA4dZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.4 43/77] s390: fix double free of GS and RI CBs on fork() failure
Date:   Fri,  2 Sep 2022 14:18:52 +0200
Message-Id: <20220902121405.088058691@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 13cccafe0edcd03bf1c841de8ab8a1c8e34f77d9 upstream.

The pointers for guarded storage and runtime instrumentation control
blocks are stored in the thread_struct of the associated task. These
pointers are initially copied on fork() via arch_dup_task_struct()
and then cleared via copy_thread() before fork() returns. If fork()
happens to fail after the initial task dup and before copy_thread(),
the newly allocated task and associated thread_struct memory are
freed via free_task() -> arch_release_task_struct(). This results in
a double free of the guarded storage and runtime info structs
because the fields in the failed task still refer to memory
associated with the source task.

This problem can manifest as a BUG_ON() in set_freepointer() (with
CONFIG_SLAB_FREELIST_HARDENED enabled) or KASAN splat (if enabled)
when running trinity syscall fuzz tests on s390x. To avoid this
problem, clear the associated pointer fields in
arch_dup_task_struct() immediately after the new task is copied.
Note that the RI flag is still cleared in copy_thread() because it
resides in thread stack memory and that is where stack info is
copied.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Fixes: 8d9047f8b967c ("s390/runtime instrumentation: simplify task exit handling")
Fixes: 7b83c6297d2fc ("s390/guarded storage: simplify task exit handling")
Cc: <stable@vger.kernel.org> # 4.15
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://lore.kernel.org/r/20220816155407.537372-1-bfoster@redhat.com
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/process.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -76,6 +76,18 @@ int arch_dup_task_struct(struct task_str
 
 	memcpy(dst, src, arch_task_struct_size);
 	dst->thread.fpu.regs = dst->thread.fpu.fprs;
+
+	/*
+	 * Don't transfer over the runtime instrumentation or the guarded
+	 * storage control block pointers. These fields are cleared here instead
+	 * of in copy_thread() to avoid premature freeing of associated memory
+	 * on fork() failure. Wait to clear the RI flag because ->stack still
+	 * refers to the source thread.
+	 */
+	dst->thread.ri_cb = NULL;
+	dst->thread.gs_cb = NULL;
+	dst->thread.gs_bc_cb = NULL;
+
 	return 0;
 }
 
@@ -133,13 +145,11 @@ int copy_thread_tls(unsigned long clone_
 	frame->childregs.flags = 0;
 	if (new_stackp)
 		frame->childregs.gprs[15] = new_stackp;
-
-	/* Don't copy runtime instrumentation info */
-	p->thread.ri_cb = NULL;
+	/*
+	 * Clear the runtime instrumentation flag after the above childregs
+	 * copy. The CB pointer was already cleared in arch_dup_task_struct().
+	 */
 	frame->childregs.psw.mask &= ~PSW_MASK_RI;
-	/* Don't copy guarded storage control block */
-	p->thread.gs_cb = NULL;
-	p->thread.gs_bc_cb = NULL;
 
 	/* Set a new TLS ?  */
 	if (clone_flags & CLONE_SETTLS) {


