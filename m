Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E4346272E
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236650AbhK2XBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235850AbhK2XAA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:00:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3FDC1A197A;
        Mon, 29 Nov 2021 10:37:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0167DCE13D0;
        Mon, 29 Nov 2021 18:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2310C53FAD;
        Mon, 29 Nov 2021 18:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211071;
        bh=dLQNe1a8m9HmDH/eWDxLtXHHJvJ970v1I13FudN1ZjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HyoukAfIR8VfdRH8wFlIeSJC0939acYuvtfzyt8wOKRssFfr0xjSOiN17L3005Uxg
         375Iit+QWCIC1q+sSbM0a80J1kfh78aoIPjvPPfF9XAyBcl3qVuP1U6XimhV8DKWyx
         j2qRGytGtEeEcH9cPZbRf3vJA8MzU0SmBKyQjyjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Li <Roman.Li@amd.com>,
        =?UTF-8?q?Samuel=20=C4=8Cavoj?= <samuel@cavoj.net>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jasdeep Dhillon <Jasdeep.Dhillon@amd.com>
Subject: [PATCH 5.15 062/179] drm/amd/display: Fix OLED brightness control on eDP
Date:   Mon, 29 Nov 2021 19:17:36 +0100
Message-Id: <20211129181721.002093923@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Li <Roman.Li@amd.com>

commit dab60582685aabdae2d4ff7ce716456bd0dc7a0f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3846,6 +3846,9 @@ static int amdgpu_dm_initialize_drm_devi
 		} else if (dc_link_detect(link, DETECT_REASON_BOOT)) {
 			amdgpu_dm_update_connector_after_detect(aconnector);
 			register_backlight_device(dm, link);
+
+			if (dm->num_of_edps)
+				update_connector_ext_caps(aconnector);
 			if (amdgpu_dc_feature_mask & DC_PSR_MASK)
 				amdgpu_dm_set_psr_caps(link);
 		}


