Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63D93A8529
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbhFOPxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:53:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232360AbhFOPwW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:52:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 248C261626;
        Tue, 15 Jun 2021 15:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772207;
        bh=MO+vQwJ9v1GfnISFz/5v/mfomNjPdT2yqw+DaD//utA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K7U4V4MD4HsSetLw1amDfXvnaYUORdAGRO4CFf3H78ng/0Z7VdlEcFZcfkRzA3GjY
         eYKN1fHhPD7/0EnsKHjVNGE+zSNJAmTooMzdQSSzCWbNDdK6LK7CSIgM3ib6ETkHNa
         LCZIFbngpkAcwOp9iBkajs6orGNag7qi3aGmsabteC1tKb5ZNYyr+860gMXnNOQx6Z
         lkqGCmD7YRT3Yg/6wsYtnjK8cmPBD5+ILI24C/TCgog48N4PUg2mmdpfP6Y0jFWLEo
         JrUD+ZKjboHMckPXR9GTOZnoR/jBc+KF7cXGjbgJP0jJFzTP5nd1j61D2zljLI5v+0
         0qyGfZFJED9RQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 14/15] kvm: fix previous commit for 32-bit builds
Date:   Tue, 15 Jun 2021 11:49:46 -0400
Message-Id: <20210615154948.62711-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154948.62711-1-sashal@kernel.org>
References: <20210615154948.62711-1-sashal@kernel.org>
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
index 6c29afb76070..a1ff6b76aa8c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1051,8 +1051,8 @@ __gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
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

