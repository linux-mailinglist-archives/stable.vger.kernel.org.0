Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D791D3AB8
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 20:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgENS6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 14:58:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729692AbgENS4X (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:56:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42783207ED;
        Thu, 14 May 2020 18:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482582;
        bh=AaG/Kbi5od21eNCWlwJuZhmK5c2eLLCkNMUr9nuuBg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9nq2Uj6c93StkCFCaa6D7R1Hlf1J28o2Qwuu+WVs70O+G3dedyB26FuOeA+nTWlk
         tr1aPBj54THVAHYudhz4b+ZLGCInTESceDBUAlVEUOFbpih4YLamjhAFdmM0gPlNYp
         YTIqqR+bai9lQESaKOaMgASmV7v97ZsMtQYP+aec=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 26/27] ARM: futex: Address build warning
Date:   Thu, 14 May 2020 14:55:49 -0400
Message-Id: <20200514185550.21462-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185550.21462-1-sashal@kernel.org>
References: <20200514185550.21462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 8101b5a1531f3390b3a69fa7934c70a8fd6566ad ]

Stephen reported the following build warning on a ARM multi_v7_defconfig
build with GCC 9.2.1:

kernel/futex.c: In function 'do_futex':
kernel/futex.c:1676:17: warning: 'oldval' may be used uninitialized in this function [-Wmaybe-uninitialized]
 1676 |   return oldval == cmparg;
      |          ~~~~~~~^~~~~~~~~
kernel/futex.c:1652:6: note: 'oldval' was declared here
 1652 |  int oldval, ret;
      |      ^~~~~~

introduced by commit a08971e9488d ("futex: arch_futex_atomic_op_inuser()
calling conventions change").

While that change should not make any difference it confuses GCC which
fails to work out that oldval is not referenced when the return value is
not zero.

GCC fails to properly analyze arch_futex_atomic_op_inuser(). It's not the
early return, the issue is with the assembly macros. GCC fails to detect
that those either set 'ret' to 0 and set oldval or set 'ret' to -EFAULT
which makes oldval uninteresting. The store to the callsite supplied oldval
pointer is conditional on ret == 0.

The straight forward way to solve this is to make the store unconditional.

Aside of addressing the build warning this makes sense anyway because it
removes the conditional from the fastpath. In the error case the stored
value is uninteresting and the extra store does not matter at all.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/87pncao2ph.fsf@nanos.tec.linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/futex.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/futex.h b/arch/arm/include/asm/futex.h
index cc414382dab4b..561b2ba6bc284 100644
--- a/arch/arm/include/asm/futex.h
+++ b/arch/arm/include/asm/futex.h
@@ -162,8 +162,13 @@ arch_futex_atomic_op_inuser(int op, int oparg, int *oval, u32 __user *uaddr)
 	preempt_enable();
 #endif
 
-	if (!ret)
-		*oval = oldval;
+	/*
+	 * Store unconditionally. If ret != 0 the extra store is the least
+	 * of the worries but GCC cannot figure out that __futex_atomic_op()
+	 * is either setting ret to -EFAULT or storing the old value in
+	 * oldval which results in a uninitialized warning at the call site.
+	 */
+	*oval = oldval;
 
 	return ret;
 }
-- 
2.20.1

