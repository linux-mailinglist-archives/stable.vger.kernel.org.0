Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC4C3A8554
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbhFOPy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:54:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232489AbhFOPw6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:52:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B2256162B;
        Tue, 15 Jun 2021 15:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772225;
        bh=YvBHBKs97ZaS21XtF6yrBflrIDnrgDYzuSbHnMsY4cU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=enLiOjN6ee/nh31L58HUSy57TcXKZ5ACar+W8VxCfHurAuPA049avO9p4j25LMXG7
         DZZuXR8VPPD/zRlKo8dSP8HUqJzPtvzEb/EieBPW0Jut7wKXBp462TNPw/NfL4oRaq
         57/LAq+lLMZnEDJuK4SG62E3VyK1KbMDrqdeFvDDeuhjrkbiz9RlgLizEHCcWYHGTb
         FhK5mI6rB1HXKCZzrq17u+cTklYN0AOprm3KyfZNCUPcS7OrMM0SC7XpIUjxlKQaTQ
         haotBbcVL4E5Hjj0OH5kIZnGo4+SSZ0lKvp9lDTtwFjGTMWUPIiszXgx/LoJtDyjN/
         DuzmxAtW51+Yg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 11/12] kvm: fix previous commit for 32-bit builds
Date:   Tue, 15 Jun 2021 11:50:08 -0400
Message-Id: <20210615155009.62894-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615155009.62894-1-sashal@kernel.org>
References: <20210615155009.62894-1-sashal@kernel.org>
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
index eb758bbdb4f6..8dd4ebb58e97 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1023,8 +1023,8 @@ __gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
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

