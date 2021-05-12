Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0406A37CD75
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238735AbhELQzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:55:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243943AbhELQmQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8EF961995;
        Wed, 12 May 2021 16:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835714;
        bh=U6S1cZLFZes/sUajWddIUgxUcYmDskAwuS9uOF/ghuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDU5F88WxK7hDAZmyawOWNOYgzuq5aiHHbLs83YDWCt61T4quniWKlfq+oduy7jmK
         WYOeyh8bdN0KkLySXxeZD4yCfdbe/bL9fmWc5milPvM4c1ZsDVoMf95fHSrrSwBue6
         ChPbtwjU+Ybcf+KHujhgiAxRNHqkko3oY9Vk3eJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yingjie Wang <wangyingjie55@126.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 410/677] drm/radeon: Fix a missing check bug in radeon_dp_mst_detect()
Date:   Wed, 12 May 2021 16:47:36 +0200
Message-Id: <20210512144850.961183586@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yingjie Wang <wangyingjie55@126.com>

[ Upstream commit 25315ebfaefcffd126a266116b37bb8a3d1c4620 ]

In radeon_dp_mst_detect(), We should check whether or not @connector
has been unregistered from userspace. If the connector is unregistered,
we should return disconnected status.

Fixes: 9843ead08f18 ("drm/radeon: add DisplayPort MST support (v2)")
Signed-off-by: Yingjie Wang <wangyingjie55@126.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_dp_mst.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_dp_mst.c b/drivers/gpu/drm/radeon/radeon_dp_mst.c
index 2c32186c4acd..4e4c937c36c6 100644
--- a/drivers/gpu/drm/radeon/radeon_dp_mst.c
+++ b/drivers/gpu/drm/radeon/radeon_dp_mst.c
@@ -242,6 +242,9 @@ radeon_dp_mst_detect(struct drm_connector *connector,
 		to_radeon_connector(connector);
 	struct radeon_connector *master = radeon_connector->mst_port;
 
+	if (drm_connector_is_unregistered(connector))
+		return connector_status_disconnected;
+
 	return drm_dp_mst_detect_port(connector, ctx, &master->mst_mgr,
 				      radeon_connector->port);
 }
-- 
2.30.2



