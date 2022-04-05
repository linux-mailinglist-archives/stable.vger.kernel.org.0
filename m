Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FC14F35B9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234407AbiDEKyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346175AbiDEJoc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:44:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D76CCA0F1;
        Tue,  5 Apr 2022 02:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 078316165C;
        Tue,  5 Apr 2022 09:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11C7C385A2;
        Tue,  5 Apr 2022 09:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151012;
        bh=/kvIRSziW0x3o2dd/pwWaUBnYSKR0XEkNQf4oUXD/mg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQJE5urI2Wdmh1q+aYtn1p2MQT8UT+epjoAqv++74CF0SRqkN1tjdrhYa/A7T0S3n
         7tVFR0XAkadOO9b8kMkbrZcs/YpI401Z0qJY9SJJsc/wMf4RW5bCtJ0eikJf+SddRe
         AUqBbCDKF/fiuSsMLN7ovNwN+OIBZ8rz80WMxRyU=
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
Subject: [PATCH 5.15 263/913] kunit: make kunit_test_timeout compatible with comment
Date:   Tue,  5 Apr 2022 09:22:05 +0200
Message-Id: <20220405070347.739782572@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
index 0dd434e40487..71e5c5853099 100644
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



