Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62EDC6CBEF0
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 14:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjC1MWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 08:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjC1MWC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 08:22:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FEEA1AC
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 05:22:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFBD86172D
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 12:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43CCC433EF;
        Tue, 28 Mar 2023 12:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680006121;
        bh=vLkGYZ2OTGUdCfEsWeklFZNg3qUyHS9m8b5YiguZHKc=;
        h=Subject:To:Cc:From:Date:From;
        b=VWADm72pG/GLNS60VPiDESi4W8k2KAQ1c08+PBLg78fp73QRjmPq/xyf/zhQazjDD
         0DBfYV7k8ob8YqbEKdfSWdO0K/shc01IY1dPgG5h2t2ArAA0CCyL8pgQMlLb3BP3iE
         iVPSrmWFsY3lUNnnYXtRf5w7C4jLGcQjvUBNwDfA=
Subject: FAILED: patch "[PATCH] kcsan: avoid passing -g for test" failed to apply to 5.15-stable tree
To:     elver@google.com, akpm@linux-foundation.org, dvyukov@google.com,
        glider@google.com, nathan@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 14:21:50 +0200
Message-ID: <1680006110146160@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 5eb39cde1e2487ba5ec1802dc5e58a77e700d99e
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1680006110146160@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

5eb39cde1e24 ("kcsan: avoid passing -g for test")
6fcd4267a840 ("kernel: kcsan: kcsan_test: build without structleak plugin")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5eb39cde1e2487ba5ec1802dc5e58a77e700d99e Mon Sep 17 00:00:00 2001
From: Marco Elver <elver@google.com>
Date: Thu, 16 Mar 2023 23:47:05 +0100
Subject: [PATCH] kcsan: avoid passing -g for test

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

diff --git a/kernel/kcsan/Makefile b/kernel/kcsan/Makefile
index 8cf70f068d92..a45f3dfc8d14 100644
--- a/kernel/kcsan/Makefile
+++ b/kernel/kcsan/Makefile
@@ -16,6 +16,6 @@ obj-y := core.o debugfs.o report.o
 KCSAN_INSTRUMENT_BARRIERS_selftest.o := y
 obj-$(CONFIG_KCSAN_SELFTEST) += selftest.o
 
-CFLAGS_kcsan_test.o := $(CFLAGS_KCSAN) -g -fno-omit-frame-pointer
+CFLAGS_kcsan_test.o := $(CFLAGS_KCSAN) -fno-omit-frame-pointer
 CFLAGS_kcsan_test.o += $(DISABLE_STRUCTLEAK_PLUGIN)
 obj-$(CONFIG_KCSAN_KUNIT_TEST) += kcsan_test.o

