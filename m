Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 615A02F202
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729460AbfE3ERk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:17:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730410AbfE3DPj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:39 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EA1B2459C;
        Thu, 30 May 2019 03:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186138;
        bh=b/IinIURLaCTrdzZikqrms9DNQ+ATXm92QGfCHzVu7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cLvR1yEmVOCx/5XAA3cd1g/s+OITnM8ig1OMYvSlW3DErqARE9SUsPbxdw/NyLbKN
         2/5xGSAq2zEa6N1aa+DI8CkRhZWSuH7nwH8pLBe8p2XtfoiG7bDiyO5rGs/diXQvi/
         ovhRJQgrUIKYmYdumJ5dn20LvsrP8R5/b3GPPWLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Sun peng Li <Sunpeng.Li@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 303/346] drm/amd/display: Set stream->mode_changed when connectors change
Date:   Wed, 29 May 2019 20:06:16 -0700
Message-Id: <20190530030556.187855921@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b9952f93cd2cf5fca82b06a8179c0f5f7b769e83 ]

[Why]
The kms_plane@plane-position-covered-pipe-*-planes subtests can produce
a sequence of atomic commits such that neither active_changed nor
mode_changed but connectors_changed.

When this happens we remove the old stream from the context and add
a new stream but the new stream doesn't have mode_changed=true set.

This incorrect programming sequence causes CRC mismatches to occur in
the test.

The stream->mode_changed value should be set whenever a new stream
is created.

[How]
A new stream is created whenever drm_atomic_crtc_needs_modeset is true.
We previously covered the active_changed and mode_changed conditions
for the CRTC but connectors_changed is also checked within
drm_atomic_crtc_needs_modeset.

So just use drm_atomic_crtc_needs_modeset directly to determine the
mode_changed flag.

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Sun peng Li <Sunpeng.Li@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index e766dede5b472..864c2faf672bd 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4978,8 +4978,7 @@ static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
 static void amdgpu_dm_crtc_copy_transient_flags(struct drm_crtc_state *crtc_state,
 						struct dc_stream_state *stream_state)
 {
-	stream_state->mode_changed =
-		crtc_state->mode_changed || crtc_state->active_changed;
+	stream_state->mode_changed = drm_atomic_crtc_needs_modeset(crtc_state);
 }
 
 static int amdgpu_dm_atomic_commit(struct drm_device *dev,
-- 
2.20.1



