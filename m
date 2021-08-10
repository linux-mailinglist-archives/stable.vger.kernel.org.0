Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FA13E824C
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238127AbhHJSGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:06:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239111AbhHJSEx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 14:04:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2728A61260;
        Tue, 10 Aug 2021 17:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617713;
        bh=tENQq1cuKlsa4P3AYYbUiVpl4/5T2ktZGykk9jUatto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0TuxWnxNCQJRHC5A/VouTZqayLUJBaIrN4JCFUwTea9zPe8tj732kQPiflIx+ysL
         /9HQNSc5kTC/DNqm22ucnt7GjUUpNSfAiSm5O8Momr+XFrjo5O4x1XZy4/2bXq4xr8
         1Y7+lACRDFsr6rYQFhjPn8QFdWgMILuH0HUkA5VM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Li <Roman.Li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 173/175] drm/amdgpu/display: only enable aux backlight control for OLED panels
Date:   Tue, 10 Aug 2021 19:31:21 +0200
Message-Id: <20210810173006.643279434@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f44038f8e563..0894cd505361 100644
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



