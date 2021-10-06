Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30EDD423F4D
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 15:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239107AbhJFNch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 09:32:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238818AbhJFNcU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 09:32:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CF33611B0;
        Wed,  6 Oct 2021 13:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633527027;
        bh=QoqPlKb+8kwKBss6R/aDErIHG6AbYJdoLskd/FTD5W4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PAQeYtgPWIUWA5Ih7VIPWCvn56wwnhdAmZC1vxj4MShel46jmu08eB+uss9kWMiKw
         FpV8Z6ttcWakGgDl4R3xuy1e+fKX5tpKFUXzfIIcYKkHdzpmcSnU+8gcvlbOFE+nKL
         14/6l2hLi41PL1Dj7Xn8ioV9vWiJCWBiS5rHt8pNCKlv4Qp2J66ru/DONSiM0HoPXU
         pgPD151i8GyK+Dg3bbPZ/P81Huuf7VBrHJ90+U5oUC/mcuod98epBHZbDST9jtnVzC
         iMq3rs/xVWAtS2/3zHINiBBFmfZq8jd4Raw3YUTr7tTXKN6Yr9Uffx8N1U4hozuexW
         mf2A2qLXmAFQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.14 4/9] KVM: x86: reset pdptrs_from_userspace when exiting smm
Date:   Wed,  6 Oct 2021 09:30:16 -0400
Message-Id: <20211006133021.271905-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006133021.271905-1-sashal@kernel.org>
References: <20211006133021.271905-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit 37687c403a641f251cb2ef2e7830b88aa0647ba9 ]

When exiting SMM, pdpts are loaded again from the guest memory.

This fixes a theoretical bug, when exit from SMM triggers entry to the
nested guest which re-uses some of the migration
code which uses this flag as a workaround for a legacy userspace.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20210913140954.165665-4-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b3f855d48f72..1e7d629bbf36 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7659,6 +7659,13 @@ static void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm)
 
 		/* Process a latched INIT or SMI, if any.  */
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
+
+		/*
+		 * Even if KVM_SET_SREGS2 loaded PDPTRs out of band,
+		 * on SMM exit we still need to reload them from
+		 * guest memory
+		 */
+		vcpu->arch.pdptrs_from_userspace = false;
 	}
 
 	kvm_mmu_reset_context(vcpu);
-- 
2.33.0

