Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 424544735A
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 08:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbfFPGDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jun 2019 02:03:15 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46139 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfFPGDP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jun 2019 02:03:15 -0400
Received: by mail-pg1-f193.google.com with SMTP id v9so3923006pgr.13
        for <stable@vger.kernel.org>; Sat, 15 Jun 2019 23:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TDK5omkZRkNSyoFoWlD+WmwJ2JVCklQYvd60aVEP26M=;
        b=sAvmXMhTThxqS61OBsP2z9VyKff1pMJxmMjEVvf0ZsBWb1We0roFPnR/hN4OW/+fek
         XBfdrdSSudCReVOJb6auaR5LB1OAfjQiNHrOsWE76N35RWztIoNtsJj+k9NexKkWuyGa
         7pIlPm2vu6qSpDFDS6XnTh62Zl7TACmWVtF8uBy3po3s6vro9ew0npS2yCJsTIt1cZzV
         UWbZYUVA1A72QTqGTpg1QlUaiAmtPESNaji/XHG/xTa4Dyj9oaWF25iu5P5CleJ3tYiZ
         ehWy2fDCM2Lik0Y0MIuJkmQTLbCPOxVddyqOUL/A6n7tEMVIOc2a04ovfV5l+6TvWiir
         gHhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TDK5omkZRkNSyoFoWlD+WmwJ2JVCklQYvd60aVEP26M=;
        b=cS0UyJdFk65iNTg5wFlrTTNA8SzhEdG2cmV2kW9CphCNu0rNp8/9ooC/rCFhbktbTD
         ghVv55KABMBJY0TV4tsIA2Ob9iGzpXoz5EQ94t7JUHJzJW80TBExLKBK/xgNT3o44FS8
         w07Kou4zojE37ttnQpxxDdqEte+n3gWcU8jZfwVZ1kufQrUC9RGeuWIyV7lmuctwre3v
         bhsoGfI3vQqHBgdO2qDFgvDyhUzWnwyzNKH4kFpFEF8TzB3BRxrlGNCgkgdu7y1+PWfd
         daeLMWn/t3rmFiWF8elHCXjjhRS7WgVzMtevBBRyq+GxTiRx0Y/OqhBvF8GNemhbpPZ9
         1ePQ==
X-Gm-Message-State: APjAAAWUqW3TasMxk2RxF8DnqBDxAtcrLfqp6h8/yFD57/zdpoIite5H
        ttone3LRWOQAxqP6r3OhabbEnatuSLIBGw==
X-Google-Smtp-Source: APXvYqx/L/obYydcJSO2O6OckhH/H5/G+tqveqewJ5fxTd0hUWQGvlNu7F2n3WP1SOgME9m1JmXFDg==
X-Received: by 2002:a63:b90d:: with SMTP id z13mr39821460pge.16.1560664994841;
        Sat, 15 Jun 2019 23:03:14 -0700 (PDT)
Received: from localhost.localdomain (34.217.225.49.dyn.cust.vf.net.nz. [49.225.217.34])
        by smtp.gmail.com with ESMTPSA id e16sm11919898pga.11.2019.06.15.23.03.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 15 Jun 2019 23:03:14 -0700 (PDT)
From:   Murray McAllister <murray.mcallister@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-graphics-maintainer@vmware.com, thellstrom@vmware.com,
        murray.mcallister@gmail.com
Subject: [PATCH] Backport commit bcd6aa7b6cbf ("drm/vmwgfx: NULL pointer dereference from vmw_cmd_dx_view_define()") to linux-4.9-stable
Date:   Sun, 16 Jun 2019 18:02:35 +1200
Message-Id: <20190616060235.4853-1-murray.mcallister@gmail.com>
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

(The original patch failed to apply cleanly in 4.9-stable
as VMW_DEBUG_USER does not exist here.)

Signed-off-by: Murray McAllister <murray.mcallister@gmail.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index c7b53d987f06..1e44ac1d6fb3 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -2730,6 +2730,10 @@ static int vmw_cmd_dx_view_define(struct vmw_private *dev_priv,
 
 	view_type = vmw_view_cmd_to_type(header->id);
 	cmd = container_of(header, typeof(*cmd), header);
+	if (unlikely(cmd->sid == SVGA3D_INVALID_ID)) {
+		DRM_ERROR("Invalid surface id.\n");
+		return -EINVAL;
+	}
 	ret = vmw_cmd_res_check(dev_priv, sw_context, vmw_res_surface,
 				user_surface_converter,
 				&cmd->sid, &srf_node);
-- 
2.20.1

