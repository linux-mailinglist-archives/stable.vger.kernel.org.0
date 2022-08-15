Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5AC059499F
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345534AbiHOXE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346109AbiHOXCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:02:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA458604C;
        Mon, 15 Aug 2022 12:58:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85408B81136;
        Mon, 15 Aug 2022 19:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF00C433C1;
        Mon, 15 Aug 2022 19:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593493;
        bh=NXZMVp/XCIifham+N8UhWhA8PlWuq+NgCw/dNZwr9+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2zz3RGGajru4+pAVbv3KwxEWpvTq0FkItfRQXVCoc2Pd0kmPfRyY1yPusRgJU4oG
         3FUewygXNBAhw2dda9TXspoHsHqjzYnV3OIBsEmbKuLLidO8lrIlrcuSpttzwx2f5Z
         sYGt8kOCppzB2kn7FUJpWlCZTi9RDhqvLG6rH5Qc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Vitor Massaru Iha <vitor@massaru.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Daniel Latypov <dlatypov@google.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0247/1157] lib: overflow: Do not define 64-bit tests on 32-bit
Date:   Mon, 15 Aug 2022 19:53:23 +0200
Message-Id: <20220815180449.465255125@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 6a022dd29f2cefbac4895a34e2e1f14b2d12d819 ]

The 64-bit overflow tests will trigger 64-bit division on 32-bit hosts,
which is not currently used anywhere in the kernel, and tickles bugs
in at least Clang 13 and earlier:
https://github.com/ClangBuiltLinux/linux/issues/1636

In reality, there shouldn't be a reason to not build the 64-bit test
cases on 32-bit systems, so these #ifdefs can be removed once the minimum
Clang version reaches 13.

In the meantime, silence W=1 warnings given by the current code:

../lib/overflow_kunit.c:191:19: warning: 's64_tests' defined but not used [-Wunused-const-variable=]
  191 | DEFINE_TEST_ARRAY(s64) = {
      |                   ^~~
../lib/overflow_kunit.c:24:11: note: in definition of macro 'DEFINE_TEST_ARRAY'
   24 |         } t ## _tests[]
      |           ^
../lib/overflow_kunit.c:94:19: warning: 'u64_tests' defined but not used [-Wunused-const-variable=]
   94 | DEFINE_TEST_ARRAY(u64) = {
      |                   ^~~
../lib/overflow_kunit.c:24:11: note: in definition of macro 'DEFINE_TEST_ARRAY'
   24 |         } t ## _tests[]
      |           ^

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/202205110324.7GrtxG8u-lkp@intel.com
Fixes: 455a35a6cdb6 ("lib: add runtime test of check_*_overflow functions")
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Vitor Massaru Iha <vitor@massaru.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Tested-by: Daniel Latypov <dlatypov@google.com>
Link: https://lore.kernel.org/lkml/CAGS_qxokQAjQRip2vPi80toW7hmBnXf=KMTNT51B1wuDqSZuVQ@mail.gmail.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/overflow_kunit.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/lib/overflow_kunit.c b/lib/overflow_kunit.c
index 475f0c064bf6..7e3e43679b73 100644
--- a/lib/overflow_kunit.c
+++ b/lib/overflow_kunit.c
@@ -91,6 +91,7 @@ DEFINE_TEST_ARRAY(u32) = {
 	{-4U, 5U, 1U, -9U, -20U, true, false, true},
 };
 
+#if BITS_PER_LONG == 64
 DEFINE_TEST_ARRAY(u64) = {
 	{0, 0, 0, 0, 0, false, false, false},
 	{1, 1, 2, 0, 1, false, false, false},
@@ -114,6 +115,7 @@ DEFINE_TEST_ARRAY(u64) = {
 	 false, true, false},
 	{-15ULL, 10ULL, -5ULL, -25ULL, -150ULL, false, false, true},
 };
+#endif
 
 DEFINE_TEST_ARRAY(s8) = {
 	{0, 0, 0, 0, 0, false, false, false},
@@ -188,6 +190,8 @@ DEFINE_TEST_ARRAY(s32) = {
 	{S32_MIN, S32_MIN, 0, 0, 0, true, false, true},
 	{S32_MAX, S32_MAX, -2, 0, 1, true, false, true},
 };
+
+#if BITS_PER_LONG == 64
 DEFINE_TEST_ARRAY(s64) = {
 	{0, 0, 0, 0, 0, false, false, false},
 
@@ -216,6 +220,7 @@ DEFINE_TEST_ARRAY(s64) = {
 	{-128, -1, -129, -127, 128, false, false, false},
 	{0, -S64_MAX, -S64_MAX, S64_MAX, 0, false, false, false},
 };
+#endif
 
 #define check_one_op(t, fmt, op, sym, a, b, r, of) do {		\
 	t _r;							\
@@ -650,6 +655,7 @@ static struct kunit_case overflow_test_cases[] = {
 	KUNIT_CASE(s16_overflow_test),
 	KUNIT_CASE(u32_overflow_test),
 	KUNIT_CASE(s32_overflow_test),
+/* Clang 13 and earlier generate unwanted libcalls on 32-bit. */
 #if BITS_PER_LONG == 64
 	KUNIT_CASE(u64_overflow_test),
 	KUNIT_CASE(s64_overflow_test),
-- 
2.35.1



