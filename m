Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28EA4FCA69
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244317AbiDLAxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245212AbiDLAxG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:53:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9698E31519;
        Mon, 11 Apr 2022 17:47:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 039A6B8186F;
        Tue, 12 Apr 2022 00:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE87C385AA;
        Tue, 12 Apr 2022 00:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724470;
        bh=00QZOWtD55fHKQOKnPxpPpVI9oc8eABGIOsh3pHyJwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jlV9QTkHKMc6KyAaS87SKathRKmrryGFR4V+VnVt3LQC3dFhsWeFG5WiM7D6lvXsN
         IqYOMFQxtjfRr4blJHmF1cv+39oBVm/rvlX8z56T2W1S70cE6STKBojt5nZY4oJdG6
         o1R2gMvlckVeV5/Rv649a9O72/dh1cnTWh/Hd44uAcie/WntIh3PbbBlozaj2ENW0V
         NWAb0XDsklHolAZto7qK+Zr8zxTLIAq5x0szkrF16txVm5HnUhJ03ysjcXT/eeiWpT
         lmbbsYArHsMH+9vHe2u/D/ujk/GfMiNGG4OweWOL8ttcLizi3TY9a75RRvpDXH+c7E
         GicK8k0bD9QkQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bodo Stroesser <bostroesser@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 15/41] scsi: target: tcmu: Fix possible page UAF
Date:   Mon, 11 Apr 2022 20:46:27 -0400
Message-Id: <20220412004656.350101-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004656.350101-1-sashal@kernel.org>
References: <20220412004656.350101-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

[ Upstream commit a6968f7a367f128d120447360734344d5a3d5336 ]

tcmu_try_get_data_page() looks up pages under cmdr_lock, but it does not
take refcount properly and just returns page pointer. When
tcmu_try_get_data_page() returns, the returned page may have been freed by
tcmu_blocks_release().

We need to get_page() under cmdr_lock to avoid concurrent
tcmu_blocks_release().

Link: https://lore.kernel.org/r/20220311132206.24515-1-xiaoguang.wang@linux.alibaba.com
Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_user.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 9f552f48084c..0ca5ec14d3db 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1821,6 +1821,7 @@ static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
 	mutex_lock(&udev->cmdr_lock);
 	page = xa_load(&udev->data_pages, dpi);
 	if (likely(page)) {
+		get_page(page);
 		mutex_unlock(&udev->cmdr_lock);
 		return page;
 	}
@@ -1877,6 +1878,7 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
 		/* For the vmalloc()ed cmd area pages */
 		addr = (void *)(unsigned long)info->mem[mi].addr + offset;
 		page = vmalloc_to_page(addr);
+		get_page(page);
 	} else {
 		uint32_t dpi;
 
@@ -1887,7 +1889,6 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
 			return VM_FAULT_SIGBUS;
 	}
 
-	get_page(page);
 	vmf->page = page;
 	return 0;
 }
-- 
2.35.1

