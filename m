Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75BCF417453
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345488AbhIXNEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:04:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345928AbhIXNCk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:02:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB07261373;
        Fri, 24 Sep 2021 12:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488086;
        bh=8ZNp6MGPQigt7g8BT9DEDP1WpaZvvDlQLZKFV3SqiQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZGvBTKh70k89a+fqOzQWsx2QdvoE9B9+CWsvWHZvlrr5ZveHyB3PvhDIUB80E1JSE
         cf14s//JHQslxaWxSTjnhCH2pvb4mtUDRRPn6RD+7LLZUWyLVdKDWTr8MOJnWYD6UM
         59VfQ/KBLHVWBmZ7AAVEW3DDAoLDTPldAgogw7sI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomer Tayar <ttayar@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 079/100] habanalabs: fix nullifying of destroyed mmu pgt pool
Date:   Fri, 24 Sep 2021 14:44:28 +0200
Message-Id: <20210924124344.105159108@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.33.0



