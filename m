Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A28E3A84F0
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbhFOPwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231664AbhFOPvt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:51:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A08661878;
        Tue, 15 Jun 2021 15:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772184;
        bh=+vzVZBTqzGrg9G1F91xSBepckO+sUx5Gbkr/R4+fHPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URIRDfGwD55uAV1HibreaE29Ofytt3RVQzc4OmPULmJ2XumsCMvXQsYVhv8U+4Wwe
         4r/mjvKFb0bc5Wfh9HIhub4//045T7U9iaxqgxcfkNS8F8W4wQ/Cr3UK+x5uBuOg6o
         n16a+ogWO5DHJCldhzBZh5lz1f9HWY38rytTZzQoRjCtcHEVjtNc+5zuGKYfDL6a1o
         55iNGP630MASHvwcIGjn04SMZFrZRJ/vC+YyKaaPAAoQIAgNFejWy+Kz5QFujx2Khh
         UOh/ttIKcYZOqGKIqR3mZsNv7ReTnPkaAh5Ssag4UQkT/LLUDO/vxdD1ok1msyX6UC
         LBRopOFSi8G/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 28/30] kvm: fix previous commit for 32-bit builds
Date:   Tue, 15 Jun 2021 11:49:05 -0400
Message-Id: <20210615154908.62388-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154908.62388-1-sashal@kernel.org>
References: <20210615154908.62388-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 4422829e8053068e0225e4d0ef42dc41ea7c9ef5 ]

array_index_nospec does not work for uint64_t on 32-bit builds.
However, the size of a memory slot must be less than 20 bits wide
on those system, since the memory slot must fit in the user
address space.  So just store it in an unsigned long.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kvm_host.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ecab72456c10..c66c702a4f07 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1110,8 +1110,8 @@ __gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
 	 * table walks, do not let the processor speculate loads outside
 	 * the guest's registered memslots.
 	 */
-	unsigned long offset = array_index_nospec(gfn - slot->base_gfn,
-						  slot->npages);
+	unsigned long offset = gfn - slot->base_gfn;
+	offset = array_index_nospec(offset, slot->npages);
 	return slot->userspace_addr + offset * PAGE_SIZE;
 }
 
-- 
2.30.2

