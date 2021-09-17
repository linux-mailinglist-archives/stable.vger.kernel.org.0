Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C52840EF4B
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242727AbhIQCe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:34:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242895AbhIQCer (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:34:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2406B61139;
        Fri, 17 Sep 2021 02:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846006;
        bh=KGh9IOVgMdcQ2Z0MBfpIcMegi94Aq1Fs1TcaFLGVZdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jXyaVJVWME5+n8EdrshMVJzpB6csynKo+e6+EGm+gG22qhyAGdm3GyfxuEVv51wiI
         0MeQMt1K+8NrRTtlNsudOTgSJkGGO7xxdDj2fMMmNn92r483qNbmZ6/za8L49ovCbC
         j3AHSzGao/BaTE7SfxNtfJYURh1v8ES2zeeFE2ypeCZw2lb4N80RUvgg0HmSkPoe/8
         nv1L+KvhSYKOEUXFEQ8RgaBzz4rJRetdHFo6yNKmncaavfhhtDgeuoThhgWTWrRQF9
         sbFgj/sEWw0uSNK1OckUn4ByrmZfyGI9IFrWzG/6oArK6CKZaer+V7aoilBZ0XPpNc
         yrJsUqHw0akwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomer Tayar <ttayar@habana.ai>, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>, Arnd@vger.kernel.org,
        gregkh@linuxfoundation.org, mhaimovski@habana.ai, obitton@habana.ai
Subject: [PATCH AUTOSEL 5.14 02/21] habanalabs: fix nullifying of destroyed mmu pgt pool
Date:   Thu, 16 Sep 2021 22:32:56 -0400
Message-Id: <20210917023315.816225-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917023315.816225-1-sashal@kernel.org>
References: <20210917023315.816225-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomer Tayar <ttayar@habana.ai>

[ Upstream commit 89aad770d692e4d2d9a604c1674e9dfa69421430 ]

In case of host-resident MMU, when the page tables pool is destroyed,
its pointer is not nullified correctly.
As a result, on a device fini which happens after a failing reset, the
already destroyed pool is accessed, which leads to a kernel panic.
The patch fixes the setting of the pool pointer to NULL.

Signed-off-by: Tomer Tayar <ttayar@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/mmu/mmu_v1.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/habanalabs/common/mmu/mmu_v1.c b/drivers/misc/habanalabs/common/mmu/mmu_v1.c
index c5e93ff32586..0f536f79dd9c 100644
--- a/drivers/misc/habanalabs/common/mmu/mmu_v1.c
+++ b/drivers/misc/habanalabs/common/mmu/mmu_v1.c
@@ -470,13 +470,13 @@ static void hl_mmu_v1_fini(struct hl_device *hdev)
 	if (!ZERO_OR_NULL_PTR(hdev->mmu_priv.hr.mmu_shadow_hop0)) {
 		kvfree(hdev->mmu_priv.dr.mmu_shadow_hop0);
 		gen_pool_destroy(hdev->mmu_priv.dr.mmu_pgt_pool);
-	}
 
-	/* Make sure that if we arrive here again without init was called we
-	 * won't cause kernel panic. This can happen for example if we fail
-	 * during hard reset code at certain points
-	 */
-	hdev->mmu_priv.dr.mmu_shadow_hop0 = NULL;
+		/* Make sure that if we arrive here again without init was
+		 * called we won't cause kernel panic. This can happen for
+		 * example if we fail during hard reset code at certain points
+		 */
+		hdev->mmu_priv.dr.mmu_shadow_hop0 = NULL;
+	}
 }
 
 /**
-- 
2.30.2

