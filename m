Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8D524F9B8
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbgHXJsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:48:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728756AbgHXIkd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:40:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 340C02074D;
        Mon, 24 Aug 2020 08:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258432;
        bh=bN7dJrzpgTx4kNBALgXdM5o7wtL1Q+rEH6arvcnTpUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sd2ITVHT85dr+LKkJsbd/o5SL0Ow8NG/rRJoNpDgHKn68uBIKWZ0UvgLGRDP8T2Pf
         FsA7NmrTWRXA93VauOx5W+dIf5WeY4cOwKAS44TmZ4OLX2RhvLTrHrLGERHT1qllja
         /y7AA8bIGlVvTQokbRqtGn8D4ezb9qypX+gFgeLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        Laurent Morichetti <laurent.morichetti@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 046/124] drm/ttm: fix offset in VMAs with a pg_offs in ttm_bo_vm_access
Date:   Mon, 24 Aug 2020 10:29:40 +0200
Message-Id: <20200824082411.690630357@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Kuehling <Felix.Kuehling@amd.com>

[ Upstream commit c0001213d195d1bac83e0744c06ff06dd5a8ba53 ]

VMAs with a pg_offs that's offset from the start of the vma_node need
to adjust the offset within the BO accordingly. This matches the
offset calculation in ttm_bo_vm_fault_reserved.

Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Tested-by: Laurent Morichetti <laurent.morichetti@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/381169/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_bo_vm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_vm.c b/drivers/gpu/drm/ttm/ttm_bo_vm.c
index 72100b84c7a90..b08fdfa4291b2 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -505,8 +505,10 @@ static int ttm_bo_vm_access_kmap(struct ttm_buffer_object *bo,
 int ttm_bo_vm_access(struct vm_area_struct *vma, unsigned long addr,
 		     void *buf, int len, int write)
 {
-	unsigned long offset = (addr) - vma->vm_start;
 	struct ttm_buffer_object *bo = vma->vm_private_data;
+	unsigned long offset = (addr) - vma->vm_start +
+		((vma->vm_pgoff - drm_vma_node_start(&bo->base.vma_node))
+		 << PAGE_SHIFT);
 	int ret;
 
 	if (len < 1 || (offset + len) >> PAGE_SHIFT > bo->num_pages)
-- 
2.25.1



