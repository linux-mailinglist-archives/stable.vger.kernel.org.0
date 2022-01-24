Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAED498E9C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242748AbiAXTna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:43:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37046 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349011AbiAXTlZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:41:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7623614B8;
        Mon, 24 Jan 2022 19:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3E6C340E5;
        Mon, 24 Jan 2022 19:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053284;
        bh=KPoA4CJ44t2LfAsR757OJdlzVPP+4sLlen+NDQtwD7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lUQBM3y7w52KSFutkVOopTqC+vgTSZAdad0w6nedEfDgB+1jh5UDWxEj5wq/roetQ
         H+D9/LOqAK6umNSaeJJTJU9rXwal98900Un7nh57i9cvcsy6PwDE1CPHiJgKnbAV/L
         R6tzvb1qza7xt8OhxIevzkpYkFvki/HWI1YkRV0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Willy Tarreau <w@1wt.eu>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.10 016/563] tools/nolibc: i386: fix initial stack alignment
Date:   Mon, 24 Jan 2022 19:36:21 +0100
Message-Id: <20220124184024.981263898@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

commit ebbe0d8a449d183fa43b42d84fcb248e25303985 upstream.

After re-checking in the spec and comparing stack offsets with glibc,
The last pushed argument must be 16-byte aligned (i.e. aligned before the
call) so that in the callee esp+4 is multiple of 16, so the principle is
the 32-bit equivalent to what Ammar fixed for x86_64. It's possible that
32-bit code using SSE2 or MMX could have been affected. In addition the
frame pointer ought to be zero at the deepest level.

Link: https://gitlab.com/x86-psABIs/i386-ABI/-/wikis/Intel386-psABI
Cc: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Cc: stable@vger.kernel.org
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/nolibc/nolibc.h |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/tools/include/nolibc/nolibc.h
+++ b/tools/include/nolibc/nolibc.h
@@ -606,13 +606,21 @@ struct sys_stat_struct {
 })
 
 /* startup code */
+/*
+ * i386 System V ABI mandates:
+ * 1) last pushed argument must be 16-byte aligned.
+ * 2) The deepest stack frame should be set to zero
+ *
+ */
 asm(".section .text\n"
     ".global _start\n"
     "_start:\n"
     "pop %eax\n"                // argc   (first arg, %eax)
     "mov %esp, %ebx\n"          // argv[] (second arg, %ebx)
     "lea 4(%ebx,%eax,4),%ecx\n" // then a NULL then envp (third arg, %ecx)
-    "and $-16, %esp\n"          // x86 ABI : esp must be 16-byte aligned when
+    "xor %ebp, %ebp\n"          // zero the stack frame
+    "and $-16, %esp\n"          // x86 ABI : esp must be 16-byte aligned before
+    "sub $4, %esp\n"            // the call instruction (args are aligned)
     "push %ecx\n"               // push all registers on the stack so that we
     "push %ebx\n"               // support both regparm and plain stack modes
     "push %eax\n"


