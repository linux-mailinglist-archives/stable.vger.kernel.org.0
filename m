Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCE5353F24
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238915AbhDEJKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:10:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237885AbhDEJJ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:09:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2C3D61393;
        Mon,  5 Apr 2021 09:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613791;
        bh=cfMris8vDpaqtpyVFY6ATGCUw6OG4h5XS7YFeNG16YI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i0kecx+K8tZZCtJ6Dkb6dIbyEg6B/v4aieGFPI+2HqsYpcK3424O3uySUGRvtbyXZ
         ULoP+ALkJ4yYWHn0Py6/2GCl/BaLRA1Zsi06525TFpkv5+wiDDajngID0vLkCVr37c
         3nMQWEoLttSJkqslAum0NsZoOuKuMMsNaEI13jFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Feiner <pfeiner@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/126] KVM: x86/mmu: Add comment on __tdp_mmu_set_spte
Date:   Mon,  5 Apr 2021 10:54:14 +0200
Message-Id: <20210405085034.104001747@linuxfoundation.org>
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

[ Upstream commit fe43fa2f407b9d513f7bcf18142e14e1bf1508d6 ]

__tdp_mmu_set_spte is a very important function in the TDP MMU which
already accepts several arguments and will take more in future commits.
To offset this complexity, add a comment to the function describing each
of the arguemnts.

No functional change intended.

Reviewed-by: Peter Feiner <pfeiner@google.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20210202185734.1680553-3-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 34ef3e1a0f84..f88404033e0c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -395,6 +395,22 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 				      new_spte, level);
 }
 
+/*
+ * __tdp_mmu_set_spte - Set a TDP MMU SPTE and handle the associated bookkeeping
+ * @kvm: kvm instance
+ * @iter: a tdp_iter instance currently on the SPTE that should be set
+ * @new_spte: The value the SPTE should be set to
+ * @record_acc_track: Notify the MM subsystem of changes to the accessed state
+ *		      of the page. Should be set unless handling an MMU
+ *		      notifier for access tracking. Leaving record_acc_track
+ *		      unset in that case prevents page accesses from being
+ *		      double counted.
+ * @record_dirty_log: Record the page as dirty in the dirty bitmap if
+ *		      appropriate for the change being made. Should be set
+ *		      unless performing certain dirty logging operations.
+ *		      Leaving record_dirty_log unset in that case prevents page
+ *		      writes from being double counted.
+ */
 static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 				      u64 new_spte, bool record_acc_track,
 				      bool record_dirty_log)
-- 
2.30.1



