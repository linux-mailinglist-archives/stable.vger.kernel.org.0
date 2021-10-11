Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1551242912B
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243476AbhJKOP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:15:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244280AbhJKONx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:13:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3490061164;
        Mon, 11 Oct 2021 14:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961075;
        bh=+r+a5Dn2X+NIxEfAYDVknaY59vrhDkNcoblzP+o/9ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t3AIa1VhxbueQTVTLqhDHQyttNerxG/GXKdhCd/DiwFPfUt+45u07XijiAwmHPP9Z
         Mx1po7bQT5E0E0FmszllvXfpPmTalmu1O5/CwnmCQkAMLpmPUQmo5QnLBOBA2t7eb1
         nIysLIvNDr3mpHCytv2rVQxfilRFAMKDTyc9XQHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stan Johnson <userm57@yahoo.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 142/151] powerpc/32s: Fix kuap_kernel_restore()
Date:   Mon, 11 Oct 2021 15:46:54 +0200
Message-Id: <20211011134522.402251226@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit d93f9e23744b7bf11a98b2ddb091d129482ae179 ]

At interrupt exit, kuap_kernel_restore() calls kuap_unlock() with the
value contained in regs->kuap. However, when regs->kuap contains
0xffffffff it means that KUAP was not unlocked so calling kuap_unlock()
is unrelevant and results in jeopardising the contents of kernel space
segment registers.

So check that regs->kuap doesn't contain KUAP_NONE before calling
kuap_unlock(). In the meantime it also means that if KUAP has not
been correcly locked back at interrupt exit, it must be locked
before continuing. This is done by checking the content of
current->thread.kuap which was returned by kuap_get_and_assert_locked()

Fixes: 16132529cee5 ("powerpc/32s: Rework Kernel Userspace Access Protection")
Reported-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/0d0c4d0f050a637052287c09ba521bad960a2790.1631715131.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/book3s/32/kup.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/powerpc/include/asm/book3s/32/kup.h b/arch/powerpc/include/asm/book3s/32/kup.h
index d4b145b279f6..9f38040f0641 100644
--- a/arch/powerpc/include/asm/book3s/32/kup.h
+++ b/arch/powerpc/include/asm/book3s/32/kup.h
@@ -136,6 +136,14 @@ static inline void kuap_kernel_restore(struct pt_regs *regs, unsigned long kuap)
 	if (kuap_is_disabled())
 		return;
 
+	if (unlikely(kuap != KUAP_NONE)) {
+		current->thread.kuap = KUAP_NONE;
+		kuap_lock(kuap, false);
+	}
+
+	if (likely(regs->kuap == KUAP_NONE))
+		return;
+
 	current->thread.kuap = regs->kuap;
 
 	kuap_unlock(regs->kuap, false);
-- 
2.33.0



