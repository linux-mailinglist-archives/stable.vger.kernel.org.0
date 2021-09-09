Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D23040496D
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235674AbhIILmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:42:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235646AbhIILmT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:42:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05BD2611AD;
        Thu,  9 Sep 2021 11:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187669;
        bh=kc1FYvBpSgEy2QFyFkir9/64Xk8FZ8y5oackNASlSTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qBrWEgifJkeg8mXc5TG2xTj9qoyzGSA9u7z2hgCMlgl/Y7jiKyZXNMESheKee9A5U
         LBvxipafY6ckhOkTlA34sZr/8/CBs9apcXbitS3yFqhoBuOrc+DyCel7SPj22kWX89
         +J4ofksoZ0S3/w0pNpZOrf1Kt5l6AAczjcBje/ttcLX0coDfpEKz7Sl2RV2ohtfgUg
         bkbhPD4Z2DJRW7hwHIRUcyOfQFhRluW+di8gW6Xko1VT4xnaOfBXrbqgXNrbB278y5
         ZaRD97rHvdviBxWqw3sf/HOkYm3SqL9VWN0HVGQCi1KowT9HjLK1KIFqcJF2tOEAme
         9/EUqZ+YPT1eA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zack Rusin <zackr@vmware.com>,
        Roland Scheidegger <sroland@vmware.com>,
        Martin Krastev <krastevm@vmware.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.14 002/252] drm/vmwgfx: Fix subresource updates with new contexts
Date:   Thu,  9 Sep 2021 07:36:56 -0400
Message-Id: <20210909114106.141462-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

[ Upstream commit a12be0277316ed923411c9c80b2899ee74d2b033 ]

The has_dx variable was only set during the initialization which
meant that UPDATE_SUBRESOURCE was never used. We were emulating it
with UPDATE_GB_IMAGE but that's always been a stop-gap. Instead
of has_dx which has been deprecated a long time ago we need to check
for whether shader model 4.0 or newer is available to the device.

Signed-off-by: Zack Rusin <zackr@vmware.com>
Reviewed-by: Roland Scheidegger <sroland@vmware.com>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210609172307.131929-4-zackr@vmware.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
index 0835468bb2ee..47c03a276515 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
@@ -1872,7 +1872,6 @@ static void vmw_surface_dirty_range_add(struct vmw_resource *res, size_t start,
 static int vmw_surface_dirty_sync(struct vmw_resource *res)
 {
 	struct vmw_private *dev_priv = res->dev_priv;
-	bool has_dx = 0;
 	u32 i, num_dirty;
 	struct vmw_surface_dirty *dirty =
 		(struct vmw_surface_dirty *) res->dirty;
@@ -1899,7 +1898,7 @@ static int vmw_surface_dirty_sync(struct vmw_resource *res)
 	if (!num_dirty)
 		goto out;
 
-	alloc_size = num_dirty * ((has_dx) ? sizeof(*cmd1) : sizeof(*cmd2));
+	alloc_size = num_dirty * ((has_sm4_context(dev_priv)) ? sizeof(*cmd1) : sizeof(*cmd2));
 	cmd = VMW_CMD_RESERVE(dev_priv, alloc_size);
 	if (!cmd)
 		return -ENOMEM;
@@ -1917,7 +1916,7 @@ static int vmw_surface_dirty_sync(struct vmw_resource *res)
 		 * DX_UPDATE_SUBRESOURCE is aware of array surfaces.
 		 * UPDATE_GB_IMAGE is not.
 		 */
-		if (has_dx) {
+		if (has_sm4_context(dev_priv)) {
 			cmd1->header.id = SVGA_3D_CMD_DX_UPDATE_SUBRESOURCE;
 			cmd1->header.size = sizeof(cmd1->body);
 			cmd1->body.sid = res->id;
-- 
2.30.2

