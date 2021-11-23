Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4686745A101
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 12:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbhKWLMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 06:12:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:54060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234250AbhKWLMu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 06:12:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B314A60F6E;
        Tue, 23 Nov 2021 11:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637665782;
        bh=UjNhHmD4IkEqm9FAxCB2Y/dUkr+uWccPe6a3TxjO3eg=;
        h=Subject:To:Cc:From:Date:From;
        b=2CWWEiu6MWxWz9vHqsLYQytE7Lnn2RmMPF3MYqaYvBqtOR8FEw4h8JtGe3dEGsDLR
         C5p7hNFURqiRZMawhA8kxHmZqbwp0xi3cHPJoF10ePAS1VZa6OY8n43t/YpJXkQA5V
         2cVhWvgVi8qZPsjxMRGJc9vKv8ibWGqhU5wMVkz0=
Subject: FAILED: patch "[PATCH] drm/amd/display: Fix OLED brightness control on eDP" failed to apply to 5.15-stable tree
To:     Roman.Li@amd.com, Jasdeep.Dhillon@amd.com,
        alexander.deucher@amd.com, samuel@cavoj.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Nov 2021 12:09:39 +0100
Message-ID: <16376657798830@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dab60582685aabdae2d4ff7ce716456bd0dc7a0f Mon Sep 17 00:00:00 2001
From: Roman Li <Roman.Li@amd.com>
Date: Wed, 17 Nov 2021 10:05:36 -0500
Subject: [PATCH] drm/amd/display: Fix OLED brightness control on eDP
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

[Why]
After commit ("drm/amdgpu/display: add support for multiple backlights")
number of eDPs is defined while registering backlight device.
However the panel's extended caps get updated once before register call.
That leads to regression with extended caps like oled brightness control.

[How]
Update connector ext caps after register_backlight_device

Fixes: 7fd13baeb7a3a4 ("drm/amdgpu/display: add support for multiple backlights")
Link: https://www.reddit.com/r/AMDLaptops/comments/qst0fm/after_updating_to_linux_515_my_brightness/

Signed-off-by: Roman Li <Roman.Li@amd.com>
Tested-by: Samuel Čavoj <samuel@cavoj.net>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Jasdeep Dhillon <Jasdeep.Dhillon@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index c911b30de658..c27cb47bc988 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4242,7 +4242,8 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 		} else if (dc_link_detect(link, DETECT_REASON_BOOT)) {
 			amdgpu_dm_update_connector_after_detect(aconnector);
 			register_backlight_device(dm, link);
-
+			if (dm->num_of_edps)
+				update_connector_ext_caps(aconnector);
 			if (psr_feature_enabled)
 				amdgpu_dm_set_psr_caps(link);
 		}

