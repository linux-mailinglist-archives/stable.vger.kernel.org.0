Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E25B4D34C4
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiCIQ0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235738AbiCIQYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:24:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ADE72B269;
        Wed,  9 Mar 2022 08:21:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBD1A61926;
        Wed,  9 Mar 2022 16:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50B3C340F8;
        Wed,  9 Mar 2022 16:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842917;
        bh=uIZCe6E8jZb9HUb1IBq2CrYznAY50Ov0CeC0YvXDCs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IS6650eVDCoL4dhdx0lB/TGLLmRnJG0iLPVRzEy6GYMEo24iEreElVdu3aIooqtDv
         016ypivxmDdlVW7Uq/97IeNXfG4NjA1Z8HtgvuxGf38vrYg+4rxHCy/ReXRQ3/u5q3
         mAiuVJ8F3s99Ch5lps0rO/BUKb16KeUfD/BE/dbA+m2wEXna+58/sxeOlstAlO5+66
         /zyxiM0qWEskrt2dFlCIislWCi0XUGd9fgDhxWvlqqnONSacIVGSKyqHvn3rQ8XLyw
         ETsNLOv0PerQV812Doi9i41+lVTXAp4OwuXBG906Nh5LF64tPBl559uS1rcqg9MBpz
         J+f8wUMETmnwA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengming Zhou <zhouchengming@bytedance.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 24/24] kselftest/vm: fix tests build with old libc
Date:   Wed,  9 Mar 2022 11:19:43 -0500
Message-Id: <20220309161946.136122-24-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309161946.136122-1-sashal@kernel.org>
References: <20220309161946.136122-1-sashal@kernel.org>
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
index 81690f1737c8..138b011c667e 100644
--- a/tools/testing/selftests/vm/userfaultfd.c
+++ b/tools/testing/selftests/vm/userfaultfd.c
@@ -46,6 +46,7 @@
 #include <signal.h>
 #include <poll.h>
 #include <string.h>
+#include <linux/mman.h>
 #include <sys/mman.h>
 #include <sys/syscall.h>
 #include <sys/ioctl.h>
-- 
2.34.1

