Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAED49A31C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2366142AbiAXXwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1844747AbiAXXKN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:10:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B7EC0A0295;
        Mon, 24 Jan 2022 13:18:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6120861496;
        Mon, 24 Jan 2022 21:18:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AABCC340E4;
        Mon, 24 Jan 2022 21:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059112;
        bh=crMXqvSs9XeCYRWN5QFY6tsNKDUACgMNtu1LADo50Es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qOVHfJO7ZoxKEmK83q/802lOpo6CchlCPZYByMkno9r4MYqc+5k/6VAHhSmcKW4zt
         fNNcu0gvof7n6L3JMbbJg5I3AbudCFM/A36frTqe7eCid06yT5wpbRAK2UuoQwuREg
         rXrXvhibwwAZZMylraiQpjevkMrUHZkHpYZ/Uch8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sachin Sant <sachinp@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0507/1039] powerpc/64s: Mask NIP before checking against SRR0
Date:   Mon, 24 Jan 2022 19:38:16 +0100
Message-Id: <20220124184142.325472093@linuxfoundation.org>
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

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 314f6c23dd8d417281eb9e8a516dd98036f2e7b3 ]

When CONFIG_PPC_RFI_SRR_DEBUG=y we check that NIP and SRR0 match when
returning from interrupts. This can trigger falsely if NIP has either of
its two low bits set via sigreturn or ptrace, while SRR0 has its low two
bits masked in hardware.

As a quick fix make sure to mask the low bits before doing the check.

Fixes: 59dc5bfca0cb ("powerpc/64s: avoid reloading (H)SRR registers if they are still valid")
Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Tested-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Link: https://lore.kernel.org/r/20211221135101.2085547-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/interrupt_64.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kernel/interrupt_64.S b/arch/powerpc/kernel/interrupt_64.S
index ec950b08a8dcc..894588b2381e5 100644
--- a/arch/powerpc/kernel/interrupt_64.S
+++ b/arch/powerpc/kernel/interrupt_64.S
@@ -30,6 +30,7 @@ COMPAT_SYS_CALL_TABLE:
 	.ifc \srr,srr
 	mfspr	r11,SPRN_SRR0
 	ld	r12,_NIP(r1)
+	clrrdi  r12,r12,2
 100:	tdne	r11,r12
 	EMIT_BUG_ENTRY 100b,__FILE__,__LINE__,(BUGFLAG_WARNING | BUGFLAG_ONCE)
 	mfspr	r11,SPRN_SRR1
@@ -39,6 +40,7 @@ COMPAT_SYS_CALL_TABLE:
 	.else
 	mfspr	r11,SPRN_HSRR0
 	ld	r12,_NIP(r1)
+	clrrdi  r12,r12,2
 100:	tdne	r11,r12
 	EMIT_BUG_ENTRY 100b,__FILE__,__LINE__,(BUGFLAG_WARNING | BUGFLAG_ONCE)
 	mfspr	r11,SPRN_HSRR1
-- 
2.34.1



