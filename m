Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDA33C4DBE
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241508AbhGLHOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:14:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241750AbhGLHNG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:13:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B60AB61179;
        Mon, 12 Jul 2021 07:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073815;
        bh=kiDMrShGhA9MsP0ZNDM+Q9R8acrvqw2qcS06gIeaqX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mnpYhMH43uC8LRCJM0ferfUNXtnjlewQLMJhMf0/chc65aJShMKmJrNUIRCL+z0tK
         smZZ7zhmU+Z4pV2ryd5bJVur7tcTKTtASNSOg0r3n6mPV7c9X3CpA5PLY4VLYBapXw
         +8MsTxOn+lEzMjdEfItYeSwVAKV2gZDoHtJzOL8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhan Liu <zhan.liu@amd.com>,
        Nikola Cornij <nikola.cornij@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 369/700] drm/amd/display: Avoid HPD IRQ in GPU reset state
Date:   Mon, 12 Jul 2021 08:07:32 +0200
Message-Id: <20210712061015.649255901@linuxfoundation.org>
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

From: Zhan Liu <zhan.liu@amd.com>

[ Upstream commit 509b9a5b4865dee723296f143695a7774fc96c4a ]

[Why]
If GPU is in reset state, force enabling link will cause
unexpected behaviour.

[How]
Avoid handling HPD IRQ when GPU is in reset state.

Signed-off-by: Zhan Liu <zhan.liu@amd.com>
Reviewed-by: Nikola Cornij <nikola.cornij@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index d95569e0e53a..61337d4c0bb2 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2624,15 +2624,15 @@ static void handle_hpd_rx_irq(void *param)
 		}
 	}
 
-	if (!amdgpu_in_reset(adev))
+	if (!amdgpu_in_reset(adev)) {
 		mutex_lock(&adev->dm.dc_lock);
 #ifdef CONFIG_DRM_AMD_DC_HDCP
 	result = dc_link_handle_hpd_rx_irq(dc_link, &hpd_irq_data, NULL);
 #else
 	result = dc_link_handle_hpd_rx_irq(dc_link, NULL, NULL);
 #endif
-	if (!amdgpu_in_reset(adev))
 		mutex_unlock(&adev->dm.dc_lock);
+	}
 
 out:
 	if (result && !is_mst_root_connector) {
-- 
2.30.2



