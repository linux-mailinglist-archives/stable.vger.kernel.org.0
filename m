Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDE910BC8C
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732493AbfK0VGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:06:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:32774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731541AbfK0VGr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:06:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4D742086A;
        Wed, 27 Nov 2019 21:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888807;
        bh=r7xPYCGuPsGo1R+yB7dlU0oOx4E2V9pZb45mLGsJmn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rC+FIWeMdBKzQsPUFIoP5DUn0iSBufKTI1yYEd4J+Glxzic+k2DAIvcuWhwxcgcyl
         TLQaPOff58I8aSqqFBULJrTk4OZwccHh0TrvxlIQ8mFKcyZUQHna/kv8bWlfuWuKfq
         KaEQI9fIJd8T5BlttQ6Y7KOfrEEmpJArBprZfrqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>, stable@kernel.org
Subject: [PATCH 4.19 275/306] selftests/x86/sigreturn/32: Invalidate DS and ES when abusing the kernel
Date:   Wed, 27 Nov 2019 21:32:05 +0100
Message-Id: <20191127203134.896461776@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit 4d2fa82d98d2d296043a04eb517d7dbade5b13b8 upstream.

If the kernel accidentally uses DS or ES while the user values are
loaded, it will work fine for sane userspace.  In the interest of
simulating maximally insane userspace, make sigreturn_32 zero out DS
and ES for the nasty parts so that inadvertent use of these segments
will crash.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/x86/sigreturn.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/tools/testing/selftests/x86/sigreturn.c
+++ b/tools/testing/selftests/x86/sigreturn.c
@@ -459,6 +459,19 @@ static void sigusr1(int sig, siginfo_t *
 	ctx->uc_mcontext.gregs[REG_SP] = (unsigned long)0x8badf00d5aadc0deULL;
 	ctx->uc_mcontext.gregs[REG_CX] = 0;
 
+#ifdef __i386__
+	/*
+	 * Make sure the kernel doesn't inadvertently use DS or ES-relative
+	 * accesses in a region where user DS or ES is loaded.
+	 *
+	 * Skip this for 64-bit builds because long mode doesn't care about
+	 * DS and ES and skipping it increases test coverage a little bit,
+	 * since 64-bit kernels can still run the 32-bit build.
+	 */
+	ctx->uc_mcontext.gregs[REG_DS] = 0;
+	ctx->uc_mcontext.gregs[REG_ES] = 0;
+#endif
+
 	memcpy(&requested_regs, &ctx->uc_mcontext.gregs, sizeof(gregset_t));
 	requested_regs[REG_CX] = *ssptr(ctx);	/* The asm code does this. */
 


