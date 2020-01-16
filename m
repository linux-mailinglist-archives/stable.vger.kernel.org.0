Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2613A13F7F6
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733174AbgAPQ4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:56:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:42212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733171AbgAPQ4K (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:56:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A63224686;
        Thu, 16 Jan 2020 16:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193769;
        bh=RIPQ/q5w8QJUc7C++E2s9w8BI6DlcJ5VsmgrPh46V6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EHIpG+AmDsudX1Hz9Pt/lmSD2oy4xRhM+QkiOE5wLBmUIzhE/OOg6XUeXIcbF1TiO
         6Te3ZIViGyxPhh4YP7F/gzUPPfWPoeRKe3uruS1dAuVkhfBFwZsuUOZ6a5CDNyAPLZ
         eRgMJAnvRc9hFjKjlwEuyXHpZFpMx1Ga7LjOoIkU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 053/671] drm: rcar-du: Fix the return value in case of error in 'rcar_du_crtc_set_crc_source()'
Date:   Thu, 16 Jan 2020 11:44:44 -0500
Message-Id: <20200116165502.8838-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 4d486f18d91b1876040bf87e9ad78981a08b15a6 ]

We return 0 unconditionally in 'rcar_du_crtc_set_crc_source()'.
However, 'ret' is set to some error codes if some function calls fail.

Return 'ret' instead to propagate the error code.

Fixes: 47a52d024e89 ("media: drm: rcar-du: Add support for CRC computation")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index 15dc9caa128b..212e5e11e4b7 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -837,7 +837,7 @@ static int rcar_du_crtc_set_crc_source(struct drm_crtc *crtc,
 	drm_modeset_drop_locks(&ctx);
 	drm_modeset_acquire_fini(&ctx);
 
-	return 0;
+	return ret;
 }
 
 static const struct drm_crtc_funcs crtc_funcs_gen2 = {
-- 
2.20.1

