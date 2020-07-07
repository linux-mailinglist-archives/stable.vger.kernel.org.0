Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA3A217258
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbgGGPbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:31:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729894AbgGGPWk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:22:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B32F72065D;
        Tue,  7 Jul 2020 15:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135360;
        bh=hLB3XyH93zncgHdZnGjMXbexFAUNLhyNMxZ4vKjDV6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=reFaLGLBUyS1K0jA0Qt8llhrBI/qcSA59cre0bcADEA7YsMvo7u28PeoE5xDczU3+
         idhOzcca1iYlsoYI9qofENciSF2QcshW4uxP0Z1BARApACn+f8BIhdryao28DN71RK
         IakqnBzdr5LB1dsbHvEJImkSbGDqscPLy5rbkQVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stylon Wang <stylon.wang@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 010/112] drm/amd/display: Fix ineffective setting of max bpc property
Date:   Tue,  7 Jul 2020 17:16:15 +0200
Message-Id: <20200707145801.487144078@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stylon Wang <stylon.wang@amd.com>

[ Upstream commit fa7041d9d2fc7401cece43f305eb5b87b7017fc4 ]

[Why]
Regression was introduced where setting max bpc property has no effect
on the atomic check and final commit. It has the same effect as max bpc
being stuck at 8.

[How]
Correctly propagate max bpc with the new connector state.

Signed-off-by: Stylon Wang <stylon.wang@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index b7e161f2a47d4..69b1f61928eff 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4808,7 +4808,8 @@ create_validate_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 	struct drm_connector *connector = &aconnector->base;
 	struct amdgpu_device *adev = connector->dev->dev_private;
 	struct dc_stream_state *stream;
-	int requested_bpc = connector->state ? connector->state->max_requested_bpc : 8;
+	const struct drm_connector_state *drm_state = dm_state ? &dm_state->base : NULL;
+	int requested_bpc = drm_state ? drm_state->max_requested_bpc : 8;
 	enum dc_status dc_result = DC_OK;
 
 	do {
-- 
2.25.1



