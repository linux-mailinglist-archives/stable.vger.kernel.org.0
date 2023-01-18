Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAA0C670EA7
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 01:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjARAe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 19:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjARAeF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 19:34:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922AF31E22;
        Tue, 17 Jan 2023 16:02:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D1916159B;
        Wed, 18 Jan 2023 00:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81885C433EF;
        Wed, 18 Jan 2023 00:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674000127;
        bh=mVPOlxhtPkO5dnddUSN/M2K2EGM92dUucbmgljYlgm4=;
        h=Date:To:From:Subject:From;
        b=cpPHr+0Bo3GXg6C0d4oaNjfTbfd7oIV9VGlQqOxdjOYlNaHDkw7YZyEazp8Do1JXm
         r8sRSli/JeDnqvjcJq/Tlcj1lncZYaHt6n8EIiT+kBLz5WbMFs2irH5HjKdQZsNFSt
         NkrLLVKCwiZnAWeunryYaXtmcW8L2JgnJtPsco8s=
Date:   Tue, 17 Jan 2023 16:02:06 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        slyich@gmail.com, matoro_mailinglist_kernel@matoro.tk,
        glaubitz@physik.fu-berlin.de, emeric.maschino@gmail.com,
        james.morse@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ia64-fix-build-error-due-to-switch-case-label-appearing-next-to-declaration.patch added to mm-hotfixes-unstable branch
Message-Id: <20230118000207.81885C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PP_MIME_FAKE_ASCII_TEXT,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ia64: fix build error due to switch case label appearing next to declaration
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ia64-fix-build-error-due-to-switch-case-label-appearing-next-to-declaration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ia64-fix-build-error-due-to-switch-case-label-appearing-next-to-declaration.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: James Morse <james.morse@arm.com>
Subject: ia64: fix build error due to switch case label appearing next to declaration
Date: Tue, 17 Jan 2023 15:16:32 +0000

Since commit aa06a9bd8533 ("ia64: fix clock_getres(CLOCK_MONOTONIC) to
report ITC frequency"), gcc 10.1.0 fails to build ia64 with the gnomic:
| ../arch/ia64/kernel/sys_ia64.c: In function 'ia64_clock_getres':
| ../arch/ia64/kernel/sys_ia64.c:189:3: error: a label can only be part of a statement and a declaration is not a statement
|   189 |   s64 tick_ns = DIV_ROUND_UP(NSEC_PER_SEC, local_cpu_data->itc_freq);

This line appears immediately after a case label in a switch.

Move the declarations out of the case, to the top of the function.

Link: https://lkml.kernel.org/r/20230117151632.393836-1-james.morse@arm.com
Fixes: aa06a9bd8533 ("ia64: fix clock_getres(CLOCK_MONOTONIC) to report ITC frequency")
Signed-off-by: James Morse <james.morse@arm.com>
Cc: Émeric Maschino <emeric.maschino@gmail.com>
Cc: matoro <matoro_mailinglist_kernel@matoro.tk>
Cc: Sergei Trofimovich <slyich@gmail.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/ia64/kernel/sys_ia64.c~ia64-fix-build-error-due-to-switch-case-label-appearing-next-to-declaration
+++ a/arch/ia64/kernel/sys_ia64.c
@@ -170,6 +170,9 @@ ia64_mremap (unsigned long addr, unsigne
 asmlinkage long
 ia64_clock_getres(const clockid_t which_clock, struct __kernel_timespec __user *tp)
 {
+	struct timespec64 rtn_tp;
+	s64 tick_ns;
+
 	/*
 	 * ia64's clock_gettime() syscall is implemented as a vdso call
 	 * fsys_clock_gettime(). Currently it handles only
@@ -185,8 +188,8 @@ ia64_clock_getres(const clockid_t which_
 	switch (which_clock) {
 	case CLOCK_REALTIME:
 	case CLOCK_MONOTONIC:
-		s64 tick_ns = DIV_ROUND_UP(NSEC_PER_SEC, local_cpu_data->itc_freq);
-		struct timespec64 rtn_tp = ns_to_timespec64(tick_ns);
+		tick_ns = DIV_ROUND_UP(NSEC_PER_SEC, local_cpu_data->itc_freq);
+		rtn_tp = ns_to_timespec64(tick_ns);
 		return put_timespec64(&rtn_tp, tp);
 	}
 
_

Patches currently in -mm which might be from james.morse@arm.com are

ia64-fix-build-error-due-to-switch-case-label-appearing-next-to-declaration.patch

