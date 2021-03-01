Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B190C32847A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbhCAQgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:36:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:36936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231697AbhCAQaI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:30:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D87564F14;
        Mon,  1 Mar 2021 16:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615823;
        bh=7fkjkJhQY5EGun8BlWEPT6Z64hnJsovML4CUGpHBZYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t7C47TSdov46sm6lwG3OawD/0AqGYOwQQsmJF6SzHFzoLU7BZfeu4ll1ALF/oS8vl
         JNUpkDOfnv7PndMNyrodPBuvuEOpLPgvv4ab9Cdm4KihqrF3ARaeqzg6CEXzEQQFLo
         UjKJr086lTgLlTenUH76cW89hlBTMvStrn1s3U3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Golovin <dima@golovin.in>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 033/134] MIPS: lantiq: Explicitly compare LTQ_EBU_PCC_ISTAT against 0
Date:   Mon,  1 Mar 2021 17:12:14 +0100
Message-Id: <20210301161015.208718250@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
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
index 7c6f75c2aa4df..e64f678ca12c8 100644
--- a/arch/mips/lantiq/irq.c
+++ b/arch/mips/lantiq/irq.c
@@ -245,7 +245,7 @@ static void ltq_hw_irqdispatch(int module)
 	do_IRQ((int)irq + MIPS_CPU_IRQ_CASCADE + (INT_NUM_IM_OFFSET * module));
 
 	/* if this is a EBU irq, we need to ack it or get a deadlock */
-	if ((irq == LTQ_ICU_EBU_IRQ) && (module == 0) && LTQ_EBU_PCC_ISTAT)
+	if (irq == LTQ_ICU_EBU_IRQ && !module && LTQ_EBU_PCC_ISTAT != 0)
 		ltq_ebu_w32(ltq_ebu_r32(LTQ_EBU_PCC_ISTAT) | 0x10,
 			LTQ_EBU_PCC_ISTAT);
 }
-- 
2.27.0



