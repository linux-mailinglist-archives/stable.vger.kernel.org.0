Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C6667A1C0
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 19:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbjAXSwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 13:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233944AbjAXSwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 13:52:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417202BF13;
        Tue, 24 Jan 2023 10:52:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D458D61330;
        Tue, 24 Jan 2023 18:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291BBC4339B;
        Tue, 24 Jan 2023 18:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674586324;
        bh=FJr8BjrY0TIgcS5b++r8ZCSIVGNroe0iaKdta2nV8tU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hPRqhYfAAwS2D4UwqLKr7br8D3sFNtDuz1WqxABvTidT6NHiPbhd4DU3Vas76Bb2F
         JoSSlVn+wKXv3/d1K3a+ytz8zSk465FdOgwUzsLr23Fds2HlmnO/XpmNjwUQA6tQTZ
         Upg2rUoDo1hoRUxQdmPyCnjoqPxG9Qanncdf5eq56x2wQ+BJDRj1Ug0IqBz+eNkkSH
         qyLlzrqGVfDycGG4gnqgz2+cxim2YA6l1pmlEBmK/fwUMBgB2uyCohLiyr023D43AH
         3jbZCumbSXOh+ztmEe8EDZlshcYrkHM5GrqrOgJoDQgB6YvY7jERq56tut5PEXrxQ1
         Beu78xbyek35g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, SeongJae Park <sj@kernel.org>,
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
Subject: [PATCH 5.15 05/20] kasan: no need to unset panic_on_warn in end_report()
Date:   Tue, 24 Jan 2023 10:50:55 -0800
Message-Id: <20230124185110.143857-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124185110.143857-1-ebiggers@kernel.org>
References: <20230124185110.143857-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit e7ce7500375a63348e1d3a703c8d5003cbe3fea6 upstream.

panic_on_warn is unset inside panic(), so no need to unset it before
calling panic() in end_report().

Link: https://lkml.kernel.org/r/1644324666-15947-6-git-send-email-yangtiezhu@loongson.cn
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
 mm/kasan/report.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 884a950c70265..bf17704b302fc 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -117,16 +117,8 @@ static void end_report(unsigned long *flags, unsigned long addr)
 	pr_err("==================================================================\n");
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 	spin_unlock_irqrestore(&report_lock, *flags);
-	if (panic_on_warn && !test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags)) {
-		/*
-		 * This thread may hit another WARN() in the panic path.
-		 * Resetting this prevents additional WARN() from panicking the
-		 * system on this thread.  Other threads are blocked by the
-		 * panic_mutex in panic().
-		 */
-		panic_on_warn = 0;
+	if (panic_on_warn && !test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
 		panic("panic_on_warn set ...\n");
-	}
 	if (kasan_arg_fault == KASAN_ARG_FAULT_PANIC)
 		panic("kasan.fault=panic set ...\n");
 	kasan_enable_current();
-- 
2.39.1

