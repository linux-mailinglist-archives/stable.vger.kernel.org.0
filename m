Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E187812C66D
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731151AbfL2Rqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:46:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:56936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731146AbfL2Rqu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:46:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E18A421744;
        Sun, 29 Dec 2019 17:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641610;
        bh=NYOsa8ZXF6GV+pcdvY07gSXrsUw9TGjEoR/itfLaXU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fyJtDQxA24dKhTKkMnnBYgpH91WrhqlaVe7qI1VhU+yOuy1JD0+/RXSmP7WffAT60
         Hd+0zUHOOmCAOBbO58ZH2uiyq9zik7uIDsh6cWd4NjAAMVhoMcqShS9xaf7yDRqkiE
         vZvnY6Ur7ww5DeT4YsQbmnnpDU7a0e0wCEfC1DhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Prosyak <vitaly.prosyak@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Vitaly Prosyak <Vitaly.Prosyak@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 136/434] drm/amd/display: add new active dongle to existent w/a
Date:   Sun, 29 Dec 2019 18:23:09 +0100
Message-Id: <20191229172710.752131749@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f5742719b5d9..9e261dbf2e49 100644
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
index 18961707db23..9ad49da50a17 100644
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



