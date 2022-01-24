Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0B4499FCA
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842165AbiAXXBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356728AbiAXWjp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:39:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93847C04D603;
        Mon, 24 Jan 2022 13:03:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 308F861330;
        Mon, 24 Jan 2022 21:03:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9357EC340E5;
        Mon, 24 Jan 2022 21:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058183;
        bh=tdR6gKGncBF3HjpyNtIxUyGnEF9+TBf9ZeYEJNJWJGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ECPMU5fji+WrdDHg7lKG0e8/5B4AMPJ0QfqADSom+zfv/VvRMGU20X7jG6Uh/KAUx
         e9Zx76ndavY07+d/U9PlW9iO+sN6S+55K/ihY1meA0DSAYlw912dkdnyawmY0GXvP/
         NgSAhF24biT5DyqtBKloD//6gVqsgSwLW5migUiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zack Rusin <zackr@vmware.com>,
        Martin Krastev <krastevm@vmware.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0207/1039] drm/vmwgfx: Fail to initialize on broken configs
Date:   Mon, 24 Jan 2022 19:33:16 +0100
Message-Id: <20220124184132.284995393@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

[ Upstream commit c451af78f301ff5156998d571c37cab329c10051 ]

Some of our hosts have a bug where rescaning a pci bus results in stale
fifo memory being mapped on the host. This makes any fifo communication
impossible resulting in various kernel crashes.

Instead of unexpectedly crashing, predictably fail to load the driver
which will preserve the system.

Fixes: fb1d9738ca05 ("drm/vmwgfx: Add DRM driver for VMware Virtual GPU")
Signed-off-by: Zack Rusin <zackr@vmware.com>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211105193845.258816-4-zackr@vmware.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c b/drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c
index 67db472d3493c..a3bfbb6c3e14a 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c
@@ -145,6 +145,13 @@ struct vmw_fifo_state *vmw_fifo_create(struct vmw_private *dev_priv)
 		 (unsigned int) max,
 		 (unsigned int) min,
 		 (unsigned int) fifo->capabilities);
+
+	if (unlikely(min >= max)) {
+		drm_warn(&dev_priv->drm,
+			 "FIFO memory is not usable. Driver failed to initialize.");
+		return ERR_PTR(-ENXIO);
+	}
+
 	return fifo;
 }
 
-- 
2.34.1



