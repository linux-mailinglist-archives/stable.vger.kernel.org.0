Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C49211DF9
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbfEBPat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727377AbfEBPas (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:30:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D400F2081C;
        Thu,  2 May 2019 15:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811048;
        bh=IntiuBaH0skzQDjeZ66JasE10npj0bxke5OBWuHmkHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C1VhgK7waMZtlko34Om3Mo59luppuqQf3W1UgK4Lo9nHkdUdmzRhdrkfI6fwxZKA8
         /pnTPVXvoJXxyK3D/lFIw30uj0TQI2nkgRRTVl8roiEI7K2CipBlQ/MB5V6+/9e6SJ
         O+Q29GKb6BsZTEoy06buGwWvqYWr5NZXyGkXLk2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Thierry Reding <treding@nvidia.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 054/101] drm/tegra: hub: Fix dereference before check
Date:   Thu,  2 May 2019 17:20:56 +0200
Message-Id: <20190502143343.285843755@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7cf77b273a8fc51e7de622fa6691abd4436a9a6b ]

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/hub.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/hub.c b/drivers/gpu/drm/tegra/hub.c
index 922a48d5a483..c7c612579270 100644
--- a/drivers/gpu/drm/tegra/hub.c
+++ b/drivers/gpu/drm/tegra/hub.c
@@ -378,14 +378,16 @@ static int tegra_shared_plane_atomic_check(struct drm_plane *plane,
 static void tegra_shared_plane_atomic_disable(struct drm_plane *plane,
 					      struct drm_plane_state *old_state)
 {
-	struct tegra_dc *dc = to_tegra_dc(old_state->crtc);
 	struct tegra_plane *p = to_tegra_plane(plane);
+	struct tegra_dc *dc;
 	u32 value;
 
 	/* rien ne va plus */
 	if (!old_state || !old_state->crtc)
 		return;
 
+	dc = to_tegra_dc(old_state->crtc);
+
 	/*
 	 * XXX Legacy helpers seem to sometimes call ->atomic_disable() even
 	 * on planes that are already disabled. Make sure we fallback to the
-- 
2.19.1



