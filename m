Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5693324B3FC
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbgHTJzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:55:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730182AbgHTJzE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:55:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F60F2067C;
        Thu, 20 Aug 2020 09:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917303;
        bh=OQ5gB70SunnoGAffLgoSQDAhBIGDZetpQ3oM1WKZpYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P9fuko200WgZutsoWJ6rvsPoA0TXVc94UUkGEpcR8HO032NMU/bmvIa4XsBSvdCQF
         /10xSp+zclEeLfyiEJGIgJpIn0NEBkhwoT2uq3+1BHxHMJtuda+2GLToMqz/BvkYit
         6Y8D1fjMChm0ELqCzjbxXWxjdAg54uqLiJ7lvslE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Roland Scheidegger <sroland@vmware.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 74/92] drm/vmwgfx: Use correct vmw_legacy_display_unit pointer
Date:   Thu, 20 Aug 2020 11:21:59 +0200
Message-Id: <20200820091541.525191966@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 1d2c0c565bc0da25f5e899a862fb58e612b222df ]

The "entry" pointer is an offset from the list head and it doesn't
point to a valid vmw_legacy_display_unit struct.  Presumably the
intent was to point to the last entry.

Also the "i++" wasn't used so I have removed that as well.

Fixes: d7e1958dbe4a ("drm/vmwgfx: Support older hardware.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Roland Scheidegger <sroland@vmware.com>
Signed-off-by: Roland Scheidegger <sroland@vmware.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c b/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c
index 7235781171912..0743a73117000 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c
@@ -79,7 +79,7 @@ static int vmw_ldu_commit_list(struct vmw_private *dev_priv)
 	struct vmw_legacy_display_unit *entry;
 	struct drm_framebuffer *fb = NULL;
 	struct drm_crtc *crtc = NULL;
-	int i = 0;
+	int i;
 
 	/* If there is no display topology the host just assumes
 	 * that the guest will set the same layout as the host.
@@ -90,12 +90,11 @@ static int vmw_ldu_commit_list(struct vmw_private *dev_priv)
 			crtc = &entry->base.crtc;
 			w = max(w, crtc->x + crtc->mode.hdisplay);
 			h = max(h, crtc->y + crtc->mode.vdisplay);
-			i++;
 		}
 
 		if (crtc == NULL)
 			return 0;
-		fb = entry->base.crtc.primary->state->fb;
+		fb = crtc->primary->state->fb;
 
 		return vmw_kms_write_svga(dev_priv, w, h, fb->pitches[0],
 					  fb->format->cpp[0] * 8,
-- 
2.25.1



