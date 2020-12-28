Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088B62E3CA4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437552AbgL1OFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:05:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437541AbgL1OFD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:05:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A0A5205CB;
        Mon, 28 Dec 2020 14:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164287;
        bh=Q6ZCDaGj87pPJkIhVCl1IhNw+CYWZe+1Srtr4DHkC2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iHuB1cr2m/Xo+n2XKgC4WLmC4nE/GB3zNzYSN/CNlCdXaqk7u4g7y9B3iSPcYZKfm
         KVVaUwmfizxvqYK3UJmx5l4fIWqCLE6gr+L7be4UEJft9pl15LS7yRTNylCXkvpu8v
         q09wIJqzCCBmV9rHhvfWOtYnzPxmTTYUZvXtUs14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/717] drm/udl: Fix missing error code in udl_handle_damage()
Date:   Mon, 28 Dec 2020 13:41:48 +0100
Message-Id: <20201228125026.226024488@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit a7319c8f50c5e93a12997e2d0821a2f7946fb734 ]

If udl_get_urb() fails then this should return a negative error code
but currently it returns success.

Fixes: 798ce3fe1c3a ("drm/udl: Begin/end access to imported buffers in damage-handler")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20201113101502.GD168908@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/udl/udl_modeset.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/udl/udl_modeset.c b/drivers/gpu/drm/udl/udl_modeset.c
index fef43f4e3bac4..edcfd8c120c44 100644
--- a/drivers/gpu/drm/udl/udl_modeset.c
+++ b/drivers/gpu/drm/udl/udl_modeset.c
@@ -303,8 +303,10 @@ static int udl_handle_damage(struct drm_framebuffer *fb, int x, int y,
 	}
 
 	urb = udl_get_urb(dev);
-	if (!urb)
+	if (!urb) {
+		ret = -ENOMEM;
 		goto out_drm_gem_shmem_vunmap;
+	}
 	cmd = urb->transfer_buffer;
 
 	for (i = clip.y1; i < clip.y2; i++) {
-- 
2.27.0



