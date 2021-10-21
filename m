Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27CFC4356D4
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhJUAWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:22:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230103AbhJUAWl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:22:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80B0C611CC;
        Thu, 21 Oct 2021 00:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775626;
        bh=OYEiy43p50mFVcpQF0Wr04GWdZWgFGozhCJvTMAK0Wk=;
        h=From:To:Cc:Subject:Date:From;
        b=ryxsZH8pi6g/YpE1eN//WwKaBk+9fPv8vLIuSBb/a8brsj5AlmNms3ma/TeyJuENd
         dLje27PMtPP6rACUHwU98UGQARecdYcC5fJo6qLUniB/rL03SzZV/Xr0Y6sJo/uK0S
         xo9S0eDNag+c3GCp7aXyqndKdfUI4eqKfU/JpFUUauZWlsCfjd2n2F66o8q0mNKSKp
         sTkTenNERNxt8Y04+jxSxUh5pdWJnaRpIy1wh24hyEFZIO5HZU4gfms9xlDHYO+qhc
         WOdNqf9IrQL5DbmQBVU+GltKRjS3oPAF6RNf2lrdvJVSG9OrNkF396A+DQZNyK1wB8
         4BNdLO6rNXKXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Daniel Latypov <dlatypov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
Subject: [PATCH AUTOSEL 5.14 01/26] kunit: fix reference count leak in kfree_at_end
Date:   Wed, 20 Oct 2021 20:19:58 -0400
Message-Id: <20211021002023.1128949-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit f62314b1ced25c58b86e044fc951cd6a1ea234cf ]

The reference counting issue happens in the normal path of
kfree_at_end(). When kunit_alloc_and_get_resource() is invoked, the
function forgets to handle the returned resource object, whose refcount
increased inside, causing a refcount leak.

Fix this issue by calling kunit_alloc_resource() instead of
kunit_alloc_and_get_resource().

Fixed the following when applying:
Shuah Khan <skhan@linuxfoundation.org>

CHECK: Alignment should match open parenthesis
+	kunit_alloc_resource(test, NULL, kfree_res_free, GFP_KERNEL,
 				     (void *)to_free);

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Reviewed-by: Daniel Latypov <dlatypov@google.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/executor_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/kunit/executor_test.c b/lib/kunit/executor_test.c
index cdbe54b16501..e14a18af573d 100644
--- a/lib/kunit/executor_test.c
+++ b/lib/kunit/executor_test.c
@@ -116,8 +116,8 @@ static void kfree_at_end(struct kunit *test, const void *to_free)
 	/* kfree() handles NULL already, but avoid allocating a no-op cleanup. */
 	if (IS_ERR_OR_NULL(to_free))
 		return;
-	kunit_alloc_and_get_resource(test, NULL, kfree_res_free, GFP_KERNEL,
-				     (void *)to_free);
+	kunit_alloc_resource(test, NULL, kfree_res_free, GFP_KERNEL,
+			     (void *)to_free);
 }
 
 static struct kunit_suite *alloc_fake_suite(struct kunit *test,
-- 
2.33.0

