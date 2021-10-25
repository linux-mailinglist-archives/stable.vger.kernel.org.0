Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A82F43A4D9
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 22:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbhJYUlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 16:41:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232797AbhJYUlA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 16:41:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35A4760EFF;
        Mon, 25 Oct 2021 20:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635194317;
        bh=Fw2945ObmmQqTpKsFlO97oR83SK8bDrh7xI24nCeQ3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tXTlLrdlkZho3gsKExs3yTKbN8l4yY/H3kqECyHmYY2QxYaEYLeFpiFli9PvUgbps
         X125HlOdqN5g+LRfRwVoKmloxhOrmaCgbSQw0spIadKCNEYvpRdur762bD04Z8kLyT
         7luQoZXDVyKsFFr5di3L6b14WsPnSrBvRVisMU3J1K8kWAKTuA3qaQrVbhkBdMtmuO
         A4GEEplDZt2iN+pSrtYmtxuOWRiskCUFlpwc4ZTqPJcFAXEvrrxHhEg7979niKQPzu
         WelAurAGi2wjuE19rrqz9xrsuMRRT8DdHI5rEr8Kh7mnKLyf9o6kioWMGjByZXjV+o
         6TLmcrKPFjO7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, huaitong.han@intel.com,
        guangrong.xiao@linux.intel.com, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.14 5/5] KVM: MMU: Reset mmu->pkru_mask to avoid stale data
Date:   Mon, 25 Oct 2021 16:38:27 -0400
Message-Id: <20211025203828.1404503-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025203828.1404503-1-sashal@kernel.org>
References: <20211025203828.1404503-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chenyi Qiang <chenyi.qiang@intel.com>

[ Upstream commit a3ca5281bb771d8103ea16f0a6a8a5df9a7fb4f3 ]

When updating mmu->pkru_mask, the value can only be added but it isn't
reset in advance. This will make mmu->pkru_mask keep the stale data.
Fix this issue.

Fixes: 2d344105f57c ("KVM, pkeys: introduce pkru_mask to cache conditions")
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Message-Id: <20211021071022.1140-1-chenyi.qiang@intel.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c268fb59f779..6719a8041f59 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4465,10 +4465,10 @@ static void update_pkru_bitmask(struct kvm_mmu *mmu)
 	unsigned bit;
 	bool wp;
 
-	if (!is_cr4_pke(mmu)) {
-		mmu->pkru_mask = 0;
+	mmu->pkru_mask = 0;
+
+	if (!is_cr4_pke(mmu))
 		return;
-	}
 
 	wp = is_cr0_wp(mmu);
 
-- 
2.33.0

