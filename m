Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0893E37C108
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbhELOzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 10:55:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231966AbhELOzL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:55:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E2B061412;
        Wed, 12 May 2021 14:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831243;
        bh=E79p+csodFQPQQRgKsiTYojgms5YKYfKZRs+vcA16Uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GL93NcFFVgbuo14PGOQJm1F0nvKScB+qpMEOJ+hbNB0W/NKHUWFXKQtAJPv/BwUU3
         2x1RmHEww0gWz1l4RO44hohyDykElshqles6ZdOMaIzPQ2744cLcJC777UMsFPYCH0
         G2qrFEe5yGgV892Gq7suT2ZkoLGVnHbgnBVRY0DE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Steven Price <steven.price@arm.com>
Subject: [PATCH 5.4 040/244] drm/panfrost: Dont try to map pages that are already mapped
Date:   Wed, 12 May 2021 16:46:51 +0200
Message-Id: <20210512144744.334442699@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@collabora.com>

commit f45da8204ff1707c529a8769f5467ff16f504b26 upstream.

We allocate 2MB chunks at a time, so it might appear that a page fault
has already been handled by a previous page fault when we reach
panfrost_mmu_map_fault_addr(). Bail out in that case to avoid mapping the
same area twice.

Cc: <stable@vger.kernel.org>
Fixes: 187d2929206e ("drm/panfrost: Add support for GPU heap allocations")
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210205111757.585248-3-boris.brezillon@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panfrost/panfrost_mmu.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -494,8 +494,14 @@ static int panfrost_mmu_map_fault_addr(s
 		}
 		bo->base.pages = pages;
 		bo->base.pages_use_count = 1;
-	} else
+	} else {
 		pages = bo->base.pages;
+		if (pages[page_offset]) {
+			/* Pages are already mapped, bail out. */
+			mutex_unlock(&bo->base.pages_lock);
+			goto out;
+		}
+	}
 
 	mapping = bo->base.base.filp->f_mapping;
 	mapping_set_unevictable(mapping);
@@ -529,6 +535,7 @@ static int panfrost_mmu_map_fault_addr(s
 
 	dev_dbg(pfdev->dev, "mapped page fault @ AS%d %llx", as, addr);
 
+out:
 	panfrost_gem_mapping_put(bomapping);
 
 	return 0;


