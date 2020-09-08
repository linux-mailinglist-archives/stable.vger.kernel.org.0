Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF699261996
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732199AbgIHSVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:21:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731465AbgIHQLL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:11:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59865247BE;
        Tue,  8 Sep 2020 15:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579743;
        bh=v4bypPfOHHDKcx4EgTafloiA7b16Xk5jkU7UZswiyRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AkLg9lCJsrz/D0CuCVMYQmAljVXwYibNbIGyouBwKbSU0bTHmR6sYpbQYjpv1FBaC
         0zA+0VQt5o43JhcQa2STypUnV7GwaAjF+y/uaQ6tmU1r8jh3QWkrJgfA3nlMpSL7Gm
         arBGXT9Bj0+emLOZrglL56JDDPgvoH7gpqdjymos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ofir Bitton <obitton@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 009/129] habanalabs: check correct vmalloc return code
Date:   Tue,  8 Sep 2020 17:24:10 +0200
Message-Id: <20200908152230.156658750@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ofir Bitton <obitton@habana.ai>

[ Upstream commit 0839152f8c1efc1cc2d515d1ff1e253ca9402ad3 ]

vmalloc can return different return code than NULL and a valid
pointer. We must validate it in order to dereference a non valid
pointer.

Signed-off-by: Ofir Bitton <obitton@habana.ai>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/memory.c | 9 +++++++--
 drivers/misc/habanalabs/mmu.c    | 2 +-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/habanalabs/memory.c b/drivers/misc/habanalabs/memory.c
index 22566b75ca50c..acfccf32be6b9 100644
--- a/drivers/misc/habanalabs/memory.c
+++ b/drivers/misc/habanalabs/memory.c
@@ -67,6 +67,11 @@ static int alloc_device_memory(struct hl_ctx *ctx, struct hl_mem_in *args,
 	num_pgs = (args->alloc.mem_size + (page_size - 1)) >> page_shift;
 	total_size = num_pgs << page_shift;
 
+	if (!total_size) {
+		dev_err(hdev->dev, "Cannot allocate 0 bytes\n");
+		return -EINVAL;
+	}
+
 	contiguous = args->flags & HL_MEM_CONTIGUOUS;
 
 	if (contiguous) {
@@ -94,7 +99,7 @@ static int alloc_device_memory(struct hl_ctx *ctx, struct hl_mem_in *args,
 	phys_pg_pack->contiguous = contiguous;
 
 	phys_pg_pack->pages = kvmalloc_array(num_pgs, sizeof(u64), GFP_KERNEL);
-	if (!phys_pg_pack->pages) {
+	if (ZERO_OR_NULL_PTR(phys_pg_pack->pages)) {
 		rc = -ENOMEM;
 		goto pages_arr_err;
 	}
@@ -689,7 +694,7 @@ static int init_phys_pg_pack_from_userptr(struct hl_ctx *ctx,
 
 	phys_pg_pack->pages = kvmalloc_array(total_npages, sizeof(u64),
 						GFP_KERNEL);
-	if (!phys_pg_pack->pages) {
+	if (ZERO_OR_NULL_PTR(phys_pg_pack->pages)) {
 		rc = -ENOMEM;
 		goto page_pack_arr_mem_err;
 	}
diff --git a/drivers/misc/habanalabs/mmu.c b/drivers/misc/habanalabs/mmu.c
index 176c315836f12..d66e16de4cda3 100644
--- a/drivers/misc/habanalabs/mmu.c
+++ b/drivers/misc/habanalabs/mmu.c
@@ -422,7 +422,7 @@ int hl_mmu_init(struct hl_device *hdev)
 	hdev->mmu_shadow_hop0 = kvmalloc_array(prop->max_asid,
 					prop->mmu_hop_table_size,
 					GFP_KERNEL | __GFP_ZERO);
-	if (!hdev->mmu_shadow_hop0) {
+	if (ZERO_OR_NULL_PTR(hdev->mmu_shadow_hop0)) {
 		rc = -ENOMEM;
 		goto err_pool_add;
 	}
-- 
2.25.1



