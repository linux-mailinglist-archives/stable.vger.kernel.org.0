Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785AD4F2798
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbiDEIHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234237AbiDEH6F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:58:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC651EAD8;
        Tue,  5 Apr 2022 00:52:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6932F61748;
        Tue,  5 Apr 2022 07:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F5DC340EE;
        Tue,  5 Apr 2022 07:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145118;
        bh=4/1Ta9DLRHChKUxyfQZvPcc9G9gUQByvnjw5/X1NOmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M/DkKaouovd/mDqlQlTQgSMSz0JNq8pPoOy4MUn3epuv3ms9yOIe+Fj0xZrTO6XnL
         gl2iwMbajhKkOs6cLlCSPPrDEw7px5QN7epv7A6IALnlJ/pWyT2WVsB11qiuM9tGOr
         WaQ5XMfEpd3/FMgpGWTVK5dzL7c7BEcP/NUiuI/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Liu <liupeng256@huawei.com>,
        Marco Elver <elver@google.com>,
        Daniel Latypov <dlatypov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Wang Kefeng <wangkefeng.wang@huawei.com>,
        David Gow <davidgow@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0290/1126] kunit: make kunit_test_timeout compatible with comment
Date:   Tue,  5 Apr 2022 09:17:17 +0200
Message-Id: <20220405070416.126304096@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Peng Liu <liupeng256@huawei.com>

[ Upstream commit bdd015f7b71b92c2e4ecabac689642cc72553e04 ]

In function kunit_test_timeout, it is declared "300 * MSEC_PER_SEC"
represent 5min.  However, it is wrong when dealing with arm64 whose
default HZ = 250, or some other situations.  Use msecs_to_jiffies to fix
this, and kunit_test_timeout will work as desired.

Link: https://lkml.kernel.org/r/20220309083753.1561921-3-liupeng256@huawei.com
Fixes: 5f3e06208920 ("kunit: test: add support for test abort")
Signed-off-by: Peng Liu <liupeng256@huawei.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Daniel Latypov <dlatypov@google.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Tested-by: Brendan Higgins <brendanhiggins@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Wang Kefeng <wangkefeng.wang@huawei.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/try-catch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/kunit/try-catch.c b/lib/kunit/try-catch.c
index be38a2c5ecc2..42825941f19f 100644
--- a/lib/kunit/try-catch.c
+++ b/lib/kunit/try-catch.c
@@ -52,7 +52,7 @@ static unsigned long kunit_test_timeout(void)
 	 * If tests timeout due to exceeding sysctl_hung_task_timeout_secs,
 	 * the task will be killed and an oops generated.
 	 */
-	return 300 * MSEC_PER_SEC; /* 5 min */
+	return 300 * msecs_to_jiffies(MSEC_PER_SEC); /* 5 min */
 }
 
 void kunit_try_catch_run(struct kunit_try_catch *try_catch, void *context)
-- 
2.34.1



