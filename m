Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6030FA593
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbfKMBw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:52:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:41278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728290AbfKMBw2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:52:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C916204EC;
        Wed, 13 Nov 2019 01:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609948;
        bh=Ycvnrnc+r8e976pY0C2jgMR3cLTmLBzx60oilPkByKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z2YH+04GTqOAR+f4BxhDUkXGeQlLsC9mgbt+eOkYBlyeEPhNy+6ek8hA8LLDidzyh
         BvmWe7qEo6XQf5gBEkNuARqt7JfDpAWWzJ4IwIoKwaIBSNTEy/iiECoGIUl2AeRUJX
         4cc9zO9Oh8N/DEEg5CK1g76KeMn5TdLfYGrgx53U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 085/209] powerpc/64s/radix: Explicitly flush ERAT with local LPID invalidation
Date:   Tue, 12 Nov 2019 20:48:21 -0500
Message-Id: <20191113015025.9685-85-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 053c5a753e951c5dd1729af2cf4d8107f2e6e09b ]

Local radix TLB flush operations that operate on congruence classes
have explicit ERAT flushes for POWER9. The process scoped LPID flush
did not have a flush, so add it.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/tlb-radix.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/mm/tlb-radix.c b/arch/powerpc/mm/tlb-radix.c
index 0cddae4263f96..21441ff17b92b 100644
--- a/arch/powerpc/mm/tlb-radix.c
+++ b/arch/powerpc/mm/tlb-radix.c
@@ -366,6 +366,7 @@ static inline void _tlbiel_lpid_guest(unsigned long lpid, unsigned long ric)
 		__tlbiel_lpid_guest(lpid, set, RIC_FLUSH_TLB);
 
 	asm volatile("ptesync": : :"memory");
+	asm volatile(PPC_INVALIDATE_ERAT : : :"memory");
 }
 
 
-- 
2.20.1

