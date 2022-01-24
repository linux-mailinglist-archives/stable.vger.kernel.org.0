Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9D04994FF
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392006AbiAXUuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:50:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40348 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389520AbiAXUlf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:41:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0643B810BD;
        Mon, 24 Jan 2022 20:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AEC6C340E5;
        Mon, 24 Jan 2022 20:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056892;
        bh=lllL1+YSQOwmnLAGhKuxtgJRcS5EeLGylTj5nvLlLTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RyUC8CDcyCO7Q20D/Gkon9hOKwlvIFRhLuqxMsOQv9PNLBS5iPARoo33QUDqjxGsK
         E+UVfG1XLKgRAWvvikLQEzCNa1UrRgXWA7lK/Qwpdiu8N4JLJdapzLkeKlAfT7w/GZ
         vLuGDfvxJnQqi4hKoGrk/OuV3j01Un1n01YcxK3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 634/846] KVM: PPC: Book3S: Suppress warnings when allocating too big memory slots
Date:   Mon, 24 Jan 2022 19:42:31 +0100
Message-Id: <20220124184122.899954773@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit 511d25d6b789fffcb20a3eb71899cf974a31bd9d ]

The userspace can trigger "vmalloc size %lu allocation failure: exceeds
total pages" via the KVM_SET_USER_MEMORY_REGION ioctl.

This silences the warning by checking the limit before calling vzalloc()
and returns ENOMEM if failed.

This does not call underlying valloc helpers as __vmalloc_node() is only
exported when CONFIG_TEST_VMALLOC_MODULE and __vmalloc_node_range() is
not exported at all.

Spotted by syzkaller.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
[mpe: Use 'size' for the variable rather than 'cb']
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210901084512.1658628-1-aik@ozlabs.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 7b74fc0a986b8..94da0d25eb125 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4861,8 +4861,12 @@ static int kvmppc_core_prepare_memory_region_hv(struct kvm *kvm,
 	unsigned long npages = mem->memory_size >> PAGE_SHIFT;
 
 	if (change == KVM_MR_CREATE) {
-		slot->arch.rmap = vzalloc(array_size(npages,
-					  sizeof(*slot->arch.rmap)));
+		unsigned long size = array_size(npages, sizeof(*slot->arch.rmap));
+
+		if ((size >> PAGE_SHIFT) > totalram_pages())
+			return -ENOMEM;
+
+		slot->arch.rmap = vzalloc(size);
 		if (!slot->arch.rmap)
 			return -ENOMEM;
 	}
-- 
2.34.1



