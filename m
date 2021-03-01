Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE6732880F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234624AbhCARcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:32:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:48856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238410AbhCAR0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:26:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61BA765086;
        Mon,  1 Mar 2021 16:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617452;
        bh=izAZptalN6LNWJAzb4zUlLLNoj6fnzLnrr9XUbIy35Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d/Ee/mueaKrlXbtbPMuJr4e9PIZxEOCf14+10YViy3Jv62M+TAbiZ0puJFiQRSbw4
         NAClSNi1wnL95uGvaag/l7AyMn24xZzZLbNnuyVUeuN+FgycqirrVRFgdaqGg0YKuS
         covv1uY5zkuv6nK1tOm1us9w7+hXGLEclVca5l14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Golovin <dima@golovin.in>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/340] MIPS: lantiq: Explicitly compare LTQ_EBU_PCC_ISTAT against 0
Date:   Mon,  1 Mar 2021 17:10:23 +0100
Message-Id: <20210301161052.210264986@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit c6f2a9e17b9bef7677caddb1626c2402f3e9d2bd ]

When building xway_defconfig with clang:

arch/mips/lantiq/irq.c:305:48: error: use of logical '&&' with constant
operand [-Werror,-Wconstant-logical-operand]
        if ((irq == LTQ_ICU_EBU_IRQ) && (module == 0) && LTQ_EBU_PCC_ISTAT)
                                                      ^ ~~~~~~~~~~~~~~~~~
arch/mips/lantiq/irq.c:305:48: note: use '&' for a bitwise operation
        if ((irq == LTQ_ICU_EBU_IRQ) && (module == 0) && LTQ_EBU_PCC_ISTAT)
                                                      ^~
                                                      &
arch/mips/lantiq/irq.c:305:48: note: remove constant to silence this
warning
        if ((irq == LTQ_ICU_EBU_IRQ) && (module == 0) && LTQ_EBU_PCC_ISTAT)
                                                     ~^~~~~~~~~~~~~~~~~~~~
1 error generated.

Explicitly compare the constant LTQ_EBU_PCC_ISTAT against 0 to fix the
warning. Additionally, remove the unnecessary parentheses as this is a
simple conditional statement and shorthand '== 0' to '!'.

Fixes: 3645da0276ae ("OF: MIPS: lantiq: implement irq_domain support")
Link: https://github.com/ClangBuiltLinux/linux/issues/807
Reported-by: Dmitry Golovin <dima@golovin.in>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/lantiq/irq.c b/arch/mips/lantiq/irq.c
index 115b417dfb8e3..9fcc118312cb9 100644
--- a/arch/mips/lantiq/irq.c
+++ b/arch/mips/lantiq/irq.c
@@ -302,7 +302,7 @@ static void ltq_hw_irq_handler(struct irq_desc *desc)
 	generic_handle_irq(irq_linear_revmap(ltq_domain, hwirq));
 
 	/* if this is a EBU irq, we need to ack it or get a deadlock */
-	if ((irq == LTQ_ICU_EBU_IRQ) && (module == 0) && LTQ_EBU_PCC_ISTAT)
+	if (irq == LTQ_ICU_EBU_IRQ && !module && LTQ_EBU_PCC_ISTAT != 0)
 		ltq_ebu_w32(ltq_ebu_r32(LTQ_EBU_PCC_ISTAT) | 0x10,
 			LTQ_EBU_PCC_ISTAT);
 }
-- 
2.27.0



