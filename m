Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDFD21E58B
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 04:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbgGNCRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 22:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgGNCRy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jul 2020 22:17:54 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C84FC061755
        for <stable@vger.kernel.org>; Mon, 13 Jul 2020 19:17:54 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z15so19344818wrl.8
        for <stable@vger.kernel.org>; Mon, 13 Jul 2020 19:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=yIvsoqIpU7YuxmuFEhotjfR8B82cxw6wItzsKtbJuqM=;
        b=SW6yBePs7xOC7cXsFyAdunMnAKXHnXUNwR/t5Y+otvk1j1CuS8G/hIGv+zKVtE/CNM
         N4CNi0Lp51J60V+5JLzv15NydvTDuwQItk/3fgi5Fe+iiETzkamURDYLY6Fm0rvWz7ET
         LDor2WeRgYsfFhRCN4dyF6KiYjUE9BNr9Wo1HZ1mSLZ5XmxNPMBdWurU14yNTOS3NvRa
         im/TYqUDwAalrAccMs/lJHTr+LElBt0PmMvyxVIGeIDWtq2fBx4M0Rn5EgCcddZGaG5P
         JJGQThUKKcZtXJn434XNtnJZlE0QEzOv5S80PUCdblT0V0/cJ0CjPCzurIOhmoEsHA+6
         DsBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yIvsoqIpU7YuxmuFEhotjfR8B82cxw6wItzsKtbJuqM=;
        b=YYVy9/89KBBfdixdw/1l1lbCZdmj1m3PiMYDGqYX4Eh9wUfXw0Z54NFYptkpy0Boz8
         y0NWr4wpLALNi3wkTunKCthNhtJOtR4gnd9IKsYdszH9X7y04+0WX6vSYODak2IzevtU
         nGmlPm+3P2qpLNilVsceaGlr6WIZHTMn83LWlBycUv54LL1SMLcvWZaMkX7mos02UTe+
         wyS5+MjVEDqgMR8WyHTLEREjKCxe5JatpWPV7VixbQEg0HDAkUw88F4v43/RHQuz1Kq/
         0i2Q7jxDVRx4jRJLTt6GEzKz1kQ+Hwjut7/F2RCjvq/6LSlPulK4Lp9hDVLkjsn+9UeV
         pMbg==
X-Gm-Message-State: AOAM5316OVpkUoXl/NSZ3QAXQkAM80i+uw0licPJtUQYgmvkI0FZaF58
        7Eya50Meals1w064ZgMBy6c=
X-Google-Smtp-Source: ABdhPJzsEDTbjlrUS5ovEXyY5WohVHmpV0Walb/bXxD/VYxToimEHBcU+aeaNhnZcngpOMWWKBnA9A==
X-Received: by 2002:a5d:4002:: with SMTP id n2mr2519709wrp.255.1594693072972;
        Mon, 13 Jul 2020 19:17:52 -0700 (PDT)
Received: from sroland-t5810.vmware.com (46-126-183-173.dynamic.hispeed.ch. [46.126.183.173])
        by smtp.gmail.com with ESMTPSA id z63sm2255072wmb.2.2020.07.13.19.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 19:17:52 -0700 (PDT)
From:   "Roland Scheidegger (VMware)" <rscheidegger.oss@gmail.com>
To:     dri-devel@lists.freedesktop.org, airlied@redhat.com,
        daniel@ffwll.ch
Cc:     linux-graphics-maintainer@vmware.com,
        Roland Scheidegger <sroland@vmware.com>, stable@vger.kernel.org
Subject: [PATCH] drm/vmwgfx: fix update of display surface when resolution changes
Date:   Tue, 14 Jul 2020 04:17:47 +0200
Message-Id: <20200714021747.11151-1-rscheidegger.oss@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roland Scheidegger <sroland@vmware.com>

The assignment of metadata overwrote the new display resolution values,
hence we'd miss the size actually changed and wouldn't redefine the
surface. This would then lead to command buffer error when trying to
update the screen target (due to the size mismatch), and result in a
VM with black screen.

Fixes: 504901dbb0b5 ("drm/vmwgfx: Refactor surface_define to use vmw_surface_metadata")
Reviewed-by: Charmaine Lee <charmainel@vmware.com>
Signed-off-by: Roland Scheidegger <sroland@vmware.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c b/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c
index 9ffa9c75a5da..16b385629688 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c
@@ -1069,10 +1069,6 @@ vmw_stdu_primary_plane_prepare_fb(struct drm_plane *plane,
 	if (new_content_type != SAME_AS_DISPLAY) {
 		struct vmw_surface_metadata metadata = {0};
 
-		metadata.base_size.width = hdisplay;
-		metadata.base_size.height = vdisplay;
-		metadata.base_size.depth = 1;
-
 		/*
 		 * If content buffer is a buffer object, then we have to
 		 * construct surface info
@@ -1104,6 +1100,10 @@ vmw_stdu_primary_plane_prepare_fb(struct drm_plane *plane,
 			metadata = new_vfbs->surface->metadata;
 		}
 
+		metadata.base_size.width = hdisplay;
+		metadata.base_size.height = vdisplay;
+		metadata.base_size.depth = 1;
+
 		if (vps->surf) {
 			struct drm_vmw_size cur_base_size =
 				vps->surf->metadata.base_size;
-- 
2.17.1

