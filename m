Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8DD2F4D6
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728948AbfE3DMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:12:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728935AbfE3DMS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:18 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 856A7244D4;
        Thu, 30 May 2019 03:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185937;
        bh=n5kjA7fjbOwqd5N27ytYvPLS2ALxClmy4UA9vMmx6Oc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IwB42shWgQqL01jbE5OMNPkTBM37wxqSEBJ22y2gvjeoTUYMUOxEdYD8ZBd3e6b4V
         NuayEhYKwHLwp6VyeO5uxt5VTd07fvi7ICUoz5meb5n9dmVY6ExKD3CH1XlwXggKcF
         lkIDlPueMSims2Pqr2rAoqH/pjw9c5Hdz9HOlPRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Francis <David.Francis@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 332/405] drm/amd/display: Update ABM crtc state on non-modeset
Date:   Wed, 29 May 2019 20:05:30 -0700
Message-Id: <20190530030557.522308546@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b05e2c5e81f9a0be4a145e0926b1dfe62f6347d4 ]

[Why]
Somewhere in the atomic check reshuffle ABM got lost.
ABM is a crtc property (copied from a connector property).
It can change without a modeset, just like underscan.

[How]
In the skip_modeset branch of atomic check crtc updates,
copy over the abm property.

Signed-off-by: David Francis <David.Francis@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 66f19d1864b17..c212bff457eec 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5661,6 +5661,9 @@ static int dm_update_crtc_state(struct amdgpu_display_manager *dm,
 		update_stream_scaling_settings(
 			&new_crtc_state->mode, dm_new_conn_state, dm_new_crtc_state->stream);
 
+	/* ABM settings */
+	dm_new_crtc_state->abm_level = dm_new_conn_state->abm_level;
+
 	/*
 	 * Color management settings. We also update color properties
 	 * when a modeset is needed, to ensure it gets reprogrammed.
-- 
2.20.1



