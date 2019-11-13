Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 642A0FA631
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfKMBux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:50:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:37930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727540AbfKMBuw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:50:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69F76222D4;
        Wed, 13 Nov 2019 01:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609852;
        bh=5MH6Ax/vtJQFiVkOpwSaJoxC1Gi53ZAWxPTk71j1TkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gRalSq6xDrOAOY9TTVmrh+LRoJeRmd/RDXpUKf9cFYXLKOyM4H1nK33nkcW/K24Pv
         EDXec48ZPqLe3+tlg06K0cBFzWcF76fTBEq+na11wfA+WNiEOqSB9GqNIECiZKjGag
         JRmaocdhQmc2OrD/X2eEthhU1006749opT3GSOEc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <cdall@kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvmarm@lists.cs.columbia.edu
Subject: [PATCH AUTOSEL 4.19 023/209] kvm: arm/arm64: Fix stage2_flush_memslot for 4 level page table
Date:   Tue, 12 Nov 2019 20:47:19 -0500
Message-Id: <20191113015025.9685-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit d2db7773ba864df6b4e19643dfc54838550d8049 ]

So far we have only supported 3 level page table with fixed IPA of
40bits, where PUD is folded. With 4 level page tables, we need
to check if the PUD entry is valid or not. Fix stage2_flush_memslot()
to do this check, before walking down the table.

Acked-by: Christoffer Dall <cdall@kernel.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/arm/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 1344557a70852..bf330b493c1e7 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -412,7 +412,8 @@ static void stage2_flush_memslot(struct kvm *kvm,
 	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
 	do {
 		next = stage2_pgd_addr_end(addr, end);
-		stage2_flush_puds(kvm, pgd, addr, next);
+		if (!stage2_pgd_none(*pgd))
+			stage2_flush_puds(kvm, pgd, addr, next);
 	} while (pgd++, addr = next, addr != end);
 }
 
-- 
2.20.1

