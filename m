Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1443812F140
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgABW7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:59:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:55116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727948AbgABWOn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:14:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F60E21D7D;
        Thu,  2 Jan 2020 22:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003282;
        bh=rvBKXNL2zspQZcX54WvZYh3lHndspUwQyuz6IcZK5+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q8ki3vhRs3l0HpqlUbkSObj13hpA9NRgpInDCpWBabHCOEOKTepPF22/EJE3RTZHu
         zaWHmv2/eW/TmoPd4W0kgZbYQGLf5EuzX7CalQuOLoSGabb6JbShJ3U5EzNlNWgK7/
         HdDwz+5sMoNNrhtOAeKuTrH0dl5EbWe9cy0ys1Xk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Omer Shpigelman <oshpigelman@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/191] habanalabs: skip VA block list update in reset flow
Date:   Thu,  2 Jan 2020 23:06:18 +0100
Message-Id: <20200102215840.195594801@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Omer Shpigelman <oshpigelman@habana.ai>

[ Upstream commit 71c5e55e7c077fa17c42fbda91a8d14322825c44 ]

Reduce context close time by skipping the VA block free list update in
order to avoid hard reset with open contexts.
Reset with open contexts can potentially lead to a kernel crash as the
generic pool of the MMU hops is destroyed while it is not empty because
some unmap operations are not done.
The commit affect mainly when running on simulator.

Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/memory.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/habanalabs/memory.c b/drivers/misc/habanalabs/memory.c
index 365fb0cb8dff..22566b75ca50 100644
--- a/drivers/misc/habanalabs/memory.c
+++ b/drivers/misc/habanalabs/memory.c
@@ -965,17 +965,19 @@ init_page_pack_err:
  *
  * @ctx                 : current context
  * @vaddr               : device virtual address to unmap
+ * @ctx_free            : true if in context free flow, false otherwise.
  *
  * This function does the following:
  * - Unmap the physical pages related to the given virtual address
  * - return the device virtual block to the virtual block list
  */
-static int unmap_device_va(struct hl_ctx *ctx, u64 vaddr)
+static int unmap_device_va(struct hl_ctx *ctx, u64 vaddr, bool ctx_free)
 {
 	struct hl_device *hdev = ctx->hdev;
 	struct hl_vm_phys_pg_pack *phys_pg_pack = NULL;
 	struct hl_vm_hash_node *hnode = NULL;
 	struct hl_userptr *userptr = NULL;
+	struct hl_va_range *va_range;
 	enum vm_type_t *vm_type;
 	u64 next_vaddr, i;
 	u32 page_size;
@@ -1003,6 +1005,7 @@ static int unmap_device_va(struct hl_ctx *ctx, u64 vaddr)
 
 	if (*vm_type == VM_TYPE_USERPTR) {
 		is_userptr = true;
+		va_range = &ctx->host_va_range;
 		userptr = hnode->ptr;
 		rc = init_phys_pg_pack_from_userptr(ctx, userptr,
 				&phys_pg_pack);
@@ -1014,6 +1017,7 @@ static int unmap_device_va(struct hl_ctx *ctx, u64 vaddr)
 		}
 	} else if (*vm_type == VM_TYPE_PHYS_PACK) {
 		is_userptr = false;
+		va_range = &ctx->dram_va_range;
 		phys_pg_pack = hnode->ptr;
 	} else {
 		dev_warn(hdev->dev,
@@ -1052,12 +1056,18 @@ static int unmap_device_va(struct hl_ctx *ctx, u64 vaddr)
 
 	mutex_unlock(&ctx->mmu_lock);
 
-	if (add_va_block(hdev,
-			is_userptr ? &ctx->host_va_range : &ctx->dram_va_range,
-			vaddr,
-			vaddr + phys_pg_pack->total_size - 1))
-		dev_warn(hdev->dev, "add va block failed for vaddr: 0x%llx\n",
-				vaddr);
+	/*
+	 * No point in maintaining the free VA block list if the context is
+	 * closing as the list will be freed anyway
+	 */
+	if (!ctx_free) {
+		rc = add_va_block(hdev, va_range, vaddr,
+					vaddr + phys_pg_pack->total_size - 1);
+		if (rc)
+			dev_warn(hdev->dev,
+					"add va block failed for vaddr: 0x%llx\n",
+					vaddr);
+	}
 
 	atomic_dec(&phys_pg_pack->mapping_cnt);
 	kfree(hnode);
@@ -1189,8 +1199,8 @@ int hl_mem_ioctl(struct hl_fpriv *hpriv, void *data)
 		break;
 
 	case HL_MEM_OP_UNMAP:
-		rc = unmap_device_va(ctx,
-				args->in.unmap.device_virt_addr);
+		rc = unmap_device_va(ctx, args->in.unmap.device_virt_addr,
+					false);
 		break;
 
 	default:
@@ -1620,7 +1630,7 @@ void hl_vm_ctx_fini(struct hl_ctx *ctx)
 		dev_dbg(hdev->dev,
 			"hl_mem_hash_node of vaddr 0x%llx of asid %d is still alive\n",
 			hnode->vaddr, ctx->asid);
-		unmap_device_va(ctx, hnode->vaddr);
+		unmap_device_va(ctx, hnode->vaddr, true);
 	}
 
 	spin_lock(&vm->idr_lock);
-- 
2.20.1



