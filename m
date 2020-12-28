Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40BAE2E4094
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408027AbgL1Ox4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:53:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:52078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441495AbgL1ORp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:17:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A81F6224D2;
        Mon, 28 Dec 2020 14:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165050;
        bh=G6il93/NNmksArCwy6xVAv30XGUnSnOY25/djLLRToA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EHFr7MlbvGE9PJSNhbZv90OfAsYQ3vFgS8T3EmH0yAwJjW1TNH94IUmzJAFuRwCR/
         XW8SP2BJJlQ6rjGUgV1UhbT+wJmlP0RBD7ANXK8vgF4nhXtGIyBvtPXEBf+2/muVFn
         Jwa5nmh/1axpUactsuJ+IJKUBaXnRfztrMGYtVao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 393/717] powerpc/sstep: Cover new VSX instructions under CONFIG_VSX
Date:   Mon, 28 Dec 2020 13:46:31 +0100
Message-Id: <20201228125039.834665423@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>

[ Upstream commit 1817de2f141c718f1a0ae59927ec003e9b144349 ]

Recently added Power10 prefixed VSX instruction are included
unconditionally in the kernel. If they are executed on a
machine without VSX support, it might create issues. Fix that.
Also fix one mnemonics spelling mistake in comment.

Fixes: 50b80a12e4cc ("powerpc sstep: Add support for prefixed load/stores")
Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201011050908.72173-3-ravi.bangoria@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/lib/sstep.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/lib/sstep.c b/arch/powerpc/lib/sstep.c
index bf2cd3d42125d..b18bce1a209fa 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -2757,6 +2757,7 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 			case 41:	/* plwa */
 				op->type = MKOP(LOAD, PREFIXED | SIGNEXT, 4);
 				break;
+#ifdef CONFIG_VSX
 			case 42:        /* plxsd */
 				op->reg = rd + 32;
 				op->type = MKOP(LOAD_VSX, PREFIXED, 8);
@@ -2797,13 +2798,14 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 				op->element_size = 16;
 				op->vsx_flags = VSX_CHECK_VEC;
 				break;
+#endif /* CONFIG_VSX */
 			case 56:        /* plq */
 				op->type = MKOP(LOAD, PREFIXED, 16);
 				break;
 			case 57:	/* pld */
 				op->type = MKOP(LOAD, PREFIXED, 8);
 				break;
-			case 60:        /* stq */
+			case 60:        /* pstq */
 				op->type = MKOP(STORE, PREFIXED, 16);
 				break;
 			case 61:	/* pstd */
-- 
2.27.0



