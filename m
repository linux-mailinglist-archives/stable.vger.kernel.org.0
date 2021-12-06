Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369F4469F10
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391328AbhLFPp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390526AbhLFPm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2AAC0698C5;
        Mon,  6 Dec 2021 07:27:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38E686132C;
        Mon,  6 Dec 2021 15:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C68C34901;
        Mon,  6 Dec 2021 15:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804453;
        bh=WGWU8nZsA+FoZdJ3LJaj93pnvdygE+IWrELk2dHaOkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xDoEXnXvLXDCdOMFCkUAqgVQ/sDPRyt8H5QQikZqEmYGRJHTBHT18fG3NCQiK34Wg
         7LKbsnmlltldPFIbvIiAotkEJn5nh/zbHf6YW6f4EkFwd3xC1wGFoMAssr13epv7Z/
         7bmHyYJ8gTqQzZYstgIfhhWtiPxmt/mha8sX3+f0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 153/207] KVM: x86/mmu: Pass parameter flush as false in kvm_tdp_mmu_zap_collapsible_sptes()
Date:   Mon,  6 Dec 2021 15:56:47 +0100
Message-Id: <20211206145615.543680231@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Wenlong <houwenlong93@linux.alibaba.com>

[ Upstream commit 8ed716ca7dc91f058be0ba644a3048667a20db13 ]

Since tlb flush has been done for legacy MMU before
kvm_tdp_mmu_zap_collapsible_sptes(), so the parameter flush
should be false for kvm_tdp_mmu_zap_collapsible_sptes().

Fixes: e2209710ccc5d ("KVM: x86/mmu: Skip rmap operations if rmaps not allocated")
Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
Message-Id: <21453a1d2533afb6e59fb6c729af89e771ff2e76.1637140154.git.houwenlong93@linux.alibaba.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9d04474b00272..c9b1d63d3cfba 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5855,7 +5855,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *slot)
 {
-	bool flush = false;
+	bool flush;
 
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
@@ -5867,7 +5867,7 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
-		flush = kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot, flush);
+		flush = kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot, false);
 		if (flush)
 			kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
 		read_unlock(&kvm->mmu_lock);
-- 
2.33.0



