Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBA5328518
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235683AbhCAQsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:48:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:46810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234893AbhCAQlW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:41:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29F3864EE0;
        Mon,  1 Mar 2021 16:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616132;
        bh=eT39xaQOiQE9iX/3+l/9yrjkQleI1avlPT9OBeh+DR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rni3vv5OQU/j1j+U8zNyznd/XaaNKrh6SbiOpnD8x5vSy+5Pcl+9knr6hUC5IiST1
         W0WGZKYBtmYPWB1QAevA1c71YCoUbRDxqsbI+lYKB2n8SShA9K+4rNdmYew2uM0piu
         QubL9S2LV2KQUB6S2MvD1A78I6AJcm3LGZhqDdEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Golovin <dima@golovin.in>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 046/176] MIPS: lantiq: Explicitly compare LTQ_EBU_PCC_ISTAT against 0
Date:   Mon,  1 Mar 2021 17:11:59 +0100
Message-Id: <20210301161023.247559607@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
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
index 37caeadb2964c..0476d7e97a03f 100644
--- a/arch/mips/lantiq/irq.c
+++ b/arch/mips/lantiq/irq.c
@@ -244,7 +244,7 @@ static void ltq_hw_irq_handler(struct irq_desc *desc)
 	generic_handle_irq(irq_linear_revmap(ltq_domain, hwirq));
 
 	/* if this is a EBU irq, we need to ack it or get a deadlock */
-	if ((irq == LTQ_ICU_EBU_IRQ) && (module == 0) && LTQ_EBU_PCC_ISTAT)
+	if (irq == LTQ_ICU_EBU_IRQ && !module && LTQ_EBU_PCC_ISTAT != 0)
 		ltq_ebu_w32(ltq_ebu_r32(LTQ_EBU_PCC_ISTAT) | 0x10,
 			LTQ_EBU_PCC_ISTAT);
 }
-- 
2.27.0



