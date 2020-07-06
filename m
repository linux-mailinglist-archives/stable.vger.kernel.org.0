Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1FDB215E49
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 20:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbgGFS1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 14:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729657AbgGFS1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jul 2020 14:27:24 -0400
Received: from mail-oi1-x249.google.com (mail-oi1-x249.google.com [IPv6:2607:f8b0:4864:20::249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C81FC061794
        for <stable@vger.kernel.org>; Mon,  6 Jul 2020 11:27:24 -0700 (PDT)
Received: by mail-oi1-x249.google.com with SMTP id v202so19977311oia.6
        for <stable@vger.kernel.org>; Mon, 06 Jul 2020 11:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qqoupK5Oq6XKew6i6oyqJ6+pHqm95p/dfVqnR40LUaA=;
        b=Iqizygs0Qd97GZDMVr5MpvwQmOfgjGa2UIYaRHiioHiJ0vLDD6W8swj+li7Hr5Svhx
         LO9/lPvsugaN0/6egSTnXgsy1EAyz4KJfFrZkFR3QfG5BCtd18pLxBtTzFA1CaLlqbCt
         jEQOGwpkEXPy06MIkntvurVJNu6a9JgL7UByfxIbHsVXnoEyOJIeT8aFVonyvm+CJ3aZ
         t+s1JZPyorXK4j2tSOLwFoLeEu6MA/Z9EYSoxsjont9Q0X1H4GaAcgtCMEvAPlLLJEuw
         RZuxLdkZO/u32IzVhZf6kw4qro5XTFTAe+CI7wDg0ODIHGUzHlAtbeIzRiLNK2m11JyB
         V8xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qqoupK5Oq6XKew6i6oyqJ6+pHqm95p/dfVqnR40LUaA=;
        b=uB9SHBXnLfB3UQUMxP0zT3xRvB91a+WQ4pNaR7uztPa6K2VFGBHP6Z9UnC7sHgyV3L
         JrejuvzaRd1fsuPSoN80Pka9514wnwyaesCI1EVCW18PVOCmlnbAvkASk3WPfbLqwwUU
         ldCpWoxthvbCi/cuWflLkcZXFYf3cJ9I53pXH/M+e5egWZPt+GGhU4JlK1h0kNqdpQWc
         ggxzY0RUwVZTN0s22mub4SfRcbo1dkGg+O/dIr2S45AV3mNLSwA7ipoOg6QjGSOI5+pp
         +clTQIbwIcelSliTLL8upwZYQaOiTLGGC6cFNiiu7qgL//g+jygkMJjtOj5tOsB8b+e9
         RNvQ==
X-Gm-Message-State: AOAM530aqxV2AzvbZTlS7+Xr84/1fz11tRBw8k7TM7B59Qd1BAR+cLQo
        i74IA+tljpMJNU7AVqlxFO9Q9Mws/w==
X-Google-Smtp-Source: ABdhPJyWVGryZT5XObBbMQLsdgzLLnVckhY0wPAFG2dfmer9W5MvZSPtNAV1kDIPh+YBKZzAr3C5UarrWg==
X-Received: by 2002:aca:c683:: with SMTP id w125mr443202oif.37.1594060043510;
 Mon, 06 Jul 2020 11:27:23 -0700 (PDT)
Date:   Mon,  6 Jul 2020 18:27:13 +0000
In-Reply-To: <1592531704.23014.1.camel@mtkswgap22>
Message-Id: <20200706182713.3693762-1-nhuck@google.com>
Mime-Version: 1.0
References: <1592531704.23014.1.camel@mtkswgap22>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH v2] ARM: stacktrace: Fix unwind_frame for clang-built kernels
From:   Nathan Huckleberry <nhuck@google.com>
To:     linux@armlinux.org.uk, vincent.whitchurch@axis.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Huckleberry <nhuck@google.com>,
        Miles Chen <miles.chen@mediatek.com>, stable@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since clang does not push pc and sp in function prologues, the current
implementation of unwind_frame does not work. By using the previous
frame's lr/fp instead of saved pc/sp we get valid unwinds on clang-built
kernels.

The bounds check on next frame pointer must be changed as well since
there are 8 less bytes between frames.

This fixes /proc/<pid>/stack.

Link: https://github.com/ClangBuiltLinux/linux/issues/912
Reported-by: Miles Chen <miles.chen@mediatek.com>
Tested-by: Miles Chen <miles.chen@mediatek.com>
Cc: stable@vger.kernel.org
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 arch/arm/kernel/stacktrace.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
index cc726afea023..76ea4178a55c 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -22,6 +22,19 @@
  * A simple function epilogue looks like this:
  *	ldm	sp, {fp, sp, pc}
  *
+ * When compiled with clang, pc and sp are not pushed. A simple function
+ * prologue looks like this when built with clang:
+ *
+ *	stmdb	{..., fp, lr}
+ *	add	fp, sp, #x
+ *	sub	sp, sp, #y
+ *
+ * A simple function epilogue looks like this when built with clang:
+ *
+ *	sub	sp, fp, #x
+ *	ldm	{..., fp, pc}
+ *
+ *
  * Note that with framepointer enabled, even the leaf functions have the same
  * prologue and epilogue, therefore we can ignore the LR value in this case.
  */
@@ -34,6 +47,16 @@ int notrace unwind_frame(struct stackframe *frame)
 	low = frame->sp;
 	high = ALIGN(low, THREAD_SIZE);
 
+#ifdef CONFIG_CC_IS_CLANG
+	/* check current frame pointer is within bounds */
+	if (fp < low + 4 || fp > high - 4)
+		return -EINVAL;
+
+	frame->sp = frame->fp;
+	frame->fp = *(unsigned long *)(fp);
+	frame->pc = frame->lr;
+	frame->lr = *(unsigned long *)(fp + 4);
+#else
 	/* check current frame pointer is within bounds */
 	if (fp < low + 12 || fp > high - 4)
 		return -EINVAL;
@@ -42,6 +65,7 @@ int notrace unwind_frame(struct stackframe *frame)
 	frame->fp = *(unsigned long *)(fp - 12);
 	frame->sp = *(unsigned long *)(fp - 8);
 	frame->pc = *(unsigned long *)(fp - 4);
+#endif
 
 	return 0;
 }
-- 
2.27.0.212.ge8ba1cc988-goog

