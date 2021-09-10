Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6458C406311
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242303AbhIJAqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:46:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234109AbhIJAWw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:22:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF08F60F24;
        Fri, 10 Sep 2021 00:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233301;
        bh=0hqLhf3xDeqnlEfMl0vTqr15V4Eg04LXNoz6C5tPcGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YVDH9aWKaxZr5a9wibqWwUP5W8f1v7vt5GsOXneuax3Hus9E+LzUy+tRXbieL7HYB
         7DoWsy2p88ARFprlMd9ZaCNdrUM9GfaZoWsQyuhnJ9E3r9Q3GEiv6TAukyz8cvr+a3
         QWVUE0edFq39t0MBawqeRiz6smFaodWb7bOHVIGuXpqEFMzupbz6rO6XR4Xp4ghMLj
         xsGCo6RpMyIV0fyXIpFeNDtDfW7/JZmvedetWvaKNXM9+q0rEQWJ+kGP6eUJv64Q2C
         Lpl80t1DtuXiPu9Urz5u/c6u7OWNsGPV2zNOr96C0OM/7ogiQhLkO9ZrkNPkDRGohf
         Z7NXeaYe48TbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrey Konovalov <andreyknvl@gmail.com>,
        Marco Elver <elver@google.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, kasan-dev@googlegroups.com
Subject: [PATCH AUTOSEL 5.10 53/53] kasan: test: avoid corrupting memory in kasan_rcu_uaf
Date:   Thu,  9 Sep 2021 20:20:28 -0400
Message-Id: <20210910002028.175174-53-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002028.175174-1-sashal@kernel.org>
References: <20210910002028.175174-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Konovalov <andreyknvl@gmail.com>

[ Upstream commit f16de0bcdb55bf18e2533ca625f3e4b4952f254c ]

kasan_rcu_uaf() writes to freed memory via kasan_rcu_reclaim(), which is
only safe with the GENERIC mode (as it uses quarantine).  For other modes,
this test corrupts kernel memory, which might result in a crash.

Turn the write into a read.

Link: https://lkml.kernel.org/r/b6f2c3bf712d2457c783fa59498225b66a634f62.1628779805.git.andreyknvl@gmail.com
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_kasan_module.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/test_kasan_module.c b/lib/test_kasan_module.c
index 2d68db6ae67b..1c6e06136f78 100644
--- a/lib/test_kasan_module.c
+++ b/lib/test_kasan_module.c
@@ -73,7 +73,7 @@ static noinline void __init kasan_rcu_reclaim(struct rcu_head *rp)
 						struct kasan_rcu_info, rcu);
 
 	kfree(fp);
-	fp->i = 1;
+	((volatile struct kasan_rcu_info *)fp)->i;
 }
 
 static noinline void __init kasan_rcu_uaf(void)
-- 
2.30.2

