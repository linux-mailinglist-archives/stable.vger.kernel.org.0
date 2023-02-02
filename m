Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDB668878D
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 20:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbjBBTh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 14:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjBBTh0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 14:37:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04005C0E1;
        Thu,  2 Feb 2023 11:37:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D42F61CC6;
        Thu,  2 Feb 2023 19:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227E3C433D2;
        Thu,  2 Feb 2023 19:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675366643;
        bh=4e46JInjnjZKjRFMgQ2weMULqLe3vkPvhBUGL2iO9W4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=swT4RJMJgm1m3BZS2L3c0weByeIpHR112Xp37PERpjxlHh5ba4Xq8QQkakegPF5qz
         nnOmKROiAvinBP5lnL49KMWMz0s37jlyO7xb1Auc36om0btfUxWjO77hTwW97KonRt
         Tpe9Tjd9KUAJfkIFQiW6JuFjxY4gZb89IsMShk+ZuPxEHHjBq7epJjjyvpbPwXaWjN
         6nDilk6B5bmjtQ+sDtMGhVMK7WmboHxFFYfceeV+K0tVPCfoe8XJ++fJJOg9Xy/301
         6B/ckEu296OBwB2bBhKNyptDwUR+H0k5UvTHLkqW28xVHDH0Jfhqxw4o9uwS/6k/Bs
         oUCh833BeT0Nw==
From:   SeongJae Park <sj@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
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
Subject: Re: [PATCH 4.19 03/16] mm: kasan: do not panic if both panic_on_warn and kasan_multishot set
Date:   Thu,  2 Feb 2023 19:37:20 +0000
Message-Id: <20230202193720.168040-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230202052604.179184-4-ebiggers@kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 1 Feb 2023 21:25:51 -0800 Eric Biggers <ebiggers@kernel.org> wrote:

> From: David Gow <davidgow@google.com>
> 
> commit be4f1ae978ffe98cc95ec49ceb95386fb4474974 upstream.
> 
> KASAN errors will currently trigger a panic when panic_on_warn is set.
> This renders kasan_multishot useless, as further KASAN errors won't be
> reported if the kernel has already paniced.  By making kasan_multishot
> disable this behaviour for KASAN errors, we can still have the benefits of
> panic_on_warn for non-KASAN warnings, yet be able to use kasan_multishot.
> 
> This is particularly important when running KASAN tests, which need to
> trigger multiple KASAN errors: previously these would panic the system if
> panic_on_warn was set, now they can run (and will panic the system should
> non-KASAN warnings show up).
> 
> Signed-off-by: David Gow <davidgow@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Tested-by: Andrey Konovalov <andreyknvl@google.com>
> Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
> Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
> Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Juri Lelli <juri.lelli@redhat.com>
> Cc: Patricia Alfonso <trishalfonso@google.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Link: https://lkml.kernel.org/r/20200915035828.570483-6-davidgow@google.com
> Link: https://lkml.kernel.org/r/20200910070331.3358048-6-davidgow@google.com
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  mm/kasan/report.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/kasan/report.c b/mm/kasan/report.c
> index 5c169aa688fde..90fdb261a5e2d 100644
> --- a/mm/kasan/report.c
> +++ b/mm/kasan/report.c
> @@ -176,7 +176,7 @@ static void kasan_end_report(unsigned long *flags)
>  	pr_err("==================================================================\n");
>  	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
>  	spin_unlock_irqrestore(&report_lock, *flags);
> -	if (panic_on_warn)
> +	if (panic_on_warn && !test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
>  		panic("panic_on_warn set ...\n");
>  	kasan_enable_current();


Seems this introduced a build failure when CONFIG_KASAN is enabled, as also
reported by Sasha[1].

    mm/kasan/report.c: In function ‘kasan_end_report’:
    mm/kasan/report.c:179:16: error: ‘KASAN_BIT_MULTI_SHOT’ undeclared (first use in this function)
      179 |  if (!test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
          |                ^~~~~~~~~~~~~~~~~~~~
    arch/x86/include/asm/bitops.h:342:25: note: in definition of macro ‘test_bit’
      342 |  (__builtin_constant_p((nr))  \
          |                         ^~
    mm/kasan/report.c:179:16: note: each undeclared identifier is reported only once for each function it appears in
      179 |  if (!test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
          |                ^~~~~~~~~~~~~~~~~~~~
    arch/x86/include/asm/bitops.h:342:25: note: in definition of macro ‘test_bit’
      342 |  (__builtin_constant_p((nr))  \
          |                         ^~
    mm/kasan/report.c:179:39: error: ‘kasan_flags’ undeclared (first use in this function)
      179 |  if (!test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
          |                                       ^~~~~~~~~~~
    arch/x86/include/asm/bitops.h:343:30: note: in definition of macro ‘test_bit’
      343 |   ? constant_test_bit((nr), (addr)) \
          |                              ^~~~

I confirmed dropping this patch fixes the build failure.  It causes a conflict
to a following patch[1], but seems it's not that difficult to resolve.  I
updated kernel/panic.c part of the patch like attached below to resolve the
conflict.

[1] https://lore.kernel.org/stable/Y9v3G6UantaCo29G@sashalap/
[2] https://lore.kernel.org/stable/20230202052604.179184-13-ebiggers@kernel.org/


Thanks,
SJ


================================ >8 ===========================================

diff --git a/kernel/panic.c b/kernel/panic.c
index a078d413042f..08b8adc55b2b 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -125,6 +125,12 @@ void nmi_panic(struct pt_regs *regs, const char *msg)
 }
 EXPORT_SYMBOL(nmi_panic);

+void check_panic_on_warn(const char *origin)
+{
+       if (panic_on_warn)
+               panic("%s: panic_on_warn set ...\n", origin);
+}
+
 /**
  *     panic - halt the system
  *     @fmt: The text string to print
@@ -540,8 +546,7 @@ void __warn(const char *file, int line, void *caller, unsigned taint,
        if (args)
                vprintk(args->fmt, args->args);

-       if (panic_on_warn)
-               panic("panic_on_warn set ...\n");
+       check_panic_on_warn("kernel");

        print_modules();

