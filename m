Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A587926EF30
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgIRCds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:33:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727960AbgIRCNm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:13:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA82F23977;
        Fri, 18 Sep 2020 02:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395221;
        bh=Z8IHuZLsc5cY1jPzZYhol1bmEhwUKDZVsue0I66Qxlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fI8jyPBlTh1dAxLIpsODBgnEM08CaCMGW2Xxr/qTQGiDAPi41js3mM1klLo5DFDsQ
         kjUoOHb9UxInmCG7O7rLgKexXvNpY3+vx2G8mV8XVOfROuf1ACGS5rkUUx3TuyK7z/
         wVktZXyV9rT3ffvY+lhT90UKxIeE9tiGtqmv15Bs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 068/127] tracing: Use address-of operator on section symbols
Date:   Thu, 17 Sep 2020 22:11:21 -0400
Message-Id: <20200918021220.2066485-68-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021220.2066485-1-sashal@kernel.org>
References: <20200918021220.2066485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit bf2cbe044da275021b2de5917240411a19e5c50d ]

Clang warns:

../kernel/trace/trace.c:9335:33: warning: array comparison always
evaluates to true [-Wtautological-compare]
        if (__stop___trace_bprintk_fmt != __start___trace_bprintk_fmt)
                                       ^
1 warning generated.

These are not true arrays, they are linker defined symbols, which are
just addresses. Using the address of operator silences the warning and
does not change the runtime result of the check (tested with some print
statements compiled in with clang + ld.lld and gcc + ld.bfd in QEMU).

Link: http://lkml.kernel.org/r/20200220051011.26113-1-natechancellor@gmail.com

Link: https://github.com/ClangBuiltLinux/linux/issues/893
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 22759f5607192..19526297a5b1c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8346,7 +8346,7 @@ __init static int tracer_alloc_buffers(void)
 		goto out_free_buffer_mask;
 
 	/* Only allocate trace_printk buffers if a trace_printk exists */
-	if (__stop___trace_bprintk_fmt != __start___trace_bprintk_fmt)
+	if (&__stop___trace_bprintk_fmt != &__start___trace_bprintk_fmt)
 		/* Must be called before global_trace.buffer is allocated */
 		trace_printk_init_buffers();
 
-- 
2.25.1

