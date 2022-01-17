Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA04490E3F
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242791AbiAQRIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242799AbiAQRGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:06:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380CDC0617BB;
        Mon, 17 Jan 2022 09:03:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3E62B8113A;
        Mon, 17 Jan 2022 17:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B975FC36AEC;
        Mon, 17 Jan 2022 17:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439035;
        bh=LxtqiCU/HnTQBi7Y6RaZ5mzfJ2enE8ac2ayAJ6KDquo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EBvTbbLMUaczfVQiZ/W2PWhDvqCjV+KYr1JYvqyiLPYpJER8qMYe932OIFpKFK/H5
         XyJEdCLXYWZYMazxOMoB4anM7s427zoCDVqwO6ekLuj3Y4RYkMFwvCNVSQ3sj5JSAG
         JcPplDgepmjGVxLkGuiPpUofykIa6khZAl+3mQi9iPjtCvaqJtAadcTZBxk3q1kkl3
         DKa+q2dk6G59sF9KohlcPK/MDAlCvWgvbl4aoW+anzkLFee3u2Amir4O1Nm/hC0A15
         YXwuU4pRELaByL9PLBJOjTqpA37AQ1Ofdw2OAqrHu2k0s7U0N4Bu2mI+Q0fOHs4x2q
         +C1uBAvWxlKFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, npiggin@gmail.com,
        farosas@linux.ibm.com, paulus@ozlabs.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 13/34] KVM: PPC: Book3S: Suppress warnings when allocating too big memory slots
Date:   Mon, 17 Jan 2022 12:03:03 -0500
Message-Id: <20220117170326.1471712-13-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170326.1471712-1-sashal@kernel.org>
References: <20220117170326.1471712-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 175967a195c44..527c205d5a5f5 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4557,8 +4557,12 @@ static int kvmppc_core_prepare_memory_region_hv(struct kvm *kvm,
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

