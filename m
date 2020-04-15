Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A83B1AA048
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393949AbgDOMZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:25:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409192AbgDOLpj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:45:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6AC120737;
        Wed, 15 Apr 2020 11:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951139;
        bh=m+w5uaRYA/AL4UTSG98B7NccPyt8vlHvlJqoKTpYCvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UHxe+9SQl+uku+GL2tljysZczazkG6sNWroi9Z0r4Ave5KS8ZP0+lsskiueDbcYtO
         6MU0xbTZym0s094pkpY/NvfWVRYDbFqaW1/u8Qu/c6ksXEGXRRDd4NWFz5yhOquopd
         hiEsTq7Mkk/BvXey9Z9O3yDytXe8UQHXqM4EVnB8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ralph Campbell <rcampbell@nvidia.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 49/84] drm/nouveau/svm: fix vma range check for migration
Date:   Wed, 15 Apr 2020 07:44:06 -0400
Message-Id: <20200415114442.14166-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114442.14166-1-sashal@kernel.org>
References: <20200415114442.14166-1-sashal@kernel.org>
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
index 25b7055949c45..824654742a604 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -186,6 +186,7 @@ nouveau_svmm_bind(struct drm_device *dev, void *data,
 		if (!vma)
 			break;
 
+		addr = max(addr, vma->vm_start);
 		next = min(vma->vm_end, end);
 		/* This is a best effort so we ignore errors */
 		nouveau_dmem_migrate_vma(cli->drm, vma, addr, next);
-- 
2.20.1

