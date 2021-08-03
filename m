Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D483DEC97
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 13:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbhHCLoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 07:44:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235991AbhHCLoQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Aug 2021 07:44:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57D8A60EFD;
        Tue,  3 Aug 2021 11:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627991045;
        bh=91B7DtxBmEfXIwSArmCavqoB3hv8RIeA25Ewc7jFkjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nihn9wSi9MGVkmeyK7eaJ7yFA+BGqa6XCHUIjD8ntd8/6gTkhzmaa+XfiLCe2EpAr
         a7nz44TeBCd4Mak4Oo1uXLhS+dA7K+4XhJJiUIUWil6M51s9D2wGWjMsZRxGkj6LEy
         HmUsJyy1ssdg2oDRm8B4x03gmM0FTeP/IqZKImBOTuHdXifC1uZ8qq9yDKh7eBGg4r
         KiHU+8y+0v35mgx0Opz+nuxZ2ZSEj0lD7xCEFv0BS2NdELolWvzlh94LRE384DeOg/
         UufbdFwCvqYR9GKTfYLP55qOF8XTaJG0lh5thKCuj9S8PykwGc744J0pCl+RUdGjHK
         uOAtG77JqtrSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Roman Li <Roman.Li@amd.com>, Sasha Levin <sashal@kernel.org>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 09/11] drm/amdgpu/display: only enable aux backlight control for OLED panels
Date:   Tue,  3 Aug 2021 07:43:50 -0400
Message-Id: <20210803114352.2252544-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803114352.2252544-1-sashal@kernel.org>
References: <20210803114352.2252544-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit f2ad3accefc63e72e9932e141c21875cc04beec8 ]

We've gotten a number of reports about backlight control not
working on panels which indicate that they use aux backlight
control.  A recent patch:

commit 2d73eabe2984a435737498ab39bb1500a9ffe9a9
Author: Camille Cho <Camille.Cho@amd.com>
Date:   Thu Jul 8 18:28:37 2021 +0800

    drm/amd/display: Only set default brightness for OLED

    [Why]
    We used to unconditionally set backlight path as AUX for panels capable
    of backlight adjustment via DPCD in set default brightness.

    [How]
    This should be limited to OLED panel only since we control backlight via
    PWM path for SDR mode in LCD HDR panel.

    Reviewed-by: Krunoslav Kovac <krunoslav.kovac@amd.com>
    Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    Signed-off-by: Camille Cho <Camille.Cho@amd.com>
    Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

Changes some other code to only use aux for backlight control on
OLED panels.  The commit message seems to indicate that PWM should
be used for SDR mode on HDR panels.  Do something similar for
backlight control in general.  This may need to be revisited if and
when HDR started to get used.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1438
Bug: https://bugzilla.kernel.org/show_bug.cgi?id=213715
Reviewed-by: Roman Li <Roman.Li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index eeaae1cf2bc2..f02ad2eb154b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2367,9 +2367,9 @@ static void update_connector_ext_caps(struct amdgpu_dm_connector *aconnector)
 	max_cll = conn_base->hdr_sink_metadata.hdmi_type1.max_cll;
 	min_cll = conn_base->hdr_sink_metadata.hdmi_type1.min_cll;
 
-	if (caps->ext_caps->bits.oled == 1 ||
+	if (caps->ext_caps->bits.oled == 1 /*||
 	    caps->ext_caps->bits.sdr_aux_backlight_control == 1 ||
-	    caps->ext_caps->bits.hdr_aux_backlight_control == 1)
+	    caps->ext_caps->bits.hdr_aux_backlight_control == 1*/)
 		caps->aux_support = true;
 
 	if (amdgpu_backlight == 0)
-- 
2.30.2

