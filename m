Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 986F7BCF0D
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441485AbfIXQup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:50:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436877AbfIXQuo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:50:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF712217D9;
        Tue, 24 Sep 2019 16:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343843;
        bh=GJpHzJ+qn9OcaCR4TCj1pJRC+9xWdaPTJJuPR71IuUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gOgvyFgZ+N1oDyUAPv5OMhTYPHY66F54BaDZllmWq8RgC1dDi+h2tC7XSdYS7Mufa
         fageKeqDyU96GU5fDV9oviwr20P2bC1R5ibpqKAAyP/BYkacNHBAMBaRAk7ZRXK5a0
         6+OmvHnzkrXkujvS8HgHbkgOtdI93aWDwryZxC6Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 07/28] gpu: drm: radeon: Fix a possible null-pointer dereference in radeon_connector_set_property()
Date:   Tue, 24 Sep 2019 12:50:10 -0400
Message-Id: <20190924165031.28292-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924165031.28292-1-sashal@kernel.org>
References: <20190924165031.28292-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit f3eb9b8f67bc28783eddc142ad805ebdc53d6339 ]

In radeon_connector_set_property(), there is an if statement on line 743
to check whether connector->encoder is NULL:
    if (connector->encoder)

When connector->encoder is NULL, it is used on line 755:
    if (connector->encoder->crtc)

Thus, a possible null-pointer dereference may occur.

To fix this bug, connector->encoder is checked before being used.

This bug is found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_connectors.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index 337d3a1c2a409..48f752cf7a920 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -764,7 +764,7 @@ static int radeon_connector_set_property(struct drm_connector *connector, struct
 
 		radeon_encoder->output_csc = val;
 
-		if (connector->encoder->crtc) {
+		if (connector->encoder && connector->encoder->crtc) {
 			struct drm_crtc *crtc  = connector->encoder->crtc;
 			struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
 
-- 
2.20.1

