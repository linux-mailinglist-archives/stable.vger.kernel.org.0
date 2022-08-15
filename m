Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369C959486E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354862AbiHOXzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355290AbiHOXvr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:51:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A6A91D07;
        Mon, 15 Aug 2022 13:16:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CE4FB810C5;
        Mon, 15 Aug 2022 20:16:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F184DC433D6;
        Mon, 15 Aug 2022 20:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594584;
        bh=4Ad6WHw+VEo7Yt24zjkg9al8JR/d0E217Ezuc9hpe3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aQTuVCQvRb6G4kaTJBXClG30dZUNULVxnIIzdftnV382+LLcpJaXfbK4/VbctqWGY
         K909iC+Igd++X5ERCBAfIY/QKa45pd5q6CL6g1Zxebh7SDRSAPYsqqJRP11aB8zdA1
         yKxW1GqnN/6yj2MLpfxLWFvbfcH4E5fwZpws/wSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <yujie.liu@intel.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel Latypov <dlatypov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        David Gow <davidgow@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0495/1157] kunit: executor: Fix a memory leak on failure in kunit_filter_tests
Date:   Mon, 15 Aug 2022 19:57:31 +0200
Message-Id: <20220815180459.456122374@linuxfoundation.org>
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

From: David Gow <davidgow@google.com>

[ Upstream commit 94681e289bf5d10c9db9db143d1a22d8717205c5 ]

It's possible that memory allocation for 'filtered' will fail, but for the
copy of the suite to succeed. In this case, the copy could be leaked.

Properly free 'copy' in the error case for the allocation of 'filtered'
failing.

Note that there may also have been a similar issue in
kunit_filter_subsuites, before it was removed in "kunit: flatten
kunit_suite*** to kunit_suite** in .kunit_test_suites".

This was reported by clang-analyzer via the kernel test robot, here:
https://lore.kernel.org/all/c8073b8e-7b9e-0830-4177-87c12f16349c@intel.com/

And by smatch via Dan Carpenter and the kernel test robot:
https://lore.kernel.org/all/202207101328.ASjx88yj-lkp@intel.com/

Fixes: a02353f49162 ("kunit: bail out of test filtering logic quicker if OOM")
Reported-by: kernel test robot <yujie.liu@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Daniel Latypov <dlatypov@google.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/executor.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/kunit/executor.c b/lib/kunit/executor.c
index 96f96e42ce06..16fb88c0aca3 100644
--- a/lib/kunit/executor.c
+++ b/lib/kunit/executor.c
@@ -76,8 +76,10 @@ kunit_filter_tests(struct kunit_suite *const suite, const char *test_glob)
 	memcpy(copy, suite, sizeof(*copy));
 
 	filtered = kcalloc(n + 1, sizeof(*filtered), GFP_KERNEL);
-	if (!filtered)
+	if (!filtered) {
+		kfree(copy);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	n = 0;
 	kunit_suite_for_each_test_case(suite, test_case) {
-- 
2.35.1



