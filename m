Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E45499404
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388158AbiAXUiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:38:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37054 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356404AbiAXUbq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:31:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93C13B8122A;
        Mon, 24 Jan 2022 20:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C436BC340E7;
        Mon, 24 Jan 2022 20:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056303;
        bh=crMXqvSs9XeCYRWN5QFY6tsNKDUACgMNtu1LADo50Es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0iUzWyDNlv+Ccik4JL7HB6MoK+EO08jzz8GWwra6A88wwkLtEqdB9Rls2cH4INqQx
         /lHvHGLLQ9aJVg47z/2YtfSnn9c9Jm2inLEF1zNe+1iQF8D02tal/B1OcNYm8VF9Ke
         nqvYTF7TqcmfihX8gq39LxTYLqiLuha+YgzF4ZfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sachin Sant <sachinp@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 432/846] powerpc/64s: Mask NIP before checking against SRR0
Date:   Mon, 24 Jan 2022 19:39:09 +0100
Message-Id: <20220124184115.892084443@linuxfoundation.org>
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



