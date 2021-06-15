Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712D83A849C
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbhFOPvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:51:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231865AbhFOPvI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:51:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69039616E9;
        Tue, 15 Jun 2021 15:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772142;
        bh=bEDf5APDFTWSAJq5FzoOkp3OjHsysKIg7jWZtYI1oc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNcExk4522x/fN2kvPaghr8yf3UcqD5Nu5Qx1zYmfw/zSgoojXVZT9Y0qzSM99hc5
         LT1cBvnJ+F6tuZ095LTCIbTZmzf0beRMhkajtI8h8czOjqjDpCELapH+xtDDRQxXVy
         jVCYfEu7Ri6+cwwu3DUgijGK9YJIB9ZWxO8B0zHc7fIgVAUx2CgFCpN1fKzohlzUIN
         sUSr0BUvbLSON7ZqF24BljkaBtFEsdYAZT3KBENgIBFP4klgrbfyRPSgJg8z2alkTY
         iEAxsHRLGkQUdAz9kJmYtXF46Y/vm2BbOzLXiiHBDxyjWkVc460lHELNdf4PumEnka
         dT/7TWN4NtFFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 30/33] kvm: fix previous commit for 32-bit builds
Date:   Tue, 15 Jun 2021 11:48:21 -0400
Message-Id: <20210615154824.62044-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154824.62044-1-sashal@kernel.org>
References: <20210615154824.62044-1-sashal@kernel.org>
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
index 5520d3a97c2e..6e884bf58c0a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1124,8 +1124,8 @@ __gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
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

