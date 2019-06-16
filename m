Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD7247358
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 08:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbfFPGAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jun 2019 02:00:35 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34741 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfFPGAf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jun 2019 02:00:35 -0400
Received: by mail-pg1-f195.google.com with SMTP id p10so3956108pgn.1
        for <stable@vger.kernel.org>; Sat, 15 Jun 2019 23:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RlnkygF7AuFSdUpCZy0AhK94GmsrSDpJecQPHVXW9ek=;
        b=eMX+k3vjkC3Q9DJJOaYnpY0wp/mJBjE97yI9zkceg+iuibPcq6oa0UTJidVuKpBBeV
         KXD/SErIIwDqfEUREu+NNKDKLdbI/1PN9Z4zcgKqT8QOTt67Fkr6UeJXKzYRqOiC+UlI
         53jKjtCykiDmv6ptIRuD393+dB6+HcaUgHnFDepPophjfwCUJ6M++zW26ZSUvr2JIRRF
         fJami4n+vK1vV5eM+MfOSC9VXB+wB/KBFzNSKkHvxSdO/EpITe0Qz7wZN6FOh8oHkYpk
         sKvvEid9gsJkknWfA07/3Rp4YwY/H2w+pAX+5Nzl1jbEpEq6MQSkBbk+WZ4+oTDcDJan
         vD5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RlnkygF7AuFSdUpCZy0AhK94GmsrSDpJecQPHVXW9ek=;
        b=NuxqYvlRo/XS4DtScFlNbHMBWZBHfZSIu6GNzz9VEU3vOqEpn2+pdnMe/Zwsu3sAKt
         9Sq/tpVy/hY0EOKEfRXXKfH5yGvbeMIXYzdOQBgCFqQyaEXaqSgQQXfdDu5aFn/S+rov
         VY/wtDVXRQYkswQ8eNl82w9vquIJK9rd5mJBfoIX0mWESQrDCZ+KgZo9KOxRseZ9MLx4
         dMYkcwqQGopm4vCp8YLJEsMEravdWlhv2WaI+M/Vioqof2k1y1Ib9f9rQJiVPdujLQ0m
         iSYFzOUHFEjSc/MHopnT6TR5KzR7xRzyD0cTNSINYdicfc0x/Z+q+Qd3wEEoudB7wgtg
         D7kQ==
X-Gm-Message-State: APjAAAUihBlWgddsn4OkrOnPKK9JKv4NbQpH/2ABUA6/KGjY+1ld8nvu
        J7it+Wf9vkranfu9mjc44Gc/TSIer6Uwuw==
X-Google-Smtp-Source: APXvYqwd7bhFrRg86oRuysZfhhnoWZyJZlF9Ykn+MRa69r01mdIr2hWwuJOV13Q4u1ZjNixtmJFIJg==
X-Received: by 2002:a63:c94f:: with SMTP id y15mr43842078pgg.159.1560664834226;
        Sat, 15 Jun 2019 23:00:34 -0700 (PDT)
Received: from localhost.localdomain (34.217.225.49.dyn.cust.vf.net.nz. [49.225.217.34])
        by smtp.gmail.com with ESMTPSA id c69sm11853554pje.6.2019.06.15.23.00.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 15 Jun 2019 23:00:33 -0700 (PDT)
From:   Murray McAllister <murray.mcallister@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-graphics-maintainer@vmware.com, thellstrom@vmware.com,
        murray.mcallister@gmail.com
Subject: [PATCH] Backport commit bcd6aa7b6cbf ("drm/vmwgfx: NULL pointer dereference from vmw_cmd_dx_view_define()") to linux-5.1-stable
Date:   Sun, 16 Jun 2019 17:59:50 +1200
Message-Id: <20190616055950.4423-1-murray.mcallister@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit bcd6aa7b6cbf ("drm/vmwgfx: NULL pointer dereference
from vmw_cmd_dx_view_define()") upstream.

That commit resolved a NULL pointer dereference in vmw_view_add(),
which occurred if SVGA_3D_CMD_DX_DEFINE_RENDERTARGET_VIEW was
called with a surface ID of SVGA3D_INVALID_ID.

(The original patch failed to apply cleanly in 5.1-stable
as VMW_DEBUG_USER does not exist here.)

Signed-off-by: Murray McAllister <murray.mcallister@gmail.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 88b8178d4687..805442947143 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -2574,6 +2574,10 @@ static int vmw_cmd_dx_view_define(struct vmw_private *dev_priv,
 	if (view_type == vmw_view_max)
 		return -EINVAL;
 	cmd = container_of(header, typeof(*cmd), header);
+	if (unlikely(cmd->sid == SVGA3D_INVALID_ID)) {
+		DRM_ERROR("Invalid surface id.\n");
+		return -EINVAL;
+	}
 	ret = vmw_cmd_res_check(dev_priv, sw_context, vmw_res_surface,
 				user_surface_converter,
 				&cmd->sid, &srf);
-- 
2.20.1

