Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78FB469EE2
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358892AbhLFPok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390524AbhLFPm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC3DC0698C4;
        Mon,  6 Dec 2021 07:27:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68BD96132E;
        Mon,  6 Dec 2021 15:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DA1C34900;
        Mon,  6 Dec 2021 15:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804450;
        bh=F92RoRjc5c8LFesVoHxBgLj0x4NC3JyPefqptHqzUsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2vD/agkOrsJa9WhD8EnhMPRxsWjFfkC609zEv4MOUSbmdGW3y5mFEuhGjF+eY8o42
         y3ocIofxOa4cWG6g5gp03mNFyPyBQEHHB05G+TPtaNZel15l+otxNGYyq1hjK85bqd
         QHe9H/Oklfc77QwavpEMxNIFHIxXiOhIlGFzWows=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 152/207] KVM: x86/mmu: Skip tlb flush if it has been done in zap_gfn_range()
Date:   Mon,  6 Dec 2021 15:56:46 +0100
Message-Id: <20211206145615.505018008@linuxfoundation.org>
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

[ Upstream commit c7785d85b6c6cc9f3d0f1a8cab128f4062b30abb ]

If the parameter flush is set, zap_gfn_range() would flush remote tlb
when yield, then tlb flush is not needed outside. So use the return
value of zap_gfn_range() directly instead of OR on it in
kvm_unmap_gfn_range() and kvm_tdp_mmu_unmap_gfn_range().

Fixes: 3039bcc744980 ("KVM: Move x86's MMU notifier memslot walkers to generic code")
Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
Message-Id: <5e16546e228877a4d974f8c0e448a93d52c7a5a9.1637140154.git.houwenlong93@linux.alibaba.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c     | 2 +-
 arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9fb69546e21b8..9d04474b00272 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1592,7 +1592,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 		flush = kvm_handle_gfn_range(kvm, range, kvm_unmap_rmapp);
 
 	if (is_tdp_mmu_enabled(kvm))
-		flush |= kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
+		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
 
 	return flush;
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 838603a653b9a..aa75689a91b4c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1081,8 +1081,8 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 	struct kvm_mmu_page *root;
 
 	for_each_tdp_mmu_root(kvm, root, range->slot->as_id)
-		flush |= zap_gfn_range(kvm, root, range->start, range->end,
-				       range->may_block, flush, false);
+		flush = zap_gfn_range(kvm, root, range->start, range->end,
+				      range->may_block, flush, false);
 
 	return flush;
 }
-- 
2.33.0



