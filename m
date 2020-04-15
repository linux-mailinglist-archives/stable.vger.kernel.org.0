Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4E91AA323
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503542AbgDONEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:04:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897133AbgDOLgR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:36:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E50B721556;
        Wed, 15 Apr 2020 11:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950577;
        bh=N7LuhKTX+VkNhecOFLMEu4r6U60EoVLmEHzq4lL3Zqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FHuTqaYSEYNOmgme2maO/lXEOydt8681MuBkTEuv0sglIcc06dl2LbptFWtYYou1z
         ZgHWFVQS3dM69h5xZwpL9NNx+PWtNkyDC94EOCkFJfz08AHvOx0MwIupR4BLHmnbJP
         l3a+IqkTJvUnEtfM+cdbrXf1WOGyL/N9McBbW0Mw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ralph Campbell <rcampbell@nvidia.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.6 078/129] drm/nouveau/svm: fix vma range check for migration
Date:   Wed, 15 Apr 2020 07:33:53 -0400
Message-Id: <20200415113445.11881-78-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ralph Campbell <rcampbell@nvidia.com>

[ Upstream commit b92103b559c77abc5f8b7bec269230a219c880b7 ]

find_vma_intersection(mm, start, end) only guarantees that end is greater
than or equal to vma->vm_start but doesn't guarantee that start is
greater than or equal to vma->vm_start. The calculation for the
intersecting range in nouveau_svmm_bind() isn't accounting for this and
can call migrate_vma_setup() with a starting address less than
vma->vm_start. This results in migrate_vma_setup() returning -EINVAL for
the range instead of nouveau skipping that part of the range and migrating
the rest.

Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_svm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
index 3ec5da025bea7..c567526b75b83 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -184,6 +184,7 @@ nouveau_svmm_bind(struct drm_device *dev, void *data,
 		if (!vma)
 			break;
 
+		addr = max(addr, vma->vm_start);
 		next = min(vma->vm_end, end);
 		/* This is a best effort so we ignore errors */
 		nouveau_dmem_migrate_vma(cli->drm, vma, addr, next);
-- 
2.20.1

