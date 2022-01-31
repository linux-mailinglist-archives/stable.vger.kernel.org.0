Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB564A44FA
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343585AbiAaLfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377026AbiAaLcw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:32:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E685CC0604D1;
        Mon, 31 Jan 2022 03:21:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B001B82A76;
        Mon, 31 Jan 2022 11:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A79C340EE;
        Mon, 31 Jan 2022 11:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628114;
        bh=rEqdq7v63HYoM1RUtMY3FTYSi4VVJnZarw6/dAiwbJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YnIlHT57CwZKxSPltqI1jMg7iZM5dWJ2M7fXF2bUAV2ItnCSgu3NdnR7OWiQXpJcJ
         wE0h+clllxtcf2Id9iJAAI+jEc7Ir5cV/Tt/2lQzlcsnCEOs0h4HKibndY3ZV8KImD
         du1izsQLtMbRfCFAWo/s0Yvv6svQUIdRCgTXcswE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 128/200] powerpc/64s: Mask SRR0 before checking against the masked NIP
Date:   Mon, 31 Jan 2022 11:56:31 +0100
Message-Id: <20220131105237.865731453@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit aee101d7b95a03078945681dd7f7ea5e4a1e7686 ]

Commit 314f6c23dd8d ("powerpc/64s: Mask NIP before checking against
SRR0") masked off the low 2 bits of the NIP value in the interrupt
stack frame in case they are non-zero and mis-compare against a SRR0
register value of a CPU which always reads back 0 from the 2 low bits
which are reserved.

This now causes the opposite problem that an implementation which does
implement those bits in SRR0 will mis-compare against the masked NIP
value in which they have been cleared. QEMU is one such implementation,
and this is allowed by the architecture.

This can be triggered by sigfuz by setting low bits of PT_NIP in the
signal context.

Fix this for now by masking the SRR0 bits as well. Cleaner is probably
to sanitise these values before putting them in registers or stack, but
this is the quick and backportable fix.

Fixes: 314f6c23dd8d ("powerpc/64s: Mask NIP before checking against SRR0")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220117134403.2995059-1-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/interrupt_64.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kernel/interrupt_64.S b/arch/powerpc/kernel/interrupt_64.S
index 4b1ff94e67eb4..4c6d1a8dcefed 100644
--- a/arch/powerpc/kernel/interrupt_64.S
+++ b/arch/powerpc/kernel/interrupt_64.S
@@ -30,6 +30,7 @@ COMPAT_SYS_CALL_TABLE:
 	.ifc \srr,srr
 	mfspr	r11,SPRN_SRR0
 	ld	r12,_NIP(r1)
+	clrrdi  r11,r11,2
 	clrrdi  r12,r12,2
 100:	tdne	r11,r12
 	EMIT_WARN_ENTRY 100b,__FILE__,__LINE__,(BUGFLAG_WARNING | BUGFLAG_ONCE)
@@ -40,6 +41,7 @@ COMPAT_SYS_CALL_TABLE:
 	.else
 	mfspr	r11,SPRN_HSRR0
 	ld	r12,_NIP(r1)
+	clrrdi  r11,r11,2
 	clrrdi  r12,r12,2
 100:	tdne	r11,r12
 	EMIT_WARN_ENTRY 100b,__FILE__,__LINE__,(BUGFLAG_WARNING | BUGFLAG_ONCE)
-- 
2.34.1



