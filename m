Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D74643A313
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236715AbhJYT4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:56:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239000AbhJYTx6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:53:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D016660EFE;
        Mon, 25 Oct 2021 19:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191103;
        bh=OYEiy43p50mFVcpQF0Wr04GWdZWgFGozhCJvTMAK0Wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zAkcECkOx0hiKudi6UMsjPzd8vSBrwHAINGf8cS+T7FIJLaqt23keI3546RfOiPhD
         hdD0V78ocIgqkytT0xeIZWMBlYMi7Ri60mLZsXu/O5VTOrNJRB5DiyOJjwIEBpKi6g
         NlajE3Zb66lBreZGDNIOzV+hX8ql1oijl+K6pvkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Daniel Latypov <dlatypov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 125/169] kunit: fix reference count leak in kfree_at_end
Date:   Mon, 25 Oct 2021 21:15:06 +0200
Message-Id: <20211025191033.622601318@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



