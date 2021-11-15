Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A569D451E92
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345306AbhKPAgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345085AbhKOT0N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:26:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B574063714;
        Mon, 15 Nov 2021 19:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003407;
        bh=uZNir75XsZvIfTz9O+1kYBpQT4j6bPdlKpNcJKhNYtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7BB7Fc3xvt/hKDVp6NHi9CAlbbyGVubOtGNCe30J6nhNXovm64AKu5Z6DWiMG+zz
         OxNWuf7BmMK/Xzcgcfm5OrZ/PEaalaXXCVY/e4Lvu6MwOIg3gnez5lk4f+eBnYlG8L
         xA2M5qyV+W0PRX7MtJCd0DetCDw5PYWoQLku06X4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman.Li@amd.com,
        Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 917/917] drm/amd/display: Look at firmware version to determine using dmub on dcn21
Date:   Mon, 15 Nov 2021 18:06:52 +0100
Message-Id: <20211115165500.132569186@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

commit 91adec9e07097e538691daed5d934e7886dd1dc3 upstream.

commit 652de07addd2 ("drm/amd/display: Fully switch to dmub for all dcn21
asics") switched over to using dmub on Renoir to fix Gitlab 1735, but this
implied a new dependency on newer firmware which might not be met on older
kernel versions.

Since sw_init runs before hw_init, there is an opportunity to determine
whether or not the firmware version is new to adjust the behavior.

Cc: Roman.Li@amd.com
BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1772
BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1735
Fixes: 652de07addd2 ("drm/amd/display: Fully switch to dmub for all dcn21 asics")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Roman Li <Roman.Li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1141,8 +1141,15 @@ static int amdgpu_dm_init(struct amdgpu_
 	case CHIP_RAVEN:
 	case CHIP_RENOIR:
 		init_data.flags.gpu_vm_support = true;
-		if (ASICREV_IS_GREEN_SARDINE(adev->external_rev_id))
+		switch (adev->dm.dmcub_fw_version) {
+		case 0: /* development */
+		case 0x1: /* linux-firmware.git hash 6d9f399 */
+		case 0x01000000: /* linux-firmware.git hash 9a0b0f4 */
+			init_data.flags.disable_dmcu = false;
+			break;
+		default:
 			init_data.flags.disable_dmcu = true;
+		}
 		break;
 	case CHIP_VANGOGH:
 	case CHIP_YELLOW_CARP:


