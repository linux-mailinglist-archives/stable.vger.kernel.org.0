Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C58B22EFF8
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731610AbgG0OUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:20:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731588AbgG0OUt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:20:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBE7D2075A;
        Mon, 27 Jul 2020 14:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859648;
        bh=XPOZuHx0Bmu2whHdaFaD9f4tjNBNzx0/U0ksny33t6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zZwktswBqrsV+FKW8ZdJOEvXNq/Q2uE5W6GTxIPvGYQAYePqQQV4j+HWZR2Lw+Vhi
         ZPiGMbW0EMHmu2fTTSvGWuXFPJTyDc5Y6+KTEh5au7szghK+0scgcAxDMWTSx7GaVw
         gYK6DP4PjD4Bun+xFQ4ZsthQVin42ZREbSIsemMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ralph Campbell <rcampbell@nvidia.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 021/179] drm/nouveau/nouveau: fix page fault on device private memory
Date:   Mon, 27 Jul 2020 16:03:16 +0200
Message-Id: <20200727134933.700692019@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ralph Campbell <rcampbell@nvidia.com>

[ Upstream commit ed710a6ed797430026aa5116dd0ab22378798b69 ]

If system memory is migrated to device private memory and no GPU MMU
page table entry exists, the GPU will fault and call hmm_range_fault()
to get the PFN for the page. Since the .dev_private_owner pointer in
struct hmm_range is not set, hmm_range_fault returns an error which
results in the GPU program stopping with a fatal fault.
Fix this by setting .dev_private_owner appropriately.

Fixes: 08ddddda667b ("mm/hmm: check the device private page owner in hmm_range_fault()")
Cc: stable@vger.kernel.org
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_svm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
index 645fedd77e21b..a9ce86740799f 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -534,6 +534,7 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
 		.flags = nouveau_svm_pfn_flags,
 		.values = nouveau_svm_pfn_values,
 		.pfn_shift = NVIF_VMM_PFNMAP_V0_ADDR_SHIFT,
+		.dev_private_owner = drm->dev,
 	};
 	struct mm_struct *mm = notifier->notifier.mm;
 	long ret;
-- 
2.25.1



