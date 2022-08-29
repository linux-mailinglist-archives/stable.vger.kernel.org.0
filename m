Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58A05A48F0
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbiH2LRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbiH2LRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:17:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3DF874373;
        Mon, 29 Aug 2022 04:11:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A9CCB80F4B;
        Mon, 29 Aug 2022 11:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D509C433C1;
        Mon, 29 Aug 2022 11:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771496;
        bh=wmAcSw4o7dTT+6FzfasWalqjz+sfvRvZVqz3TKQ5pbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ORwKJrR49pgjNOJ4rg7G0K61RLdBGSGRhS0UNP/eLa+AcXT0W+KzErxde8/ZtKF/1
         mRGtMTSeS7TeIkmKI9oI9hgixOJc5IN3li+4tAOxeOp4Jv0BF7XBCQ4LBQ6zU4yepr
         RZaM0eZUwi6Bbk146ujsJqsfHYGEdd4edXO9KfaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.10 73/86] s390: fix double free of GS and RI CBs on fork() failure
Date:   Mon, 29 Aug 2022 12:59:39 +0200
Message-Id: <20220829105759.513682339@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
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
@@ -77,6 +77,18 @@ int arch_dup_task_struct(struct task_str
 
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
 
@@ -134,13 +146,11 @@ int copy_thread(unsigned long clone_flag
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


