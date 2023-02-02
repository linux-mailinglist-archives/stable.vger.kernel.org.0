Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99136687520
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 06:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjBBF2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 00:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjBBF2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 00:28:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDD014E9A;
        Wed,  1 Feb 2023 21:28:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8052B824B4;
        Thu,  2 Feb 2023 05:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992F2C433EF;
        Thu,  2 Feb 2023 05:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675315683;
        bh=fdhiGzoneKEwa2llZBhl60Z7qg58b1f/mZA06RgXQb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJTRJ6Iye1+rASmz7WEQpD9Mtnb9tTfYNgHKg8HEzp85eWtQTP4cwjB29dmwfQaV2
         EsIviZvfTDdjlURyza8Z1vM0U4CC/mpLNgEEbvm+7rbC2Ez5S+lcFEThq5zB9g4sdJ
         cGWwt91hoSoAfcidcrhBVkUoUwXagtICA/3dz7Hnofc6AOOr9Qs05YV/7K32Ih74NY
         vZT7qfigTHP6IZ6TJEtK3+2oih2Ue0UX6aHcqdXDladFy0ytL2hbZMyfY4gpTTc6pQ
         VsCmuLeouWF8b4spML9Q/N4m97jqXFypQNOe1ic2xgdG5Hq36Gp84ic7NcbeuSuV+E
         EJ7Meiv7JRqZw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Patricia Alfonso <trishalfonso@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Shuah Khan <shuah@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        David Gow <davidgow@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Konovalov <andreyknvl@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 03/16] mm: kasan: do not panic if both panic_on_warn and kasan_multishot set
Date:   Wed,  1 Feb 2023 21:25:51 -0800
Message-Id: <20230202052604.179184-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230202052604.179184-1-ebiggers@kernel.org>
References: <20230202052604.179184-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Gow <davidgow@google.com>

commit be4f1ae978ffe98cc95ec49ceb95386fb4474974 upstream.

KASAN errors will currently trigger a panic when panic_on_warn is set.
This renders kasan_multishot useless, as further KASAN errors won't be
reported if the kernel has already paniced.  By making kasan_multishot
disable this behaviour for KASAN errors, we can still have the benefits of
panic_on_warn for non-KASAN warnings, yet be able to use kasan_multishot.

This is particularly important when running KASAN tests, which need to
trigger multiple KASAN errors: previously these would panic the system if
panic_on_warn was set, now they can run (and will panic the system should
non-KASAN warnings show up).

Signed-off-by: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Patricia Alfonso <trishalfonso@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lkml.kernel.org/r/20200915035828.570483-6-davidgow@google.com
Link: https://lkml.kernel.org/r/20200910070331.3358048-6-davidgow@google.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 mm/kasan/report.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 5c169aa688fde..90fdb261a5e2d 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -176,7 +176,7 @@ static void kasan_end_report(unsigned long *flags)
 	pr_err("==================================================================\n");
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 	spin_unlock_irqrestore(&report_lock, *flags);
-	if (panic_on_warn)
+	if (panic_on_warn && !test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
 		panic("panic_on_warn set ...\n");
 	kasan_enable_current();
 }
-- 
2.39.1

