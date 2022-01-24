Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13BCE4997F5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377214AbiAXVRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449098AbiAXVOx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:14:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801ECC09F494;
        Mon, 24 Jan 2022 12:11:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36980B81229;
        Mon, 24 Jan 2022 20:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D299C340E5;
        Mon, 24 Jan 2022 20:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055067;
        bh=NhTprGcyprwLpWfIqENv8mq2r3cv0BORHm4H5znzBLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D3hlJMWHY40D9ibSVQlXZSgchKjH6GXakgqvb5RMnegX3yPbx6GxEMRZQLwq+8Vp2
         vaGzYFveQT/uHj+EKnpH1QLly05zeAPaGH6n88mhuiHYcrDfoqypU3zuTtX962KNCh
         aztTCL3c23py+jZx3G89G4bbngvFKrIrmcgnjjnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Willy Tarreau <w@1wt.eu>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.15 030/846] tools/nolibc: i386: fix initial stack alignment
Date:   Mon, 24 Jan 2022 19:32:27 +0100
Message-Id: <20220124184101.963330674@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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


