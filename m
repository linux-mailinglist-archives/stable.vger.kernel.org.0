Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D3727C615
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbgI2Llk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:41:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730605AbgI2Lk7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:40:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49B112065C;
        Tue, 29 Sep 2020 11:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379658;
        bh=Yrp0izKS9oOY/IRZAj6y24s8B44W/wunpiMFYqCWDHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCu19zB4Ejm5u/z4xhJbl0xk5GVTrm8Wf0C0vLX2hshouLf3IHEvhKIgu12nqLGNk
         TAqfdOaSldB5DGyxzLhvKjUenUYUGXu3H/NayPnW1/6UL3x3Q7DunPr6m3Myl+BiAY
         OFWnu0yuOTA7+A/CQc+lxIvj5K2N7DG3DU6vsUSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 262/388] powerpc/traps: Make unrecoverable NMIs die instead of panic
Date:   Tue, 29 Sep 2020 12:59:53 +0200
Message-Id: <20200929110023.153810221@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 265d6e588d87194c2fe2d6c240247f0264e0c19b ]

System Reset and Machine Check interrupts that are not recoverable due
to being nested or interrupting when RI=0 currently panic. This is not
necessary, and can often just kill the current context and recover.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
Link: https://lore.kernel.org/r/20200508043408.886394-16-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/traps.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 014ff0701f245..9432fc6af28a5 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -510,11 +510,11 @@ out:
 #ifdef CONFIG_PPC_BOOK3S_64
 	BUG_ON(get_paca()->in_nmi == 0);
 	if (get_paca()->in_nmi > 1)
-		nmi_panic(regs, "Unrecoverable nested System Reset");
+		die("Unrecoverable nested System Reset", regs, SIGABRT);
 #endif
 	/* Must die if the interrupt is not recoverable */
 	if (!(regs->msr & MSR_RI))
-		nmi_panic(regs, "Unrecoverable System Reset");
+		die("Unrecoverable System Reset", regs, SIGABRT);
 
 	if (saved_hsrrs) {
 		mtspr(SPRN_HSRR0, hsrr0);
@@ -858,7 +858,7 @@ void machine_check_exception(struct pt_regs *regs)
 
 	/* Must die if the interrupt is not recoverable */
 	if (!(regs->msr & MSR_RI))
-		nmi_panic(regs, "Unrecoverable Machine check");
+		die("Unrecoverable Machine check", regs, SIGBUS);
 
 	return;
 
-- 
2.25.1



