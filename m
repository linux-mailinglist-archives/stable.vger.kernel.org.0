Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CE3499E34
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352462AbiAXWau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1585959AbiAXWZZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:25:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DCD6C0418BE;
        Mon, 24 Jan 2022 12:54:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C0C6612CA;
        Mon, 24 Jan 2022 20:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9537C340E5;
        Mon, 24 Jan 2022 20:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057644;
        bh=NhTprGcyprwLpWfIqENv8mq2r3cv0BORHm4H5znzBLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LrIh+S2h57PcTgFzqTSJXXfd+lNk6jEfwCXjpccbxyklSyKD4ktKqRAggx8sLK3Gc
         n99SPVths0vyWhXN6LCQkxfP/VuD+wg997U9lFpZG72j5hwWuh4K3fzG8MVeV2yESm
         pooZwyb+rmAf6xXMT1+YznnoTs8ARejbgSY8CFVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Willy Tarreau <w@1wt.eu>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.16 0032/1039] tools/nolibc: i386: fix initial stack alignment
Date:   Mon, 24 Jan 2022 19:30:21 +0100
Message-Id: <20220124184126.214759490@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
@@ -583,13 +583,21 @@ struct sys_stat_struct {
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


