Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B914FCB31
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 03:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347622AbiDLBD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 21:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348404AbiDLA7V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:59:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD99D34BAD;
        Mon, 11 Apr 2022 17:52:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F90A6066C;
        Tue, 12 Apr 2022 00:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E2EC385AC;
        Tue, 12 Apr 2022 00:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724749;
        bh=x0vO82PgmsO84hJdKK64ihCc5vTDwaWia8Yej7d8jas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W6cMSEYfp59/9eP9oQd2YVYrXIguEUx9xXPfA9AFc1OtDQSfE5f2A9ojii0eV7YcE
         D0518MLj9G8Lfpcb0/fnTEvs0+y/kHLfIQM8pUflfGVsfbbk3dUUBXnIPSnP2h97JM
         LhNk/khpgTp9JevR3Dci2w73ecAWVcZsWqYUppFIjGnDcS5fICoybNUyyAYKD9Hmqc
         UZkvqjS9gTAp+OZUJaqUY6/dZcFGgcF2WKrC/yPRKXerhVA8eoV3Nwhvfd0hmXX9e/
         NCwjxm2mD4tAT+dTm4Ye88wHja3QTt49FMiHh5+FjwHS/F1J5ogylXhJQxjAanlhBX
         MgOWwiX2NAPMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bodo Stroesser <bostroesser@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 04/11] scsi: target: tcmu: Fix possible page UAF
Date:   Mon, 11 Apr 2022 20:52:13 -0400
Message-Id: <20220412005222.351554-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412005222.351554-1-sashal@kernel.org>
References: <20220412005222.351554-1-sashal@kernel.org>
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
index 96601fda47b1..f687481ccfdc 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1165,6 +1165,7 @@ static struct page *tcmu_try_get_block_page(struct tcmu_dev *udev, uint32_t dbi)
 	mutex_lock(&udev->cmdr_lock);
 	page = tcmu_get_block_page(udev, dbi);
 	if (likely(page)) {
+		get_page(page);
 		mutex_unlock(&udev->cmdr_lock);
 		return page;
 	}
@@ -1233,6 +1234,7 @@ static int tcmu_vma_fault(struct vm_fault *vmf)
 		/* For the vmalloc()ed cmd area pages */
 		addr = (void *)(unsigned long)info->mem[mi].addr + offset;
 		page = vmalloc_to_page(addr);
+		get_page(page);
 	} else {
 		uint32_t dbi;
 
@@ -1243,7 +1245,6 @@ static int tcmu_vma_fault(struct vm_fault *vmf)
 			return VM_FAULT_NOPAGE;
 	}
 
-	get_page(page);
 	vmf->page = page;
 	return 0;
 }
-- 
2.35.1

