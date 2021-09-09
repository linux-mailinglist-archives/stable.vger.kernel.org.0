Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431C0404DDF
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345429AbhIIMHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:07:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344659AbhIIMCU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:02:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8C4A61875;
        Thu,  9 Sep 2021 11:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187997;
        bh=X2q7Z1zfpLOSvHYiWSiDtyxDNg4a9cAdNOuSsmS1TqM=;
        h=From:To:Cc:Subject:Date:From;
        b=N1t1zxU4wr0wl9bJQLnnD9vOPbx6AzGLg1Mitn3o5j0+8WddOFCCKKlOxKbgbgryM
         21K7Gql4cR4V9zK3T5MYN2LDTLd3dI1tqhW5ttCnVJ3Q8CbGYYnqzVgN7hebkIZ+LC
         nM2ygNmsG2mkKiHr/sBLboILU74urylKSyva/1f9BsrT1Bdku8gu3mgdMQEj2SQmlS
         bgcxEYjjv1kiBpDKirKvaRwcq6wuFysslRrJXtmT1IAkwSiMJXjpMIeQNS2mDE0eUr
         aP8vCoR0ex74/hIqR5aXXn+ruZV6bXo4VtR7TuVd7ro7zut0soXw1i+lI47YyfftKG
         xudH+L6wDogLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zack Rusin <zackr@vmware.com>,
        Roland Scheidegger <sroland@vmware.com>,
        Martin Krastev <krastevm@vmware.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 001/219] drm/vmwgfx: Fix subresource updates with new contexts
Date:   Thu,  9 Sep 2021 07:42:57 -0400
Message-Id: <20210909114635.143983-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
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
index beab3e19d8e2..5ff88f8c2382 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
@@ -1883,7 +1883,6 @@ static void vmw_surface_dirty_range_add(struct vmw_resource *res, size_t start,
 static int vmw_surface_dirty_sync(struct vmw_resource *res)
 {
 	struct vmw_private *dev_priv = res->dev_priv;
-	bool has_dx = 0;
 	u32 i, num_dirty;
 	struct vmw_surface_dirty *dirty =
 		(struct vmw_surface_dirty *) res->dirty;
@@ -1910,7 +1909,7 @@ static int vmw_surface_dirty_sync(struct vmw_resource *res)
 	if (!num_dirty)
 		goto out;
 
-	alloc_size = num_dirty * ((has_dx) ? sizeof(*cmd1) : sizeof(*cmd2));
+	alloc_size = num_dirty * ((has_sm4_context(dev_priv)) ? sizeof(*cmd1) : sizeof(*cmd2));
 	cmd = VMW_CMD_RESERVE(dev_priv, alloc_size);
 	if (!cmd)
 		return -ENOMEM;
@@ -1928,7 +1927,7 @@ static int vmw_surface_dirty_sync(struct vmw_resource *res)
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

