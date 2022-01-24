Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B5549A937
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322321AbiAYDVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:21:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45116 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237962AbiAXUSt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:18:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16F72614E2;
        Mon, 24 Jan 2022 20:18:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3C3C340E5;
        Mon, 24 Jan 2022 20:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055527;
        bh=tdR6gKGncBF3HjpyNtIxUyGnEF9+TBf9ZeYEJNJWJGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OuVQYo0JdcblwU4VkhqMQBpPpYOhlIOug6j8jP019JAIF2ijaadX4mnP3A/HuQzqI
         +PJAPKWUf4xRMo0THIx+qByEYbpaosWhoOW9orrpJhIkaBUzNfktFGvYf5/UolqxeX
         b9+QfUnOd+XIwoAVNLR3c8uc3tt3SUq9tD6qYu5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zack Rusin <zackr@vmware.com>,
        Martin Krastev <krastevm@vmware.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 179/846] drm/vmwgfx: Fail to initialize on broken configs
Date:   Mon, 24 Jan 2022 19:34:56 +0100
Message-Id: <20220124184107.157187763@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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



