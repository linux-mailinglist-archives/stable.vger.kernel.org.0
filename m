Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42CA24D36BD
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 18:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235380AbiCIQfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238759AbiCIQbr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:31:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC2A1A06C8;
        Wed,  9 Mar 2022 08:26:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40AABB82253;
        Wed,  9 Mar 2022 16:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD28AC340EC;
        Wed,  9 Mar 2022 16:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646843177;
        bh=wEoJkZLmzdMrIsHPFU3oRk0kM0mMwx+PzxnxITksLjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ctfj+KRo6x8UcDkQxLkzoON8UNj65F18r+wgWoGtHM34hcwdszqivHiIwjbLRPEHV
         rcFNN3wJjAQKx1Xl+rJvYvWEFOOAsZyYmiJn8+A5h0KOLtzJrbJAKpKsivAvZkUmYU
         H4jINJNxhxxxN9vkr6YTeMacBoAUsykAld0cjXnO10kLvvRYmUR4DMARCFgoCEwRTH
         FF1ylDPmovak65oYHl4N9OeYUwFNrD6UMyu0QLkyf1Yc6Kndfj1jrp42PlJzqTmqe3
         fOgHAs8V0HrFfdgWbz7AbF8WOi+zGM1XjsTEVGjzSggf9Swc2g0U5gb2wo+9Ahuj2P
         QfxJdOjrO58Vg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengming Zhou <zhouchengming@bytedance.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 14/14] kselftest/vm: fix tests build with old libc
Date:   Wed,  9 Mar 2022 11:25:07 -0500
Message-Id: <20220309162508.137035-14-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309162508.137035-1-sashal@kernel.org>
References: <20220309162508.137035-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengming Zhou <zhouchengming@bytedance.com>

[ Upstream commit b773827e361952b3f53ac6fa4c4e39ccd632102e ]

The error message when I build vm tests on debian10 (GLIBC 2.28):

    userfaultfd.c: In function `userfaultfd_pagemap_test':
    userfaultfd.c:1393:37: error: `MADV_PAGEOUT' undeclared (first use
    in this function); did you mean `MADV_RANDOM'?
      if (madvise(area_dst, test_pgsize, MADV_PAGEOUT))
                                         ^~~~~~~~~~~~
                                         MADV_RANDOM

This patch includes these newer definitions from UAPI linux/mman.h, is
useful to fix tests build on systems without these definitions in glibc
sys/mman.h.

Link: https://lkml.kernel.org/r/20220227055330.43087-2-zhouchengming@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/userfaultfd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/vm/userfaultfd.c b/tools/testing/selftests/vm/userfaultfd.c
index 1963440f6725..b2c7043c0c30 100644
--- a/tools/testing/selftests/vm/userfaultfd.c
+++ b/tools/testing/selftests/vm/userfaultfd.c
@@ -60,6 +60,7 @@
 #include <signal.h>
 #include <poll.h>
 #include <string.h>
+#include <linux/mman.h>
 #include <sys/mman.h>
 #include <sys/syscall.h>
 #include <sys/ioctl.h>
-- 
2.34.1

