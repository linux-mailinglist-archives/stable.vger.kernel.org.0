Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C7D35403B
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240748AbhDEJQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:16:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240727AbhDEJQc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:16:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA6EE61002;
        Mon,  5 Apr 2021 09:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614186;
        bh=YcM6X6zi+9NAqpzqj6zo5m8GwUwxSQ3FGRs0iGiiBxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQkuMDn6c/GBpP4gXtSWe1wGvmWaWaAFhL8zA9H0xU17HHEocm8I/WRaI7NAdCA1Y
         ElzZTrdFLTayqAVxY2K45BaZlAKk0vY5Q5LRtRzyhhm3DgbacGCKV2Rh/RaCvhDUKV
         +saZ6KbWfmamMjlkO7vJ8Te8NiAhKdZV1t+0MECU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 116/152] KVM: x86/mmu: Fix braces in kvm_recover_nx_lpages
Date:   Mon,  5 Apr 2021 10:54:25 +0200
Message-Id: <20210405085038.002729596@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

[ Upstream commit 8d1a182ea791f0111b0258c8f3eb8d77af0a8386 ]

No functional change intended.

Fixes: 29cf0f5007a2 ("kvm: x86/mmu: NX largepage recovery for TDP MMU")
Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20210202185734.1680553-10-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ed861245ecf0..5771102a840c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6005,10 +6005,10 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 				      struct kvm_mmu_page,
 				      lpage_disallowed_link);
 		WARN_ON_ONCE(!sp->lpage_disallowed);
-		if (sp->tdp_mmu_page)
+		if (sp->tdp_mmu_page) {
 			kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn,
 				sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level));
-		else {
+		} else {
 			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 			WARN_ON_ONCE(sp->lpage_disallowed);
 		}
-- 
2.30.1



