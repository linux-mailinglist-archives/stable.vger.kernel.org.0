Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE0638DB6F
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbfHNRFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:05:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729527AbfHNRFv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:05:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4193D21721;
        Wed, 14 Aug 2019 17:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802350;
        bh=8kiy6x9kOZIqvbwQZ1qz134zUL+JWlXhCP6Bpj+x82Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F2dvUVKnblmx60lDgD+yqxh9R+OPQFNSW5rOJg6s3i0RIKPfU2aFu9/JwIa8QKeK6
         cxESfvE//hTLFMDax8sZgFoY6s6widu+O0CPBK62oTaCd7B25CLwduZsFC9kOkNjqt
         9C9lmLz37jfoef8yOaJynukdfMtz7C32QSF8BUUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harmanprit Tatla <harmanprit.tatla@amd.com>,
        Aric Cyr <aric.cyr@amd.com>, Anthony Koo <Anthony.Koo@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 064/144] drm/amd/display: No audio endpoint for Dell MST display
Date:   Wed, 14 Aug 2019 19:00:20 +0200
Message-Id: <20190814165802.514981594@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5b25e5f1a97284020abee7348427f89abdb674e8 ]

[Why]
There are certain MST displays (i.e. Dell P2715Q)
that although have the MST feature set to off may still
report it is a branch device and a non-zero
value for downstream port present.
This can lead to us incorrectly classifying a
dp dongle connection as being active and
disabling the audio endpoint for the display.

[How]
Modified the placement and
condition used to assign
the is_branch_dev bit.

Signed-off-by: Harmanprit Tatla <harmanprit.tatla@amd.com>
Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Acked-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 253311864cdd5..966aa3b754c5b 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -2218,11 +2218,18 @@ static void get_active_converter_info(
 		link->dpcd_caps.dongle_type = DISPLAY_DONGLE_NONE;
 		ddc_service_set_dongle_type(link->ddc,
 				link->dpcd_caps.dongle_type);
+		link->dpcd_caps.is_branch_dev = false;
 		return;
 	}
 
 	/* DPCD 0x5 bit 0 = 1, it indicate it's branch device */
-	link->dpcd_caps.is_branch_dev = ds_port.fields.PORT_PRESENT;
+	if (ds_port.fields.PORT_TYPE == DOWNSTREAM_DP) {
+		link->dpcd_caps.is_branch_dev = false;
+	}
+
+	else {
+		link->dpcd_caps.is_branch_dev = ds_port.fields.PORT_PRESENT;
+	}
 
 	switch (ds_port.fields.PORT_TYPE) {
 	case DOWNSTREAM_VGA:
-- 
2.20.1



