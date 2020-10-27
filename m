Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661E429B8F7
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802125AbgJ0Ppm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801073AbgJ0Pip (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:38:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FCBF2225E;
        Tue, 27 Oct 2020 15:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813123;
        bh=wOjNKLHVKOVNFC4l8uU676lOdJzOWlDnPL4h1P83Ps8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pk/iF+DQOt2NrUyzIlYR6YrPrJK1dFG8sCt5ZwIaAAhcJ1BvHnnSwbVDw+idVdsTR
         No1rW/mSIdIMh/bCeyPePypsmUxr0ZHwggQqgSy5ASUCAZ4NeQIfuC0w/mNTfQAaYx
         qRaJCuyEo4s1VpIse7lZTB7nAf6znECUYWWj9X+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jordan Niethe <jniethe5@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 415/757] selftests/powerpc: Fix prefixes in alignment_handler signal handler
Date:   Tue, 27 Oct 2020 14:51:05 +0100
Message-Id: <20201027135510.045739196@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jordan Niethe <jniethe5@gmail.com>

[ Upstream commit db96221a683342fd4775fd820a4d5376cd2f2ed0 ]

The signal handler in the alignment handler self test has the ability
to jump over the instruction that triggered the signal. It does this
by incrementing the PT_NIP in the user context by 4. If it were a
prefixed instruction this will mean that the suffix is then executed
which is incorrect. Instead check if the major opcode indicates a
prefixed instruction (e.g. it is 1) and if so increment PT_NIP by 8.

If ISA v3.1 is not available treat it as a word instruction even if
the major opcode is 1.

Fixes: 620a6473df36 ("selftests/powerpc: Add prefixed loads/stores to alignment_handler test")
Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
[mpe: Fix 32-bit build, rename haveprefixes to prefixes_enabled]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200824131231.14008-1-jniethe5@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/powerpc/alignment/alignment_handler.c    | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/powerpc/alignment/alignment_handler.c b/tools/testing/selftests/powerpc/alignment/alignment_handler.c
index 55ef15184057d..386bca731e581 100644
--- a/tools/testing/selftests/powerpc/alignment/alignment_handler.c
+++ b/tools/testing/selftests/powerpc/alignment/alignment_handler.c
@@ -64,6 +64,7 @@ int bufsize;
 int debug;
 int testing;
 volatile int gotsig;
+bool prefixes_enabled;
 char *cipath = "/dev/fb0";
 long cioffset;
 
@@ -77,7 +78,12 @@ void sighandler(int sig, siginfo_t *info, void *ctx)
 	}
 	gotsig = sig;
 #ifdef __powerpc64__
-	ucp->uc_mcontext.gp_regs[PT_NIP] += 4;
+	if (prefixes_enabled) {
+		u32 inst = *(u32 *)ucp->uc_mcontext.gp_regs[PT_NIP];
+		ucp->uc_mcontext.gp_regs[PT_NIP] += ((inst >> 26 == 1) ? 8 : 4);
+	} else {
+		ucp->uc_mcontext.gp_regs[PT_NIP] += 4;
+	}
 #else
 	ucp->uc_mcontext.uc_regs->gregs[PT_NIP] += 4;
 #endif
@@ -648,6 +654,8 @@ int main(int argc, char *argv[])
 		exit(1);
 	}
 
+	prefixes_enabled = have_hwcap2(PPC_FEATURE2_ARCH_3_1);
+
 	rc |= test_harness(test_alignment_handler_vsx_206,
 			   "test_alignment_handler_vsx_206");
 	rc |= test_harness(test_alignment_handler_vsx_207,
-- 
2.25.1



