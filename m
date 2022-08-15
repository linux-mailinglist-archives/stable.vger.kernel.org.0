Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B73E5942EF
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348902AbiHOWcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348476AbiHOW2o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:28:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B0FB6D7B;
        Mon, 15 Aug 2022 12:48:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F1016125E;
        Mon, 15 Aug 2022 19:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BFBC433D6;
        Mon, 15 Aug 2022 19:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592883;
        bh=GUDAZS/+eUIcCGBBfhfW4KeWzTJXZXRYQZKOZTAGzHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lzwU+BRXx7QH1UgkiltZMMinqINSt7AOXR+MpfJpGnmn47o12kB1BjNr+x0pepWmX
         aWpydLN9iA2wGeMrlo/3EMRdTkg5+MPm5DA8vM65kim1sOlxIwQoHy465a5B+FRsLa
         FuLkCV1GmO3yKhHtB+gYSYQktDYNMQD5hezkgURI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0149/1157] arm64: kasan: do not instrument stacktrace.c
Date:   Mon, 15 Aug 2022 19:51:45 +0200
Message-Id: <20220815180445.630849382@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Andrey Konovalov <andreyknvl@google.com>

[ Upstream commit 802b91118d11227b527153849ea761b280691373 ]

Disable KASAN instrumentation of arch/arm64/kernel/stacktrace.c.

This speeds up Generic KASAN by 5-20%.

As a side-effect, KASAN is now unable to detect bugs in the stack trace
collection code. This is taken as an acceptable downside.

Also replace READ_ONCE_NOCHECK() with READ_ONCE() in stacktrace.c.
As the file is now not instrumented, there is no need to use the
NOCHECK version of READ_ONCE().

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Link: https://lore.kernel.org/r/c4c944a2a905e949760fbeb29258185087171708.1653317461.git.andreyknvl@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/Makefile     | 5 +++++
 arch/arm64/kernel/stacktrace.c | 4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index fa7981d0d917..7075a9c6a4a6 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -14,6 +14,11 @@ CFLAGS_REMOVE_return_address.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_syscall.o	 = -fstack-protector -fstack-protector-strong
 CFLAGS_syscall.o	+= -fno-stack-protector
 
+# When KASAN is enabled, a stack trace is recorded for every alloc/free, which
+# can significantly impact performance. Avoid instrumenting the stack trace
+# collection code to minimize this impact.
+KASAN_SANITIZE_stacktrace.o := n
+
 # It's not safe to invoke KCOV when portions of the kernel environment aren't
 # available or are out-of-sync with HW state. Since `noinstr` doesn't always
 # inhibit KCOV instrumentation, disable it for the entire compilation unit.
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 0467cb79f080..c246e8d9f95b 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -124,8 +124,8 @@ static int notrace unwind_next(struct task_struct *tsk,
 	 * Record this frame record's values and location. The prev_fp and
 	 * prev_type are only meaningful to the next unwind_next() invocation.
 	 */
-	state->fp = READ_ONCE_NOCHECK(*(unsigned long *)(fp));
-	state->pc = READ_ONCE_NOCHECK(*(unsigned long *)(fp + 8));
+	state->fp = READ_ONCE(*(unsigned long *)(fp));
+	state->pc = READ_ONCE(*(unsigned long *)(fp + 8));
 	state->prev_fp = fp;
 	state->prev_type = info.type;
 
-- 
2.35.1



