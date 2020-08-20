Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89FB624AB4A
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 02:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgHTAJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 20:09:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728077AbgHTACp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 20:02:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AFA1214F1;
        Thu, 20 Aug 2020 00:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881765;
        bh=2piNqjgMF8RHhqlBhK0HIYSunlesgNni0vdGlmvyMoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pCMfCHDDcWT6RkO93BxA8ayHdRLQ1SET16sEgqxkPNelW0yaVV5HaP1a46ooyKLWI
         812QD+YGp22Ny1vSk1shErHZT1/+s+wErtgtSQjmeS5e/KKN8VI4dTJV4cu2ZgcDNV
         fDLLXqMykZnqGM0xpbLQzPtHZFxa7WSn0UMc6D9M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Kuehling <Felix.Kuehling@amd.com>,
        Laurent Morichetti <laurent.morichetti@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 11/22] drm/ttm: fix offset in VMAs with a pg_offs in ttm_bo_vm_access
Date:   Wed, 19 Aug 2020 20:02:18 -0400
Message-Id: <20200820000229.215333-11-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200820000229.215333-1-sashal@kernel.org>
References: <20200820000229.215333-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index 46dc3de7e81bf..f2bad14ac04ab 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -358,8 +358,10 @@ static int ttm_bo_vm_access_kmap(struct ttm_buffer_object *bo,
 static int ttm_bo_vm_access(struct vm_area_struct *vma, unsigned long addr,
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

