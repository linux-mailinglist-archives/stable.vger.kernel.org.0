Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 197A57FAFE
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393303AbfHBNUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:20:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393300AbfHBNUM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:20:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 374EF21850;
        Fri,  2 Aug 2019 13:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752011;
        bh=Sczlfus0QhQynXrMg+oG23y9TvPE75FgQEDfjZAZOe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZmgYkpcZp+BpZiojbdHHnZhhLbhWrdkaKdZtWU9vvNyjq6deYSYqkAU9oIt5jeZSz
         3ZYdvlmkLGiKY0Tl20P+Vp9ETSUFQXzMkVFvLziLkR6EVGkB9JadJgcI5xUwgYV6gk
         s7+51srXmp7WBV3vtjwnGpZ9AmXHaDULMMT5LkDE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harmanprit Tatla <harmanprit.tatla@amd.com>,
        Aric Cyr <aric.cyr@amd.com>, Anthony Koo <Anthony.Koo@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 16/76] drm/amd/display: No audio endpoint for Dell MST display
Date:   Fri,  2 Aug 2019 09:18:50 -0400
Message-Id: <20190802131951.11600-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harmanprit Tatla <harmanprit.tatla@amd.com>

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

