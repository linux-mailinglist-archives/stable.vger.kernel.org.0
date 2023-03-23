Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821616C5C26
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 02:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjCWBd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 21:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjCWBdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 21:33:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E9CA5C7;
        Wed, 22 Mar 2023 18:33:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0C9F6CE1E88;
        Thu, 23 Mar 2023 01:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE6EC433D2;
        Thu, 23 Mar 2023 01:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679535147;
        bh=Rstalf7X0YfHHGKYTXYRDjH7oAo1D5QcMTHjHwLB7PE=;
        h=Date:To:From:Subject:From;
        b=OO7E0sHN2LDklnykVHC1BI8EQZrPP0v77gF+xZFBlE7lDbMiq7L1gOrOeM48W+N/G
         RVFZOeEuMsPuoCLN4DuwAgf6IRGP+qfZ1iQQnV59IqV+/rJasZ3OAOvX8AO1/na3Nr
         PebDCFWYhzDbrLRGt5VyjoSs6BiRCahY5sjEpQUg=
Date:   Wed, 22 Mar 2023 18:32:26 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        nathan@kernel.org, glider@google.com, dvyukov@google.com,
        elver@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kcsan-avoid-passing-g-for-test.patch removed from -mm tree
Message-Id: <20230323013227.5BE6EC433D2@smtp.kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: kcsan: avoid passing -g for test
has been removed from the -mm tree.  Its filename was
     kcsan-avoid-passing-g-for-test.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kcsan: avoid passing -g for test
Date: Thu, 16 Mar 2023 23:47:05 +0100

Nathan reported that when building with GNU as and a version of clang that
defaults to DWARF5, the assembler will complain with:

  Error: non-constant .uleb128 is not supported

This is because `-g` defaults to the compiler debug info default. If the
assembler does not support some of the directives used, the above errors
occur. To fix, remove the explicit passing of `-g`.

All the test wants is that stack traces print valid function names, and
debug info is not required for that. (I currently cannot recall why I
added the explicit `-g`.)

Link: https://lkml.kernel.org/r/20230316224705.709984-2-elver@google.com
Fixes: 1fe84fd4a402 ("kcsan: Add test suite")
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/kernel/kcsan/Makefile~kcsan-avoid-passing-g-for-test
+++ a/kernel/kcsan/Makefile
@@ -16,6 +16,6 @@ obj-y := core.o debugfs.o report.o
 KCSAN_INSTRUMENT_BARRIERS_selftest.o := y
 obj-$(CONFIG_KCSAN_SELFTEST) += selftest.o
 
-CFLAGS_kcsan_test.o := $(CFLAGS_KCSAN) -g -fno-omit-frame-pointer
+CFLAGS_kcsan_test.o := $(CFLAGS_KCSAN) -fno-omit-frame-pointer
 CFLAGS_kcsan_test.o += $(DISABLE_STRUCTLEAK_PLUGIN)
 obj-$(CONFIG_KCSAN_KUNIT_TEST) += kcsan_test.o
_

Patches currently in -mm which might be from elver@google.com are


