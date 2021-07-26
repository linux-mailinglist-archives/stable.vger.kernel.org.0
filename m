Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36473D6182
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbhGZPcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238017AbhGZP3l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71CA060240;
        Mon, 26 Jul 2021 16:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315809;
        bh=KNFYws57n4zXku7Nd/PLxb09tfrH2i/PZaiswKkAZgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PlOl05APnwCSC99iaHX0XOubkMIQcO8BPvPPRBksiY0VANKrh2XcRTPziWqqHOayq
         NP23Gr/J8iuvY7FWgQHQ657P5vT1D5Ng1vGsg4jlLJcVjLWfH2a8uzPTPmGNIPGAG3
         JcJ+a8gICWxZ8a5dL6Xm8YymD2zySup/p9Dmvfe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zack Rusin <zackr@vmware.com>,
        Martin Krastev <krastevm@vmware.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 029/223] drm/vmwgfx: Fix a bad merge in otable batch takedown
Date:   Mon, 26 Jul 2021 17:37:01 +0200
Message-Id: <20210726153847.203796851@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

[ Upstream commit 34bd46bcf3de72cbffcdc42d3fa67e543d1c869b ]

Change
2ef4fb92363c ("drm/vmwgfx: Make sure bo's are unpinned before putting them back")
caused a conflict in one of the drm trees and the merge commit
68a32ba14177 ("Merge tag 'drm-next-2021-04-28' of git://anongit.freedesktop.org/drm/drm")
accidently re-added code that the original change was removing.
Fixed by removing the incorrect buffer unpin - it has already been unpinned
two lines above.

Fixes: 68a32ba14177 ("Merge tag 'drm-next-2021-04-28' of git://anongit.freedesktop.org/drm/drm")
Signed-off-by: Zack Rusin <zackr@vmware.com>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210615182336.995192-4-zackr@vmware.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_mob.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c b/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
index 5648664f71bc..f2d625415458 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
@@ -354,7 +354,6 @@ static void vmw_otable_batch_takedown(struct vmw_private *dev_priv,
 	ttm_bo_unpin(bo);
 	ttm_bo_unreserve(bo);
 
-	ttm_bo_unpin(batch->otable_bo);
 	ttm_bo_put(batch->otable_bo);
 	batch->otable_bo = NULL;
 }
-- 
2.30.2



