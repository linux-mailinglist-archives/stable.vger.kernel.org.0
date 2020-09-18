Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3AAE26F30D
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgIRDDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:03:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726690AbgIRCE4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:04:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9D0B23770;
        Fri, 18 Sep 2020 02:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394695;
        bh=30aueBxnLewts4sm1SeRzuk0NwIdhEbuLDPo3L7enzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehD15/++NYHpWWy5D4UYJ7ytSAvLA+uXR7lpJv7AMnsVPlimiBk+aIJtew/KDpTnE
         aCEXhGSXeT7Pb5gSPUvYhnyOSQ6+IHCwCsppmtFWQGMceunFJPmKZ2KSmXbYf9muNM
         EhqT9Zl61xYb9u5T4Yhu2rHAM8yy2EY376LXlUEc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 183/330] tracing: Use address-of operator on section symbols
Date:   Thu, 17 Sep 2020 21:58:43 -0400
Message-Id: <20200918020110.2063155-183-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
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
index 9007f5edbb207..db8162b34ef64 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9146,7 +9146,7 @@ __init static int tracer_alloc_buffers(void)
 		goto out_free_buffer_mask;
 
 	/* Only allocate trace_printk buffers if a trace_printk exists */
-	if (__stop___trace_bprintk_fmt != __start___trace_bprintk_fmt)
+	if (&__stop___trace_bprintk_fmt != &__start___trace_bprintk_fmt)
 		/* Must be called before global_trace.buffer is allocated */
 		trace_printk_init_buffers();
 
-- 
2.25.1

