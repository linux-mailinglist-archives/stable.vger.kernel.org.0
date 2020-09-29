Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8A427C4F2
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729496AbgI2LXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:23:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729372AbgI2LTJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:19:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD0C8206A5;
        Tue, 29 Sep 2020 11:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378282;
        bh=Z8IHuZLsc5cY1jPzZYhol1bmEhwUKDZVsue0I66Qxlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BypB180PpLapNa8MWZ+3j2GlVWlkDaRp9oTfsWZBB6sUWaRe7uqKeOKk3dYCAvTb5
         KNGL7XR0Up6qqBshO0gm5UyIWYh/o+UKjvw3qYe2c1Nh2y24PROSC+4ItiXTMTzUd8
         QcHcZduJItZnpg4AGb5qx2CHOn7TVyeXszGCq/ek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 085/166] tracing: Use address-of operator on section symbols
Date:   Tue, 29 Sep 2020 12:59:57 +0200
Message-Id: <20200929105939.459306524@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



