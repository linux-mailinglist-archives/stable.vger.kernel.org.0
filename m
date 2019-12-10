Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A09601199D7
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbfLJVIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:08:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:56554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727177AbfLJVIu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:08:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFA1724698;
        Tue, 10 Dec 2019 21:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012129;
        bh=08DoADdqRUPWJ+sopBpimPGPenU5rEjxVPErtPZY8oQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=05mzdiJhBJ0isiIRr0V2fOfI8N6D9Zpq0X+WpMWj39YPYhPabfGiHVKDxzkqLRAXG
         P+Rc146ymxoakk3snwRQpet/7V2Rm9XexFJbzR3+WMq66VJrSrc8XzsAVCrHfaBGbL
         v+0D6HtIUE7e5AYbHl0z/GuQ+urq1M9spiX3iA9E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Prosyak <vitaly.prosyak@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Vitaly Prosyak <Vitaly.Prosyak@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 098/350] drm/amd/display: add new active dongle to existent w/a
Date:   Tue, 10 Dec 2019 16:03:23 -0500
Message-Id: <20191210210735.9077-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Prosyak <vitaly.prosyak@amd.com>

[ Upstream commit 566b4252fe9da9582dde008c5e9c3eb7c136e348 ]

[Why & How]
Dongle 0x00E04C power down all internal circuits including
AUX communication preventing reading DPCD table.
Encoder will skip DP RX power down on disable output
to keep receiver powered all the time.

Signed-off-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Acked-by: Vitaly Prosyak <Vitaly.Prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c        | 1 +
 drivers/gpu/drm/amd/display/include/ddc_service_types.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index f5742719b5d9b..9e261dbf2e493 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -2691,6 +2691,7 @@ static void dp_wa_power_up_0010FA(struct dc_link *link, uint8_t *dpcd_data,
 		 * keep receiver powered all the time.*/
 		case DP_BRANCH_DEVICE_ID_0010FA:
 		case DP_BRANCH_DEVICE_ID_0080E1:
+		case DP_BRANCH_DEVICE_ID_00E04C:
 			link->wa_flags.dp_keep_receiver_powered = true;
 			break;
 
diff --git a/drivers/gpu/drm/amd/display/include/ddc_service_types.h b/drivers/gpu/drm/amd/display/include/ddc_service_types.h
index 18961707db237..9ad49da50a17d 100644
--- a/drivers/gpu/drm/amd/display/include/ddc_service_types.h
+++ b/drivers/gpu/drm/amd/display/include/ddc_service_types.h
@@ -31,6 +31,8 @@
 #define DP_BRANCH_DEVICE_ID_0022B9 0x0022B9
 #define DP_BRANCH_DEVICE_ID_00001A 0x00001A
 #define DP_BRANCH_DEVICE_ID_0080E1 0x0080e1
+#define DP_BRANCH_DEVICE_ID_90CC24 0x90CC24
+#define DP_BRANCH_DEVICE_ID_00E04C 0x00E04C
 
 enum ddc_result {
 	DDC_RESULT_UNKNOWN = 0,
-- 
2.20.1

