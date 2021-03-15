Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5361233BA6F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbhCOOJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49843 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232820AbhCOODl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1F5464E83;
        Mon, 15 Mar 2021 14:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817020;
        bh=lp7t4PAGlGJxwaLGTr21In+LijphDBOdYAJ98nN3adY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qsp+/YR0gC3xNLCIdiPs4Tsf5r9VVreaYMXJY6e5M5Pzjn/8+dCfcs7PKOTHaVXhe
         xfz8PVLFLJtJ4sxQZSDm8t8IY5PJAB1vCdyLoye7PC+Dcpp6RemcXI+ttuTq8NGuDO
         IyGhx2XL/90lIzW5km6EYCrWHb9hdM9t9m/zxHOg=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Axtens <dja@axtens.net>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 263/306] powerpc/64s/exception: Clean up a missed SRR specifier
Date:   Mon, 15 Mar 2021 14:55:26 +0100
Message-Id: <20210315135516.533659446@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Daniel Axtens <dja@axtens.net>

[ Upstream commit c080a173301ffc62cb6c76308c803c7fee05517a ]

Nick's patch cleaning up the SRR specifiers in exception-64s.S missed
a single instance of EXC_HV_OR_STD. Clean that up.

Caught by clang's integrated assembler.

Fixes: 3f7fbd97d07d ("powerpc/64s/exception: Clean up SRR specifiers")
Signed-off-by: Daniel Axtens <dja@axtens.net>
Acked-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210225031006.1204774-2-dja@axtens.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/exceptions-64s.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 6e53f7638737..de988770a7e4 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -470,7 +470,7 @@ DEFINE_FIXED_SYMBOL(\name\()_common_real)
 
 	ld	r10,PACAKMSR(r13)	/* get MSR value for kernel */
 	/* MSR[RI] is clear iff using SRR regs */
-	.if IHSRR == EXC_HV_OR_STD
+	.if IHSRR_IF_HVMODE
 	BEGIN_FTR_SECTION
 	xori	r10,r10,MSR_RI
 	END_FTR_SECTION_IFCLR(CPU_FTR_HVMODE)
-- 
2.30.1



