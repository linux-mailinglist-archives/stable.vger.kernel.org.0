Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08F72BA811
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbgKTLE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:04:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:51950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727940AbgKTLE0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:04:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98DC92236F;
        Fri, 20 Nov 2020 11:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870265;
        bh=yVP9HCp5Xi6g7SjY83SY5YsHLJNL3JHWYJ+JMcjpzw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mOz6rIiu6spW2LbfFdpFyDbysb1Qz2n0Plg0IE56UlxpezUbdlFXNu7OX1kd25HcJ
         cgL8rx8ine2QE0QhtVJd+ppzrDDe686Uzl9Soml3rCeolDb9DhpZEx72Ii3txff63S
         QLu7KeVGKIUdMTDGpVJEUwnuSCx5J4plFgc2LzZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, dja@axtens.net
Subject: [PATCH 4.9 02/16] powerpc/64s: move some exception handlers out of line
Date:   Fri, 20 Nov 2020 12:03:07 +0100
Message-Id: <20201120104539.835892188@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104539.706905067@linuxfoundation.org>
References: <20201120104539.706905067@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Axtens <dja@axtens.net>

(backport only)

We're about to grow the exception handlers, which will make a bunch of them
no longer fit within the space available. We move them out of line.

This is a fiddly and error-prone business, so in the interests of reviewability
I haven't merged this in with the addition of the entry flush.

Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/exceptions-64s.S |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -519,6 +519,10 @@ ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_TY
 EXC_REAL_BEGIN(data_access_slb, 0x380, 0x400)
 	SET_SCRATCH0(r13)
 	EXCEPTION_PROLOG_0(PACA_EXSLB)
+	b tramp_data_access_slb
+EXC_REAL_END(data_access_slb, 0x380, 0x400)
+
+TRAMP_REAL_BEGIN(tramp_data_access_slb)
 	EXCEPTION_PROLOG_1(PACA_EXSLB, KVMTEST_PR, 0x380)
 	std	r3,PACA_EXSLB+EX_R3(r13)
 	mfspr	r3,SPRN_DAR
@@ -537,7 +541,6 @@ EXC_REAL_BEGIN(data_access_slb, 0x380, 0
 	mtctr	r10
 	bctr
 #endif
-EXC_REAL_END(data_access_slb, 0x380, 0x400)
 
 EXC_VIRT_BEGIN(data_access_slb, 0x4380, 0x4400)
 	SET_SCRATCH0(r13)
@@ -587,6 +590,10 @@ ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_TY
 EXC_REAL_BEGIN(instruction_access_slb, 0x480, 0x500)
 	SET_SCRATCH0(r13)
 	EXCEPTION_PROLOG_0(PACA_EXSLB)
+	b tramp_instruction_access_slb
+EXC_REAL_END(instruction_access_slb, 0x480, 0x500)
+
+TRAMP_REAL_BEGIN(tramp_instruction_access_slb)
 	EXCEPTION_PROLOG_1(PACA_EXSLB, KVMTEST_PR, 0x480)
 	std	r3,PACA_EXSLB+EX_R3(r13)
 	mfspr	r3,SPRN_SRR0		/* SRR0 is faulting address */
@@ -600,7 +607,6 @@ EXC_REAL_BEGIN(instruction_access_slb, 0
 	mtctr	r10
 	bctr
 #endif
-EXC_REAL_END(instruction_access_slb, 0x480, 0x500)
 
 EXC_VIRT_BEGIN(instruction_access_slb, 0x4480, 0x4500)
 	SET_SCRATCH0(r13)


