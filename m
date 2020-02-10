Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF6B1578E9
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730470AbgBJNLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:11:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:36012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728760AbgBJMjE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:04 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6914524677;
        Mon, 10 Feb 2020 12:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338344;
        bh=Pu6DSw8pDun7zPWs4xnwPRYaxPCxr3pMAudG/QJFtUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M39cE0y5vuZN0vHK1AohaevwYnb1AvwNArZOxPcMNYxpOlrIoOpdrtlo7np++xymO
         ayekiomqLUKBMGTPxodUHQlFuopvSrbr7B2E9VkGfm9FD4+UDFj/fP/aVvVRbu4/iP
         mdThGPwXubgy5KONXJo52PbbuMoQD+NN1XLTIWgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 298/309] KVM: x86: fix overlap between SPTE_MMIO_MASK and generation
Date:   Mon, 10 Feb 2020 04:34:14 -0800
Message-Id: <20200210122435.460954117@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 56871d444bc4d7ea66708775e62e2e0926384dbc ]

The SPTE_MMIO_MASK overlaps with the bits used to track MMIO
generation number.  A high enough generation number would overwrite the
SPTE_SPECIAL_MASK region and cause the MMIO SPTE to be misinterpreted.

Likewise, setting bits 52 and 53 would also cause an incorrect generation
number to be read from the PTE, though this was partially mitigated by the
(useless if it weren't for the bug) removal of SPTE_SPECIAL_MASK from
the spte in get_mmio_spte_generation.  Drop that removal, and replace
it with a compile-time assertion.

Fixes: 6eeb4ef049e7 ("KVM: x86: assign two bits to track SPTE kinds")
Reported-by: Ben Gardon <bgardon@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d7aa34bb318a5..46070da9e08f8 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -418,22 +418,24 @@ static inline bool is_access_track_spte(u64 spte)
  * requires a full MMU zap).  The flag is instead explicitly queried when
  * checking for MMIO spte cache hits.
  */
-#define MMIO_SPTE_GEN_MASK		GENMASK_ULL(18, 0)
+#define MMIO_SPTE_GEN_MASK		GENMASK_ULL(17, 0)
 
 #define MMIO_SPTE_GEN_LOW_START		3
 #define MMIO_SPTE_GEN_LOW_END		11
 #define MMIO_SPTE_GEN_LOW_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
 						    MMIO_SPTE_GEN_LOW_START)
 
-#define MMIO_SPTE_GEN_HIGH_START	52
-#define MMIO_SPTE_GEN_HIGH_END		61
+#define MMIO_SPTE_GEN_HIGH_START	PT64_SECOND_AVAIL_BITS_SHIFT
+#define MMIO_SPTE_GEN_HIGH_END		62
 #define MMIO_SPTE_GEN_HIGH_MASK		GENMASK_ULL(MMIO_SPTE_GEN_HIGH_END, \
 						    MMIO_SPTE_GEN_HIGH_START)
+
 static u64 generation_mmio_spte_mask(u64 gen)
 {
 	u64 mask;
 
 	WARN_ON(gen & ~MMIO_SPTE_GEN_MASK);
+	BUILD_BUG_ON((MMIO_SPTE_GEN_HIGH_MASK | MMIO_SPTE_GEN_LOW_MASK) & SPTE_SPECIAL_MASK);
 
 	mask = (gen << MMIO_SPTE_GEN_LOW_START) & MMIO_SPTE_GEN_LOW_MASK;
 	mask |= (gen << MMIO_SPTE_GEN_HIGH_START) & MMIO_SPTE_GEN_HIGH_MASK;
@@ -444,8 +446,6 @@ static u64 get_mmio_spte_generation(u64 spte)
 {
 	u64 gen;
 
-	spte &= ~shadow_mmio_mask;
-
 	gen = (spte & MMIO_SPTE_GEN_LOW_MASK) >> MMIO_SPTE_GEN_LOW_START;
 	gen |= (spte & MMIO_SPTE_GEN_HIGH_MASK) >> MMIO_SPTE_GEN_HIGH_START;
 	return gen;
-- 
2.20.1



