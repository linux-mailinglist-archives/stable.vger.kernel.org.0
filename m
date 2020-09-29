Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E494B27C34B
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbgI2LE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:04:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728586AbgI2LEV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:04:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD87920C09;
        Tue, 29 Sep 2020 11:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377460;
        bh=zmCezSv8mK+yb4xuSGtAO17x+Idcop8nimvbwBBa0Lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YugSKQyI63fWC5kBp5UlfPCKtQ5MedCooLv1pxUrpERYJcpqGQQPbePhFaMs6vaDF
         dAo9yL16qU+MKMeGGtAbKQWR7DAo1h+v7+ArCQmZwziLWiHMhYuBc7kqCC7ZZq98eU
         qn9R0CICi4rtIydSRxN1y8nesK1J95DhwqFDhknA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 44/85] tracing: Use address-of operator on section symbols
Date:   Tue, 29 Sep 2020 13:00:11 +0200
Message-Id: <20200929105930.436488959@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105928.198942536@linuxfoundation.org>
References: <20200929105928.198942536@linuxfoundation.org>
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
index 17ea5f9d36b48..e4a0c0308b507 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -7263,7 +7263,7 @@ __init static int tracer_alloc_buffers(void)
 		goto out_free_buffer_mask;
 
 	/* Only allocate trace_printk buffers if a trace_printk exists */
-	if (__stop___trace_bprintk_fmt != __start___trace_bprintk_fmt)
+	if (&__stop___trace_bprintk_fmt != &__start___trace_bprintk_fmt)
 		/* Must be called before global_trace.buffer is allocated */
 		trace_printk_init_buffers();
 
-- 
2.25.1



