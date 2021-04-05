Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3997353F27
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239382AbhDEJKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:10:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238486AbhDEJKE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:10:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1CF8613AF;
        Mon,  5 Apr 2021 09:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613796;
        bh=7sosVSFsnIOZ5vDQXTiruRRzJHhz0n9SsU5X1BpEw6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R8Mo32boVTUHfom+q+irpAdsiS6YheyaqXb69gmhq7u97rzZ/VbKYxTmDk8lgIMfr
         8uuO3+gNjtrdmvDh4uWFVreGd2hCHv+5FGD3X/YdOZFswY+2Z7akyAYXUO2sXreSHE
         qh/v3ThHP1kUzmQwivpRkfWzTr+93NqiQbDEArS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/126] KVM: x86/mmu: Fix braces in kvm_recover_nx_lpages
Date:   Mon,  5 Apr 2021 10:54:16 +0200
Message-Id: <20210405085034.164188708@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
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
index dacbd13d32c6..0f45ad05f895 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5992,10 +5992,10 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
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



