Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160C768755C
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 06:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbjBBFpg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 00:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjBBFp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 00:45:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AC738B51;
        Wed,  1 Feb 2023 21:45:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D9F1B824B5;
        Thu,  2 Feb 2023 05:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34532C433A1;
        Thu,  2 Feb 2023 05:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675316721;
        bh=gNpeNx44gA3Dz1NMaDk9iVn8+H0TL/VgfW5SQ5YlGbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OolubR8pKL/RnLJbpN5zSOftp0IqZka7ShfPX76E8roX4CCM3Rj6vFuuB83VXJyKr
         EvnbnG9IUyDeo8Y05Rl+imBdQpEWvwUm1gaXhbISZYFdJEXcFB0WLG0xA65N4OwLCP
         A6LluPHlXIVQAmLftwQ48uE3UkiLutIaWGRKL59nlErxNsY/izvZDSzH/ChNmy9o9Z
         6S6LdsyfMxoJ6aDpDDHr6iT7nGgAnljQtkvx6TaE2B1HhMxIb1OgwGi2Mj+Pu5YiDF
         NE3qiXhkBix2lLR+yhiNSXjlIHJdALpMmeNULu6mNy+VD1q3GpbOVLjJF2NgSjR57D
         2i6ysfC7LU/AA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Baoquan He <bhe@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Xuefeng Li <lixuefeng@loongson.cn>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Marco Elver <elver@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 02/16] panic: unset panic_on_warn inside panic()
Date:   Wed,  1 Feb 2023 21:43:52 -0800
Message-Id: <20230202054406.221721-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230202054406.221721-1-ebiggers@kernel.org>
References: <20230202054406.221721-1-ebiggers@kernel.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit 1a2383e8b84c0451fd9b1eec3b9aab16f30b597c upstream.

In the current code, the following three places need to unset
panic_on_warn before calling panic() to avoid recursive panics:

kernel/kcsan/report.c: print_report()
kernel/sched/core.c: __schedule_bug()
mm/kfence/report.c: kfence_report_error()

In order to avoid copy-pasting "panic_on_warn = 0" all over the places,
it is better to move it inside panic() and then remove it from the other
places.

Link: https://lkml.kernel.org/r/1644324666-15947-4-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 kernel/panic.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 207ceac3a432e..bd7c3ea3bf1e6 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -139,6 +139,16 @@ void panic(const char *fmt, ...)
 	int old_cpu, this_cpu;
 	bool _crash_kexec_post_notifiers = crash_kexec_post_notifiers;
 
+	if (panic_on_warn) {
+		/*
+		 * This thread may hit another WARN() in the panic path.
+		 * Resetting this prevents additional WARN() from panicking the
+		 * system on this thread.  Other threads are blocked by the
+		 * panic_mutex in panic().
+		 */
+		panic_on_warn = 0;
+	}
+
 	/*
 	 * Disable local interrupts. This will prevent panic_smp_self_stop
 	 * from deadlocking the first cpu that invokes the panic, since
@@ -536,16 +546,8 @@ void __warn(const char *file, int line, void *caller, unsigned taint,
 	if (args)
 		vprintk(args->fmt, args->args);
 
-	if (panic_on_warn) {
-		/*
-		 * This thread may hit another WARN() in the panic path.
-		 * Resetting this prevents additional WARN() from panicking the
-		 * system on this thread.  Other threads are blocked by the
-		 * panic_mutex in panic().
-		 */
-		panic_on_warn = 0;
+	if (panic_on_warn)
 		panic("panic_on_warn set ...\n");
-	}
 
 	print_modules();
 
-- 
2.39.1

