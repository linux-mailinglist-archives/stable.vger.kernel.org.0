Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B21687481
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 05:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjBBEoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 23:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbjBBEoF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 23:44:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D91E7C73F;
        Wed,  1 Feb 2023 20:43:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04B1AB8241B;
        Thu,  2 Feb 2023 04:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E379C4339E;
        Thu,  2 Feb 2023 04:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675313028;
        bh=3jGoUYb5ZXXZkAA7E72JChHDGyEWYUsA360wTbKvQOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FIqlkGAjxOmAJ97Zovh+TPaze9M0KI4n65AH/v7tUvMHAYqucSztv9HtRFnLwcBrU
         3WqsXIsi/KPRVzGBNa6ZFHiFbiU6W31p2Fg1/G9ZHszwR2F5nmTwwPTmnvtjl5UME8
         aR+umkpiBFHZPrINcn33lds233qs08T2QoKpgN8VfDwS2CC2bNuOgqoFvPQerf23qW
         sCnp0aYHz0bIBDyNK2LzqD1EbOXZa1JksNWGTqxpXvbTZWA45QJB8q8DQQpEoIWAnM
         8mGcqfjNNNogf7BbhshMK4etUtq7mAxBxfptwNFVZLxb1iUurzzxKsKklFpZ+KCDD0
         3yd4+seZdW77w==
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
Subject: [PATCH 5.4 03/17] mm: kasan: do not panic if both panic_on_warn and kasan_multishot set
Date:   Wed,  1 Feb 2023 20:42:41 -0800
Message-Id: <20230202044255.128815-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230202044255.128815-1-ebiggers@kernel.org>
References: <20230202044255.128815-1-ebiggers@kernel.org>
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
index 621782100eaa0..a05ff1922d499 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -92,7 +92,7 @@ static void end_report(unsigned long *flags)
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

