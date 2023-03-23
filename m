Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878426C5C27
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 02:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbjCWBeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 21:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjCWBdk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 21:33:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1DCF96A;
        Wed, 22 Mar 2023 18:33:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF9EB6237A;
        Thu, 23 Mar 2023 01:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526F3C4339B;
        Thu, 23 Mar 2023 01:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679535146;
        bh=Pd1C5xaY7UY7S22n5vfJNMV9rxIvltzK9P/7AyH0PYQ=;
        h=Date:To:From:Subject:From;
        b=m4eW9EuQijhbOFxWpRp0CYkqjEJQehSn+gkHqdr6pY/qjCBmn19tb2Hx+6y4Ckzoa
         vNF2v67D4I665g6djMPDlTpS+HRJW0e0/dw7cjVcjGnVBVf8pBkqNTzpj3plqklgRV
         1fB+4RxXoJbnfaTQzr6k5fxG9g8nBb+MIG+cTzSc=
Date:   Wed, 22 Mar 2023 18:32:25 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        nathan@kernel.org, glider@google.com, dvyukov@google.com,
        elver@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kfence-avoid-passing-g-for-test.patch removed from -mm tree
Message-Id: <20230323013226.526F3C4339B@smtp.kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: kfence: avoid passing -g for test
has been removed from the -mm tree.  Its filename was
     kfence-avoid-passing-g-for-test.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


