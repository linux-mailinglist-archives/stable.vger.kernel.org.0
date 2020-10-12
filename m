Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C7128B7B0
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389799AbgJLNp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:45:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389771AbgJLNpz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B85D22203;
        Mon, 12 Oct 2020 13:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510341;
        bh=EyUHLpJ9aZARAFtXkW2k+HUAixFuRffHWncCUAfMynE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSAGn4jvE43KR0mhCeNzwNP95jk9kH5Bn96d/zTnBH7mdRSLCcPS6PlhSgzE9wHCa
         irTJkf6eLsUD6HYatj8i8oq6hkdu9SrcjEHFZj0YoWFJx9ucqfSt6KkAnuEsVRxP41
         x4JRX12dkcrIpX1OXaMhrmN1GWCPAM75WIljVtTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zack Rusin <zackr@vmware.com>,
        Roland Scheidegger <sroland@vmware.com>,
        Martin Krastev <krastevm@vmware.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 050/124] drm/vmwgfx: Fix error handling in get_node
Date:   Mon, 12 Oct 2020 15:30:54 +0200
Message-Id: <20201012133149.276124624@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

[ Upstream commit f54c4442893b8dfbd3aff8e903c54dfff1aef990 ]

ttm_mem_type_manager_func.get_node was changed to return -ENOSPC
instead of setting the node pointer to NULL. Unfortunately
vmwgfx still had two places where it was explicitly converting
-ENOSPC to 0 causing regressions. This fixes those spots by
allowing -ENOSPC to be returned. That seems to fix recent
regressions with vmwgfx.

Signed-off-by: Zack Rusin <zackr@vmware.com>
Reviewed-by: Roland Scheidegger <sroland@vmware.com>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Sigend-off-by: Roland Scheidegger <sroland@vmware.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c | 2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_thp.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c b/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c
index 7da752ca1c34b..b93c558dd86e0 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c
@@ -57,7 +57,7 @@ static int vmw_gmrid_man_get_node(struct ttm_mem_type_manager *man,
 
 	id = ida_alloc_max(&gman->gmr_ida, gman->max_gmr_ids - 1, GFP_KERNEL);
 	if (id < 0)
-		return (id != -ENOMEM ? 0 : id);
+		return id;
 
 	spin_lock(&gman->lock);
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_thp.c b/drivers/gpu/drm/vmwgfx/vmwgfx_thp.c
index b7c816ba71663..c8b9335bccd8d 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_thp.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_thp.c
@@ -95,7 +95,7 @@ found_unlock:
 		mem->start = node->start;
 	}
 
-	return 0;
+	return ret;
 }
 
 
-- 
2.25.1



