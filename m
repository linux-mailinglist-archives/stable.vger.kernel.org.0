Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7FC524BCA6
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbgHTMuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729194AbgHTJpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:45:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 022D922D08;
        Thu, 20 Aug 2020 09:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916670;
        bh=Bgf8F92t/ZAyenynqhNM6Yf/xAbcyUQKG4+V7kmmPnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r2Uo7GwTX8OH3ioNvPrE4QtJv0UZhiml2VVYQMnnOYMcjujxytheCMUZyGd6H99Vl
         V3Al9V3CifVabkrrgGMh1RFCM0Jd8oHGhuUXtsz9yH3W3BOE9R8ZmQTVjP/iauURZB
         wxOiVM4xTS4WDoJnimrevc0BS+H76DPKRweAqG4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        Steven Price <steven.price@arm.com>
Subject: [PATCH 5.7 195/204] drm/panfrost: Use kvfree() to free bo->sgts
Date:   Thu, 20 Aug 2020 11:21:32 +0200
Message-Id: <20200820091615.921958132@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

commit 114427b8927a4def2942b2b886f7e4aeae289ccb upstream.

Use kvfree() to free bo->sgts, because the memory is allocated with
kvmalloc_array() in panfrost_mmu_map_fault_addr().

Fixes: 187d2929206e ("drm/panfrost: Add support for GPU heap allocations")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200608151728.234026-1-efremov@linux.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/panfrost/panfrost_gem.c |    2 +-
 drivers/gpu/drm/panfrost/panfrost_mmu.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/panfrost/panfrost_gem.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -46,7 +46,7 @@ static void panfrost_gem_free_object(str
 				sg_free_table(&bo->sgts[i]);
 			}
 		}
-		kfree(bo->sgts);
+		kvfree(bo->sgts);
 	}
 
 	drm_gem_shmem_free_object(obj);
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -486,7 +486,7 @@ static int panfrost_mmu_map_fault_addr(s
 		pages = kvmalloc_array(bo->base.base.size >> PAGE_SHIFT,
 				       sizeof(struct page *), GFP_KERNEL | __GFP_ZERO);
 		if (!pages) {
-			kfree(bo->sgts);
+			kvfree(bo->sgts);
 			bo->sgts = NULL;
 			mutex_unlock(&bo->base.pages_lock);
 			ret = -ENOMEM;


