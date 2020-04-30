Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07C01BFD5E
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 16:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgD3NvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:51:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727906AbgD3NvI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:51:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B0562137B;
        Thu, 30 Apr 2020 13:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254667;
        bh=PQO2qszkR2ZOJGdXJ9WPdFL9T2v4oNVLb9SEfQ0GBfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LaVjopSsE41AZx8PuqKNVTBlNfy7BvBJFIcAw2sbOTRijv7IQvuqySAWal04CSaxH
         1xvcKsNJrm6LhUER3goWj0BVw3xIgoMyMiR16kz7V3o9Bl0oWElMr5GNocnFOI28Y2
         FdTizDNNc2XEKVcz2OcysdZ+lPTccT4sduTeh05w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Khoruzhick <anarsoul@gmail.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.6 20/79] drm/bridge: anx6345: set correct BPC for display_info of connector
Date:   Thu, 30 Apr 2020 09:49:44 -0400
Message-Id: <20200430135043.19851-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Khoruzhick <anarsoul@gmail.com>

[ Upstream commit 1e8a6ce9186dbf342eebc07cf14cae5e82164e03 ]

Some drivers (e.g. sun4i-drm) need this info to decide whether they
need to enable dithering. Currently driver reports what panel supports
and if panel supports 8 we don't get dithering enabled.

Hardcode BPC to 6 for now since that's the only BPC
that driver supports.

Fixes: 6aa192698089 ("drm/bridge: Add Analogix anx6345 support")
Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Acked-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20200329222253.2941405-1-anarsoul@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/analogix-anx6345.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/bridge/analogix/analogix-anx6345.c b/drivers/gpu/drm/bridge/analogix/analogix-anx6345.c
index 526507102c1ea..8d32fea84c75e 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix-anx6345.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix-anx6345.c
@@ -485,6 +485,9 @@ static int anx6345_get_modes(struct drm_connector *connector)
 
 	num_modes += drm_add_edid_modes(connector, anx6345->edid);
 
+	/* Driver currently supports only 6bpc */
+	connector->display_info.bpc = 6;
+
 unlock:
 	if (power_off)
 		anx6345_poweroff(anx6345);
-- 
2.20.1

