Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56769EEF0D
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388676AbfKDWSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:18:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:59360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389012AbfKDWBS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:01:18 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFDDB21744;
        Mon,  4 Nov 2019 22:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904877;
        bh=yyDxAlgn41+7DL22CfifjWjYAq8KV40/xCcwkHyz6u8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mVUfgZ5BQfwDc4db/TJNUNfvb24oIDMLbqkhimBglnNs9SECoNN+GbCq6XEXQK73o
         wy2COsBe2N6Hbzb11+5UbY3kkyTeywQ6LJUtSkQ2QLKjOFX3VS0Y8SjlHSlhhtlbaT
         sdoLxatrrawL6K6XnBfjECedy0a/dL7OjJzWylwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, afzal mohammed <afzal.mohd.ma@gmail.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 102/149] ARM: 8914/1: NOMMU: Fix exc_ret for XIP
Date:   Mon,  4 Nov 2019 22:44:55 +0100
Message-Id: <20191104212143.637154910@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Murzin <vladimir.murzin@arm.com>

[ Upstream commit 4c0742f65b4ee466546fd24b71b56516cacd4613 ]

It was reported that 72cd4064fcca "NOMMU: Toggle only bits in
EXC_RETURN we are really care of" breaks NOMMU+XIP combination.
It happens because saved EXC_RETURN gets overwritten when data
section is relocated.

The fix is to propagate EXC_RETURN via register and let relocation
code to commit that value into memory.

Fixes: 72cd4064fcca ("ARM: 8830/1: NOMMU: Toggle only bits in EXC_RETURN we are really care of")
Reported-by: afzal mohammed <afzal.mohd.ma@gmail.com>
Tested-by: afzal mohammed <afzal.mohd.ma@gmail.com>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/head-common.S | 5 +++--
 arch/arm/kernel/head-nommu.S  | 2 ++
 arch/arm/mm/proc-v7m.S        | 5 ++---
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/head-common.S b/arch/arm/kernel/head-common.S
index 997b02302c314..9328f2010bc19 100644
--- a/arch/arm/kernel/head-common.S
+++ b/arch/arm/kernel/head-common.S
@@ -72,7 +72,7 @@ ENDPROC(__vet_atags)
  * The following fragment of code is executed with the MMU on in MMU mode,
  * and uses absolute addresses; this is not position independent.
  *
- *  r0  = cp#15 control register
+ *  r0  = cp#15 control register (exc_ret for M-class)
  *  r1  = machine ID
  *  r2  = atags/dtb pointer
  *  r9  = processor ID
@@ -141,7 +141,8 @@ __mmap_switched_data:
 #ifdef CONFIG_CPU_CP15
 	.long	cr_alignment			@ r3
 #else
-	.long	0				@ r3
+M_CLASS(.long	exc_ret)			@ r3
+AR_CLASS(.long	0)				@ r3
 #endif
 	.size	__mmap_switched_data, . - __mmap_switched_data
 
diff --git a/arch/arm/kernel/head-nommu.S b/arch/arm/kernel/head-nommu.S
index cab89479d15ef..326a97aa3ea0c 100644
--- a/arch/arm/kernel/head-nommu.S
+++ b/arch/arm/kernel/head-nommu.S
@@ -205,6 +205,8 @@ M_CLASS(streq	r3, [r12, #PMSAv8_MAIR1])
 	bic	r0, r0, #V7M_SCB_CCR_IC
 #endif
 	str	r0, [r12, V7M_SCB_CCR]
+	/* Pass exc_ret to __mmap_switched */
+	mov	r0, r10
 #endif /* CONFIG_CPU_CP15 elif CONFIG_CPU_V7M */
 	ret	lr
 ENDPROC(__after_proc_init)
diff --git a/arch/arm/mm/proc-v7m.S b/arch/arm/mm/proc-v7m.S
index 92e84181933ad..59d82864c134b 100644
--- a/arch/arm/mm/proc-v7m.S
+++ b/arch/arm/mm/proc-v7m.S
@@ -139,9 +139,8 @@ __v7m_setup_cont:
 	cpsie	i
 	svc	#0
 1:	cpsid	i
-	ldr	r0, =exc_ret
-	orr	lr, lr, #EXC_RET_THREADMODE_PROCESSSTACK
-	str	lr, [r0]
+	/* Calculate exc_ret */
+	orr	r10, lr, #EXC_RET_THREADMODE_PROCESSSTACK
 	ldmia	sp, {r0-r3, r12}
 	str	r5, [r12, #11 * 4]	@ restore the original SVC vector entry
 	mov	lr, r6			@ restore LR
-- 
2.20.1



