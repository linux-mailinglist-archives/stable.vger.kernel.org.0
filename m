Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EE333BA80
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhCOOJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232823AbhCOODx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EC0964EE3;
        Mon, 15 Mar 2021 14:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817032;
        bh=h0X38WufXpodO7S6ZRiHR8VH9Ou1WWFstY9gyKBLm/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d1N8wMYu/kkQRT5XFV+40m5NHZ+l6BnellIDsUpVQJksSv2tOYZ9BL4rihkBDrDo2
         Fv4n80K/Fs1VFM4lqYxlw4iwS3oA/nNM44LmUgc5MKqyg1qNJMsBcK6w3D0j+G0+KE
         yHXlSIMnC0f5Jj9Ku5x8Pt7AD4rlrdox+tbR4tOk=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Axtens <dja@axtens.net>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 256/290] powerpc/64s/exception: Clean up a missed SRR specifier
Date:   Mon, 15 Mar 2021 14:55:49 +0100
Message-Id: <20210315135550.662085080@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
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
index 3cde2fbd74fc..9d3b468bd2d7 100644
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



