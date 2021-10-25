Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D5B43A4D1
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 22:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbhJYUk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 16:40:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231264AbhJYUkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 16:40:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD76C60EB4;
        Mon, 25 Oct 2021 20:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635194310;
        bh=pvCgqoU5iIW5eGqixHfTahU0J0rZVbyMKjmQ9lz+ZlU=;
        h=From:To:Cc:Subject:Date:From;
        b=BMeA3VDky7FENzU7p4UsSp/z2OQDYvMBqEMX1aPiCMijOQJ26ffYG7sWfurzMxzyY
         7HNGyZCAbRLx4RYjex6wI00V9XKjphHXhPnW2YGnV093+VvZFEd9y1Gw26uquprts/
         2hwborgLhTIgrOSwajd96NP79M7BsXe3Fb0QpElya1MIC/ZZDm+eg4idYaKm2fHaiB
         QstFVAq5Gpp0dKFxjUZu/Ko5U1PhGEoQdbRLJiDcL52rq5IWDsfOS/sPqtgN77OeLT
         6GaZfPLTUYmi0nLIbuI3+DqtO5YbdMn2f+UMQvApeBV1kCM6no0vsoHV7ek7eRKkQ1
         HObhH01qEnmyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.14 1/5] KVM: X86: fix lazy allocation of rmaps
Date:   Mon, 25 Oct 2021 16:38:23 -0400
Message-Id: <20211025203828.1404503-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit fa13843d1565d4c5b3aeb9be3343b313416bef46 ]

If allocation of rmaps fails, but some of the pointers have already been written,
those pointers can be cleaned up when the memslot is freed, or even reused later
for another attempt at allocating the rmaps.  Therefore there is no need to
WARN, as done for example in memslot_rmap_alloc, but the allocation *must* be
skipped lest KVM will overwrite the previous pointer and will indeed leak memory.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4b0e866e9f08..60d9aa0ab389 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11341,7 +11341,8 @@ static int memslot_rmap_alloc(struct kvm_memory_slot *slot,
 		int lpages = gfn_to_index(slot->base_gfn + npages - 1,
 					  slot->base_gfn, level) + 1;
 
-		WARN_ON(slot->arch.rmap[i]);
+		if (slot->arch.rmap[i])
+			continue;
 
 		slot->arch.rmap[i] = kvcalloc(lpages, sz, GFP_KERNEL_ACCOUNT);
 		if (!slot->arch.rmap[i]) {
-- 
2.33.0

