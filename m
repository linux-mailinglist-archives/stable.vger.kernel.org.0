Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4346145C50A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347432AbhKXNyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:54:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:42970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354651AbhKXNwq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:52:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 367FE61A6F;
        Wed, 24 Nov 2021 13:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759078;
        bh=eKXlbd2Id4vgxya1/9v96wWMA8DhmUWWQS4UlHwGZ/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MIUs3qWbCIGdfTmQJZHJe03mODfVlldetuKnlcbcXJpm0M5sSrLdHz5s5pjEYgmx+
         bTpTB33PGwf12VB/PJLFtJpuSMgGvTCghQFRws+ubmHBozkMEIpcixu9VusFZ79V/N
         Yeer41lJsHsuiHS9SnQ5flLGc9simT81eZu88S/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Perret <qperret@google.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/279] KVM: arm64: Fix host stage-2 finalization
Date:   Wed, 24 Nov 2021 12:56:20 +0100
Message-Id: <20211124115721.999821795@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Perret <qperret@google.com>

[ Upstream commit 50a8d3315960c74095c59e204db44abd937d4b5d ]

We currently walk the hypervisor stage-1 page-table towards the end of
hyp init in nVHE protected mode and adjust the host page ownership
attributes in its stage-2 in order to get a consistent state from both
point of views. The walk is done on the entire hyp VA space, and expects
to only ever find page-level mappings. While this expectation is
reasonable in the half of hyp VA space that maps memory with a fixed
offset (see the loop in pkvm_create_mappings_locked()), it can be
incorrect in the other half where nothing prevents the usage of block
mappings. For instance, on systems where memory is physically aligned at
an address that happens to maps to a PMD aligned VA in the hyp_vmemmap,
kvm_pgtable_hyp_map() will install block mappings when backing the
hyp_vmemmap, which will later cause finalize_host_mappings() to fail.
Furthermore, it should be noted that all pages backing the hyp_vmemmap
are also mapped in the 'fixed offset range' of the hypervisor, which
implies that finalize_host_mappings() will walk both aliases and update
the host stage-2 attributes twice. The order in which this happens is
unpredictable, though, since the hyp VA layout is highly dependent on
the position of the idmap page, hence resulting in a fragile mess at
best.

In order to fix all of this, let's restrict the finalization walk to
only cover memory regions in the 'fixed-offset range' of the hyp VA
space and nothing else. This not only fixes a correctness issue, but
will also result in a slighlty faster hyp initialization overall.

Fixes: 2c50166c62ba ("KVM: arm64: Mark host bss and rodata section as shared")
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211108154636.393384-1-qperret@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 57c27846320f4..58ad9c5ba3112 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -177,7 +177,7 @@ static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
 
 	phys = kvm_pte_to_phys(pte);
 	if (!addr_is_memory(phys))
-		return 0;
+		return -EINVAL;
 
 	/*
 	 * Adjust the host stage-2 mappings to match the ownership attributes
@@ -206,8 +206,18 @@ static int finalize_host_mappings(void)
 		.cb	= finalize_host_mappings_walker,
 		.flags	= KVM_PGTABLE_WALK_LEAF,
 	};
+	int i, ret;
+
+	for (i = 0; i < hyp_memblock_nr; i++) {
+		struct memblock_region *reg = &hyp_memory[i];
+		u64 start = (u64)hyp_phys_to_virt(reg->base);
+
+		ret = kvm_pgtable_walk(&pkvm_pgtable, start, reg->size, &walker);
+		if (ret)
+			return ret;
+	}
 
-	return kvm_pgtable_walk(&pkvm_pgtable, 0, BIT(pkvm_pgtable.ia_bits), &walker);
+	return 0;
 }
 
 void __noreturn __pkvm_init_finalise(void)
-- 
2.33.0



