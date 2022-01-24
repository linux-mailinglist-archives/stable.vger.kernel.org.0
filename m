Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629A349A4E2
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387641AbiAYAFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1839672AbiAXX2d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:28:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A79AC075955;
        Mon, 24 Jan 2022 13:34:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BAD061305;
        Mon, 24 Jan 2022 21:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103CCC340E4;
        Mon, 24 Jan 2022 21:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060047;
        bh=+gYox5gfMlmqNO1wkoe6FTEVu8N04dhY/8LJMhA6gtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AymDe3G0Zu2Myo6385zcKsllOXyiZ0Lj5vMfSmzGpX+gyatf+5k3u9LE8dFYNkZNs
         5UrlDzct1VoLPqMKUFGfbY0jWNEf/DgjX5hb8zPTEB9I7LmZfFZB988lBJ5IWgif8y
         IXA3a84r+kbABDKJW1ifVEH1IIkwb6B+LAdNbXWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0821/1039] drm/amd/display: invalid parameter check in dmub_hpd_callback
Date:   Mon, 24 Jan 2022 19:43:30 +0100
Message-Id: <20220124184152.897816208@linuxfoundation.org>
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

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit 978ffac878fd64039f95798b15b430032d2d89d5 ]

The function performs a check on the "adev" input parameter, however, it
is used before the check.

Initialize the "dev" variable after the sanity check to avoid a possible
NULL pointer dereference.

Fixes: e27c41d5b0681 ("drm/amd/display: Support for DMUB HPD interrupt handling")
Addresses-Coverity-ID: 1493909 ("Null pointer dereference")
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 46d38d528468c..3a227e9d8dfcb 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -656,7 +656,7 @@ void dmub_hpd_callback(struct amdgpu_device *adev, struct dmub_notification *not
 	struct drm_connector_list_iter iter;
 	struct dc_link *link;
 	uint8_t link_index = 0;
-	struct drm_device *dev = adev->dm.ddev;
+	struct drm_device *dev;
 
 	if (adev == NULL)
 		return;
@@ -673,6 +673,7 @@ void dmub_hpd_callback(struct amdgpu_device *adev, struct dmub_notification *not
 
 	link_index = notify->link_index;
 	link = adev->dm.dc->links[link_index];
+	dev = adev->dm.ddev;
 
 	drm_connector_list_iter_begin(dev, &iter);
 	drm_for_each_connector_iter(connector, &iter) {
-- 
2.34.1



