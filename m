Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFE437CD99
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236059AbhELQ4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:56:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244007AbhELQmX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89B3B61C61;
        Wed, 12 May 2021 16:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835759;
        bh=PppjAvt2kgl8gqajCHltu/Xueb8WYqP8cCfLevIWR8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u/ed7DNCsFJoNPZrzu+DHQHNOLzLGC0diMSuONSP8CsMRGxdf5nv9r5+WyN9BM6pf
         irN25p35TCVghOTwy5W6Ujd7EEu7HOgl5QiRLSqeEDj5W+Xw3oTQhNE1XN0dyv8ZUZ
         U+bDWL27aI1eKUf1hP8SozDSKvAQ7vGCGocHkOy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 473/677] powerpc/64s: Fix hash fault to use TRAP accessor
Date:   Wed, 12 May 2021 16:48:39 +0200
Message-Id: <20210512144853.071953456@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 1479e3d3b7559133b0a107772b5841e9c2cad450 ]

Hash faults use the trap vector to decide whether this is an
instruction or data fault. This should use the TRAP accessor
rather than open access regs->trap.

This won't cause a problem at the moment because 64s only uses
trap flags for system call interrupts (the norestart flag), but
that could change if any other trap flags get used in future.

Fixes: a4922f5442e7e ("powerpc/64s: move the hash fault handling logic to C")
Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210316105205.407767-1-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/book3s64/hash_utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/hash_utils.c b/arch/powerpc/mm/book3s64/hash_utils.c
index 581b20a2feaf..7719995323c3 100644
--- a/arch/powerpc/mm/book3s64/hash_utils.c
+++ b/arch/powerpc/mm/book3s64/hash_utils.c
@@ -1545,10 +1545,10 @@ DEFINE_INTERRUPT_HANDLER_RET(__do_hash_fault)
 	if (user_mode(regs) || (region_id == USER_REGION_ID))
 		access &= ~_PAGE_PRIVILEGED;
 
-	if (regs->trap == 0x400)
+	if (TRAP(regs) == 0x400)
 		access |= _PAGE_EXEC;
 
-	err = hash_page_mm(mm, ea, access, regs->trap, flags);
+	err = hash_page_mm(mm, ea, access, TRAP(regs), flags);
 	if (unlikely(err < 0)) {
 		// failed to instert a hash PTE due to an hypervisor error
 		if (user_mode(regs)) {
-- 
2.30.2



