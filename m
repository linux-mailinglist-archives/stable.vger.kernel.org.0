Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841963C4DBD
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240708AbhGLHOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:14:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241766AbhGLHNB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:13:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D630761132;
        Mon, 12 Jul 2021 07:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073812;
        bh=Ix9/zcKoy7BIBKCHzKGocvecCkbEtmdiGceJiXA6MVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=arV4a7ZpcBeY0uI4emy8YZEf2BWudaZSNNPnOr5Or2J8aJ8cA6gh37UE6RIOgdBNw
         0T/Z/WZkcIC2/g2IT5xf1PuINUkOS4/8qLABgmHYl8/hyG+eSoun/vIF1yDUMCbnEC
         yX6HX3bLD1cUSGl0i6VR1sprANSUbDhwv6VU7VxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lang Yu <Lang.Yu@amd.com>,
        Roman Li <Roman.Li@amd.com>,
        Qingqing Zhuo <Qingqing.Zhuo@amd.com>,
        Wayne Lin <Wayne.Lin@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 368/700] drm/amd/display: fix potential gpu reset deadlock
Date:   Mon, 12 Jul 2021 08:07:31 +0200
Message-Id: <20210712061015.544855284@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Li <Roman.Li@amd.com>

[ Upstream commit cf8b92a75646735136053ce51107bfa8cfc23191 ]

[Why]
In gpu reset dc_lock acquired in dm_suspend().
Asynchronously handle_hpd_rx_irq can also be called
through amdgpu_dm_irq_suspend->flush_work, which also
tries to acquire dc_lock. That causes a deadlock.

[How]
Check if amdgpu executing reset before acquiring dc_lock.

Signed-off-by: Lang Yu <Lang.Yu@amd.com>
Signed-off-by: Roman Li <Roman.Li@amd.com>
Reviewed-by: Qingqing Zhuo <Qingqing.Zhuo@amd.com>
Acked-by: Wayne Lin <Wayne.Lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index eed494630583..d95569e0e53a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2624,13 +2624,15 @@ static void handle_hpd_rx_irq(void *param)
 		}
 	}
 
-	mutex_lock(&adev->dm.dc_lock);
+	if (!amdgpu_in_reset(adev))
+		mutex_lock(&adev->dm.dc_lock);
 #ifdef CONFIG_DRM_AMD_DC_HDCP
 	result = dc_link_handle_hpd_rx_irq(dc_link, &hpd_irq_data, NULL);
 #else
 	result = dc_link_handle_hpd_rx_irq(dc_link, NULL, NULL);
 #endif
-	mutex_unlock(&adev->dm.dc_lock);
+	if (!amdgpu_in_reset(adev))
+		mutex_unlock(&adev->dm.dc_lock);
 
 out:
 	if (result && !is_mst_root_connector) {
-- 
2.30.2



