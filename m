Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9956CC387
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbjC1Oyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbjC1Oyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:54:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94289E9
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:54:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF6E8B81D76
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22772C433EF;
        Tue, 28 Mar 2023 14:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015282;
        bh=yKt3/aQWkdaBiordIdPNQ9ot6DI5eRTmxt+Mt8gdIYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oZ3C2teYY+iD7I54oBzTWS1Al5LAwrnMfbfi4Mcrb5LaV7wKbeqaIpkR9Wsse/PBN
         koiWbqWAhHavsKW6/ZwFLR2U58WojLkDjENxS2c/WciDtP2Vh6s5l2J98DSUFY3ZvU
         Nlyr2WJF/WOJZUrPDeuqC65VXpiPwh5T5wfKmqLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marco Elver <elver@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2 202/240] kfence: avoid passing -g for test
Date:   Tue, 28 Mar 2023 16:42:45 +0200
Message-Id: <20230328142628.094495448@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

commit 2e08ca1802441224f5b7cc6bffbb687f7406de95 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kfence/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kfence/Makefile
+++ b/mm/kfence/Makefile
@@ -2,5 +2,5 @@
 
 obj-y := core.o report.o
 
-CFLAGS_kfence_test.o := -g -fno-omit-frame-pointer -fno-optimize-sibling-calls
+CFLAGS_kfence_test.o := -fno-omit-frame-pointer -fno-optimize-sibling-calls
 obj-$(CONFIG_KFENCE_KUNIT_TEST) += kfence_test.o


