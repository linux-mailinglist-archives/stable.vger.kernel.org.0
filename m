Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D20D68D7AA
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbjBGNCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbjBGNBu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:01:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95823A5AD
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:01:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FAFB613EA
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A80C433EF;
        Tue,  7 Feb 2023 13:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774889;
        bh=MSHOITU8D68Nq2L78xGa7sAUQ2ihBBmLmLcHM0EUtCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p5HTQrhUNvK+GZH4hri34PFGhyODfF+N6kLP4OrcI8udaJjRp6CPlilp+dyUa7Fc3
         RhOWI//jhzp7jNLnzlmnf5F5Uft0B8i71mdP2hMdNoaNM6YREzOmKyHkQP6WqkMmPE
         09ac8UiWNpJ74G1cBC5BpV051IGA96rbnZq++nno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Brendan Higgins <brendan.higgins@linux.dev>,
        David Gow <davidgow@google.com>,
        Martin Fernandez <martin.fernandez@eclypsium.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/208] kunit: fix kunit_test_init_section_suites(...)
Date:   Tue,  7 Feb 2023 13:55:22 +0100
Message-Id: <20230207125637.395267558@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brendan Higgins <brendan.higgins@linux.dev>

[ Upstream commit 254c71374a70051a043676b67ba4f7ad392b5fe6 ]

Looks like kunit_test_init_section_suites(...) was messed up in a merge
conflict. This fixes it.

kunit_test_init_section_suites(...) was not updated to avoid the extra
level of indirection when .kunit_test_suites was flattened. Given no-one
was actively using it, this went unnoticed for a long period of time.

Fixes: e5857d396f35 ("kunit: flatten kunit_suite*** to kunit_suite** in .kunit_test_suites")
Signed-off-by: Brendan Higgins <brendan.higgins@linux.dev>
Signed-off-by: David Gow <davidgow@google.com>
Tested-by: Martin Fernandez <martin.fernandez@eclypsium.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/kunit/test.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/kunit/test.h b/include/kunit/test.h
index b1ab6b32216d..ebcdbddf8344 100644
--- a/include/kunit/test.h
+++ b/include/kunit/test.h
@@ -299,7 +299,6 @@ static inline int kunit_run_all_tests(void)
  */
 #define kunit_test_init_section_suites(__suites...)			\
 	__kunit_test_suites(CONCATENATE(__UNIQUE_ID(array), _probe),	\
-			    CONCATENATE(__UNIQUE_ID(suites), _probe),	\
 			    ##__suites)
 
 #define kunit_test_init_section_suite(suite)	\
-- 
2.39.0



