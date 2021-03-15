Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9593D33B79A
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbhCOOAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232086AbhCON7M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82C2D64F60;
        Mon, 15 Mar 2021 13:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816738;
        bh=1Rhy1SGKFluUeX/Ya9lJjumMOaFbfp6VWF5vLrT3N28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mht6CeBPliYEQHR8C1IxmXUz4M9ZHiDGbglaeQnBhRudMNkKmHTU+EEPyXSXOKnAT
         8MBkl+xeCs0Jcp2fzxfe5I+srvmT5lOluPHlK9rk3mvdmaTA88jTv5pdBqbU9cUI3K
         XjOV2ldUe2UmIuMI6QI2ZAXW/VpbXyIV1btrIBRc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Takashi Iwai <tiwai@suse.de>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 085/290] drm/amd/display: Add a backlight module option
Date:   Mon, 15 Mar 2021 14:52:58 +0100
Message-Id: <20210315135544.796764353@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Takashi Iwai <tiwai@suse.de>

commit 7a46f05e5e163c00e41892e671294286e53fe15c upstream.

There seem devices that don't work with the aux channel backlight
control.  For allowing such users to test with the other backlight
control method, provide a new module option, aux_backlight, to specify
enabling or disabling the aux backport support explicitly.  As
default, the aux support is detected by the hardware capability.

v2: make the backlight option generic in case we add future
backlight types (Alex)

BugLink: https://bugzilla.opensuse.org/show_bug.cgi?id=1180749
BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1438
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h               |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c           |    4 ++++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    5 +++++
 3 files changed, 10 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -178,6 +178,7 @@ extern uint amdgpu_smu_memory_pool_size;
 extern uint amdgpu_dc_feature_mask;
 extern uint amdgpu_dc_debug_mask;
 extern uint amdgpu_dm_abm_level;
+extern int amdgpu_backlight;
 extern struct amdgpu_mgpu_info mgpu_info;
 extern int amdgpu_ras_enable;
 extern uint amdgpu_ras_mask;
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -768,6 +768,10 @@ uint amdgpu_dm_abm_level = 0;
 MODULE_PARM_DESC(abmlevel, "ABM level (0 = off (default), 1-4 = backlight reduction level) ");
 module_param_named(abmlevel, amdgpu_dm_abm_level, uint, 0444);
 
+int amdgpu_backlight = -1;
+MODULE_PARM_DESC(backlight, "Backlight control (0 = pwm, 1 = aux, -1 auto (default))");
+module_param_named(backlight, amdgpu_backlight, bint, 0444);
+
 /**
  * DOC: tmz (int)
  * Trusted Memory Zone (TMZ) is a method to protect data being written
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2140,6 +2140,11 @@ static void update_connector_ext_caps(st
 	    caps->ext_caps->bits.hdr_aux_backlight_control == 1)
 		caps->aux_support = true;
 
+	if (amdgpu_backlight == 0)
+		caps->aux_support = false;
+	else if (amdgpu_backlight == 1)
+		caps->aux_support = true;
+
 	/* From the specification (CTA-861-G), for calculating the maximum
 	 * luminance we need to use:
 	 *	Luminance = 50*2**(CV/32)


