Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A89E40E2B9
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241126AbhIPQlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:41:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243796AbhIPQjA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:39:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4365619FA;
        Thu, 16 Sep 2021 16:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809369;
        bh=YYBho95QdOM5VhV5o1hM07Vz0fnKXDen22OQtXq+tsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cIp1Db9XeObsArtr0KBsn+EsQbURXPEa6L7mtEm4fxso0Q//kkaN0Rx3fT7orn1Dw
         0JT0PQvfTnoIQGzyH2jciP4B4GYpzHbJhpyQ5aKHdOhgdaO9AonmRkINZQvN3wF8lj
         bQuIP201R6H6MN05meBZuzia/XV2UOvxkTKBiJqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 129/380] KVM: PPC: Fix clearing never mapped TCEs in realmode
Date:   Thu, 16 Sep 2021 17:58:06 +0200
Message-Id: <20210916155808.428855611@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit 1d78dfde33a02da1d816279c2e3452978b7abd39 ]

Since commit e1a1ef84cd07 ("KVM: PPC: Book3S: Allocate guest TCEs on
demand too"), pages for TCE tables for KVM guests are allocated only
when needed. This allows skipping any update when clearing TCEs. This
works mostly fine as TCE updates are handled when the MMU is enabled.
The realmode handlers fail with H_TOO_HARD when pages are not yet
allocated, except when clearing a TCE in which case KVM prints a warning
and proceeds to dereference a NULL pointer, which crashes the host OS.

This has not been caught so far as the change in commit e1a1ef84cd07 is
reasonably new, and POWER9 runs mostly radix which does not use realmode
handlers. With hash, the default TCE table is memset() by QEMU when the
machine is reset which triggers page faults and the KVM TCE device's
kvm_spapr_tce_fault() handles those with MMU on. And the huge DMA
windows are not cleared by VMs which instead successfully create a DMA
window big enough to map the VM memory 1:1 and then VMs just map
everything without clearing.

This started crashing now as commit 381ceda88c4c ("powerpc/pseries/iommu:
Make use of DDW for indirect mapping") added a mode when a dymanic DMA
window not big enough to map the VM memory 1:1 but it is used anyway,
and the VM now is the first (i.e. not QEMU) to clear a just created
table. Note that upstream QEMU needs to be modified to trigger the VM to
trigger the host OS crash.

This replaces WARN_ON_ONCE_RM() with a check and return, and adds
another warning if TCE is not being cleared.

Fixes: e1a1ef84cd07 ("KVM: PPC: Book3S: Allocate guest TCEs on demand too")
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210827040706.517652-1-aik@ozlabs.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_64_vio_hv.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index 083a4e037718..e5ba96c41f3f 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -173,10 +173,13 @@ static void kvmppc_rm_tce_put(struct kvmppc_spapr_tce_table *stt,
 	idx -= stt->offset;
 	page = stt->pages[idx / TCES_PER_PAGE];
 	/*
-	 * page must not be NULL in real mode,
-	 * kvmppc_rm_ioba_validate() must have taken care of this.
+	 * kvmppc_rm_ioba_validate() allows pages not be allocated if TCE is
+	 * being cleared, otherwise it returns H_TOO_HARD and we skip this.
 	 */
-	WARN_ON_ONCE_RM(!page);
+	if (!page) {
+		WARN_ON_ONCE_RM(tce != 0);
+		return;
+	}
 	tbl = kvmppc_page_address(page);
 
 	tbl[idx % TCES_PER_PAGE] = tce;
-- 
2.30.2



