Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C7060D9E7
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 05:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbiJZD3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 23:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233062AbiJZD2u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 23:28:50 -0400
X-Greylist: delayed 475 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 25 Oct 2022 20:27:41 PDT
Received: from letterbox.kde.org (letterbox.kde.org [46.43.1.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4048FB1B9E
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 20:27:40 -0700 (PDT)
Received: from vertex.vmware.com (pool-173-49-113-140.phlapa.fios.verizon.net [173.49.113.140])
        (Authenticated sender: zack)
        by letterbox.kde.org (Postfix) with ESMTPSA id 3E0AF33EED7;
        Wed, 26 Oct 2022 04:19:42 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kde.org; s=users;
        t=1666754382; bh=rLcRBlFtnycp2Ot8P0Rw01e7OkeY9qq3dLBVts+e23k=;
        h=From:To:Cc:Subject:Date:From;
        b=MKeNxq/S6Fvjt9wheVtEdvhZOHL6x5bHrmr+4gdkWvIBwm+GB08Wha/Ef8+8pEnDg
         K0/S2+rSf3bwVOBDG1FAgVHnBTjyK8qb7fr5A3a1zzQjsGZFTEuDctHM3PSjKlyCII
         B+Blh+sywbGK8plRAjsWyQV3TGa1TfKHq5mJTKBm+i2o35aA7tnY0Dz3nrRl+xo0eQ
         rNvcrbFI8qjn/w8gLWoEN31eThoe/hWxajjrDZ+aTAlm9MGbSREjxojV3lqRKfscJx
         WFlUddVWGJdf3eHEnbSemtXBXQprSOB02bS42+QuqAmc8EPNpiKj7yzKFCZPeibRvx
         Fbnk0cgaDdvmA==
From:   Zack Rusin <zack@kde.org>
To:     dri-devel@lists.freedesktop.org
Cc:     krastevm@vmware.com, mombasawalam@vmware.com, banackm@vmware.com,
        Zack Rusin <zackr@vmware.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] drm/vmwgfx: Validate the box size for the snooped cursor
Date:   Tue, 25 Oct 2022 23:19:35 -0400
Message-Id: <20221026031936.1004280-1-zack@kde.org>
X-Mailer: git-send-email 2.34.1
Reply-To: Zack Rusin <zackr@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

Invalid userspace dma surface copies could potentially overflow
the memcpy from the surface to the snooped image leading to crashes.
To fix it the dimensions of the copybox have to be validated
against the expected size of the snooped cursor.

Signed-off-by: Zack Rusin <zackr@vmware.com>
Fixes: 2ac863719e51 ("vmwgfx: Snoop DMA transfers with non-covering sizes")
Cc: <stable@vger.kernel.org> # v3.2+
Reviewed-by: Michael Banack <banackm@vmware.com>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 0342efdf9063..d434b6ae1092 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -393,7 +393,8 @@ void vmw_kms_cursor_snoop(struct vmw_surface *srf,
 	if (cmd->dma.guest.ptr.offset % PAGE_SIZE ||
 	    box->x != 0    || box->y != 0    || box->z != 0    ||
 	    box->srcx != 0 || box->srcy != 0 || box->srcz != 0 ||
-	    box->d != 1    || box_count != 1) {
+	    box->d != 1    || box_count != 1 ||
+	    box->w > 64 || box->h > 64) {
 		/* TODO handle none page aligned offsets */
 		/* TODO handle more dst & src != 0 */
 		/* TODO handle more then one copy */
-- 
2.34.1

