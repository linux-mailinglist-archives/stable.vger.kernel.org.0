Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5E240E6D5
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344519AbhIPRZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:25:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348187AbhIPRYF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:24:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD57661BE2;
        Thu, 16 Sep 2021 16:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810633;
        bh=UG3wFphemK0QyVhxrHNI+4F4NkJgNfaz6M0NIhwyY/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qCaFE+cY6mcGddeDiHKLggUBJS0B3C6qhkj8zYIYr+WTmfcga4Ox51drO0Gu6P86C
         3F/kyYNSbyMFGV2eDPSn+CVZEcgDr1Kv8cqrh+FaZNuT5RZpVxymbngrwXTMm1D+CA
         4kDAj07n5VQjaREITrroSMKjpwUrPo6X2fBESTY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Jake Wang <haonan.wang2@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 213/432] drm/amd/display: Fixed hardware power down bypass during headless boot
Date:   Thu, 16 Sep 2021 17:59:22 +0200
Message-Id: <20210916155818.055798973@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jake Wang <haonan.wang2@amd.com>

[ Upstream commit 3addbde269f21ffc735f6d3d0c2237664923824e ]

[Why]
During headless boot, DIG may be on which causes HW/SW discrepancies.
To avoid this we power down hardware on boot if DIG is turned on. With
introduction of multiple eDP, hardware power down is being bypassed
under certain conditions.

[How]
Fixed hardware power down bypass, and ensured hardware will power down
if DIG is on and seamless boot is not enabled.

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Jake Wang <haonan.wang2@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/dcn10/dcn10_hw_sequencer.c | 27 +++++++++----------
 .../drm/amd/display/dc/dcn30/dcn30_hwseq.c    | 25 ++++++++---------
 .../drm/amd/display/dc/dcn31/dcn31_hwseq.c    |  5 +++-
 3 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index c545eddabdcc..dee1ce5f9609 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -1502,25 +1502,22 @@ void dcn10_init_hw(struct dc *dc)
 void dcn10_power_down_on_boot(struct dc *dc)
 {
 	struct dc_link *edp_links[MAX_NUM_EDP];
-	struct dc_link *edp_link;
+	struct dc_link *edp_link = NULL;
 	int edp_num;
 	int i = 0;
 
 	get_edp_links(dc, edp_links, &edp_num);
-
-	if (edp_num) {
-		for (i = 0; i < edp_num; i++) {
-			edp_link = edp_links[i];
-			if (edp_link->link_enc->funcs->is_dig_enabled &&
-					edp_link->link_enc->funcs->is_dig_enabled(edp_link->link_enc) &&
-					dc->hwseq->funcs.edp_backlight_control &&
-					dc->hwss.power_down &&
-					dc->hwss.edp_power_control) {
-				dc->hwseq->funcs.edp_backlight_control(edp_link, false);
-				dc->hwss.power_down(dc);
-				dc->hwss.edp_power_control(edp_link, false);
-			}
-		}
+	if (edp_num)
+		edp_link = edp_links[0];
+
+	if (edp_link && edp_link->link_enc->funcs->is_dig_enabled &&
+			edp_link->link_enc->funcs->is_dig_enabled(edp_link->link_enc) &&
+			dc->hwseq->funcs.edp_backlight_control &&
+			dc->hwss.power_down &&
+			dc->hwss.edp_power_control) {
+		dc->hwseq->funcs.edp_backlight_control(edp_link, false);
+		dc->hwss.power_down(dc);
+		dc->hwss.edp_power_control(edp_link, false);
 	} else {
 		for (i = 0; i < dc->link_count; i++) {
 			struct dc_link *link = dc->links[i];
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
index c68e3a708a33..2e8ab9775fa3 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
@@ -580,22 +580,19 @@ void dcn30_init_hw(struct dc *dc)
 	 */
 	if (dc->config.power_down_display_on_boot) {
 		struct dc_link *edp_links[MAX_NUM_EDP];
-		struct dc_link *edp_link;
+		struct dc_link *edp_link = NULL;
 
 		get_edp_links(dc, edp_links, &edp_num);
-		if (edp_num) {
-			for (i = 0; i < edp_num; i++) {
-				edp_link = edp_links[i];
-				if (edp_link->link_enc->funcs->is_dig_enabled &&
-						edp_link->link_enc->funcs->is_dig_enabled(edp_link->link_enc) &&
-						dc->hwss.edp_backlight_control &&
-						dc->hwss.power_down &&
-						dc->hwss.edp_power_control) {
-					dc->hwss.edp_backlight_control(edp_link, false);
-					dc->hwss.power_down(dc);
-					dc->hwss.edp_power_control(edp_link, false);
-				}
-			}
+		if (edp_num)
+			edp_link = edp_links[0];
+		if (edp_link && edp_link->link_enc->funcs->is_dig_enabled &&
+				edp_link->link_enc->funcs->is_dig_enabled(edp_link->link_enc) &&
+				dc->hwss.edp_backlight_control &&
+				dc->hwss.power_down &&
+				dc->hwss.edp_power_control) {
+			dc->hwss.edp_backlight_control(edp_link, false);
+			dc->hwss.power_down(dc);
+			dc->hwss.edp_power_control(edp_link, false);
 		} else {
 			for (i = 0; i < dc->link_count; i++) {
 				struct dc_link *link = dc->links[i];
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
index 8a2119d8ca0d..8189606537c5 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
@@ -226,6 +226,7 @@ void dcn31_init_hw(struct dc *dc)
 	if (dc->config.power_down_display_on_boot) {
 		struct dc_link *edp_links[MAX_NUM_EDP];
 		struct dc_link *edp_link;
+		bool power_down = false;
 
 		get_edp_links(dc, edp_links, &edp_num);
 		if (edp_num) {
@@ -239,9 +240,11 @@ void dcn31_init_hw(struct dc *dc)
 					dc->hwss.edp_backlight_control(edp_link, false);
 					dc->hwss.power_down(dc);
 					dc->hwss.edp_power_control(edp_link, false);
+					power_down = true;
 				}
 			}
-		} else {
+		}
+		if (!power_down) {
 			for (i = 0; i < dc->link_count; i++) {
 				struct dc_link *link = dc->links[i];
 
-- 
2.30.2



