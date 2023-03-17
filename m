Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12EAF6BE026
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 05:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjCQE00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 00:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCQE0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 00:26:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201443FB8A;
        Thu, 16 Mar 2023 21:26:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B173C621A2;
        Fri, 17 Mar 2023 04:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5E2C433EF;
        Fri, 17 Mar 2023 04:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679027183;
        bh=DAU2ni4Si/k9i+4c3dCEnBXvXSBGlkSNGVsU30PtP44=;
        h=Date:To:From:Subject:From;
        b=EjsBd8ZT7e89c6/PH6ZQ8oTDv7YxMKrymArgu38w6oXlg14OdO8uBpaFoy1/GS0KN
         I9BZKJeI2Fg7TNqdYVk+FlYpTvQ8EPKcvY/1wt1QDrerNk5pRggImkQ/W2qFA109IF
         ZTjGkvH2/hGT8TBe6IoDnYUZKcuaxL6r5ZI7dshM=
Date:   Thu, 16 Mar 2023 21:26:22 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        nathan@kernel.org, glider@google.com, dvyukov@google.com,
        elver@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kfence-avoid-passing-g-for-test.patch added to mm-hotfixes-unstable branch
Message-Id: <20230317042623.0C5E2C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kfence: avoid passing -g for test
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kfence-avoid-passing-g-for-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kfence-avoid-passing-g-for-test.patch

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
From: Marco Elver <elver@google.com>
Subject: kfence: avoid passing -g for test
Date: Thu, 16 Mar 2023 23:47:04 +0100

Nathan reported that when building with GNU as and a version of clang that
defaults to DWARF5:

  $ make -skj"$(nproc)" ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- \
			LLVM=1 LLVM_IAS=0 O=build \
			mrproper allmodconfig mm/kfence/kfence_test.o
  /tmp/kfence_test-08a0a0.s: Assembler messages:
  /tmp/kfence_test-08a0a0.s:14627: Error: non-constant .uleb128 is not supported
  /tmp/kfence_test-08a0a0.s:14628: Error: non-constant .uleb128 is not supported
  /tmp/kfence_test-08a0a0.s:14632: Error: non-constant .uleb128 is not supported
  /tmp/kfence_test-08a0a0.s:14633: Error: non-constant .uleb128 is not supported
  /tmp/kfence_test-08a0a0.s:14639: Error: non-constant .uleb128 is not supported
  ...

This is because `-g` defaults to the compiler debug info default.  If the
assembler does not support some of the directives used, the above errors
occur.  To fix, remove the explicit passing of `-g`.

All the test wants is that stack traces print valid function names, and
debug info is not required for that.  (I currently cannot recall why I
added the explicit `-g`.)

Link: https://lkml.kernel.org/r/20230316224705.709984-1-elver@google.com
Fixes: bc8fbc5f305a ("kfence: add test suite")
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/kfence/Makefile~kfence-avoid-passing-g-for-test
+++ a/mm/kfence/Makefile
@@ -2,5 +2,5 @@
 
 obj-y := core.o report.o
 
-CFLAGS_kfence_test.o := -g -fno-omit-frame-pointer -fno-optimize-sibling-calls
+CFLAGS_kfence_test.o := -fno-omit-frame-pointer -fno-optimize-sibling-calls
 obj-$(CONFIG_KFENCE_KUNIT_TEST) += kfence_test.o
_

Patches currently in -mm which might be from elver@google.com are

kasan-powerpc-dont-rename-memintrinsics-if-compiler-adds-prefixes.patch
kfence-avoid-passing-g-for-test.patch
kcsan-avoid-passing-g-for-test.patch
kfence-kcsan-avoid-passing-g-for-tests.patch

