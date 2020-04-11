Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5E71A57C5
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbgDKXYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:24:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730170AbgDKXM2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:12:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0158F20708;
        Sat, 11 Apr 2020 23:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646747;
        bh=Sg+AeYwlWAaR4CNzrnLx9RnsqgcJVfc9GzSfFoFeZyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ElxkJ1ckrbbUP4EJJUcGbvopkr0g+YHfjm8L0g5YyRKb3JQOM8s4n4zNyWh67Q/6S
         WUlKybre0jRyQB83HEkvCom139Mfj/Nt47PiMZNahu890DcUZXrLKqEeqHsXuqRqvZ
         YA3bBlMqAOUyU+B7wa1kF/RDEomJegQNYbL6o1jc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Bernstein <eric.bernstein@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 20/66] drm/amd/display: Fix default logger mask definition
Date:   Sat, 11 Apr 2020 19:11:17 -0400
Message-Id: <20200411231203.25933-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231203.25933-1-sashal@kernel.org>
References: <20200411231203.25933-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Bernstein <eric.bernstein@amd.com>

[ Upstream commit ccb6af1e25830e5601b6beacc698390f0245316f ]

[Why]
Logger mask was updated to uint64_t, however default mask definition was
not updated for unsigned long long

[How]
Update DC_DEFAULT_LOG_MASK to support uint64_t type

Signed-off-by: Eric Bernstein <eric.bernstein@amd.com>
Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/include/logger_types.h    | 63 ++++++++++---------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/include/logger_types.h b/drivers/gpu/drm/amd/display/include/logger_types.h
index ad3695e67b76f..dbc5a4d6d2e3f 100644
--- a/drivers/gpu/drm/amd/display/include/logger_types.h
+++ b/drivers/gpu/drm/amd/display/include/logger_types.h
@@ -106,36 +106,37 @@ enum dc_log_type {
 #define DC_MIN_LOG_MASK ((1 << LOG_ERROR) | \
 		(1 << LOG_DETECTION_EDID_PARSER))
 
-#define DC_DEFAULT_LOG_MASK ((1 << LOG_ERROR) | \
-		(1 << LOG_WARNING) | \
-		(1 << LOG_EVENT_MODE_SET) | \
-		(1 << LOG_EVENT_DETECTION) | \
-		(1 << LOG_EVENT_LINK_TRAINING) | \
-		(1 << LOG_EVENT_LINK_LOSS) | \
-		(1 << LOG_EVENT_UNDERFLOW) | \
-		(1 << LOG_RESOURCE) | \
-		(1 << LOG_FEATURE_OVERRIDE) | \
-		(1 << LOG_DETECTION_EDID_PARSER) | \
-		(1 << LOG_DC) | \
-		(1 << LOG_HW_HOTPLUG) | \
-		(1 << LOG_HW_SET_MODE) | \
-		(1 << LOG_HW_RESUME_S3) | \
-		(1 << LOG_HW_HPD_IRQ) | \
-		(1 << LOG_SYNC) | \
-		(1 << LOG_BANDWIDTH_VALIDATION) | \
-		(1 << LOG_MST) | \
-		(1 << LOG_DETECTION_DP_CAPS) | \
-		(1 << LOG_BACKLIGHT)) | \
-		(1 << LOG_I2C_AUX) | \
-		(1 << LOG_IF_TRACE) | \
-		(1 << LOG_DTN) /* | \
-		(1 << LOG_DEBUG) | \
-		(1 << LOG_BIOS) | \
-		(1 << LOG_SURFACE) | \
-		(1 << LOG_SCALER) | \
-		(1 << LOG_DML) | \
-		(1 << LOG_HW_LINK_TRAINING) | \
-		(1 << LOG_HW_AUDIO)| \
-		(1 << LOG_BANDWIDTH_CALCS)*/
+#define DC_DEFAULT_LOG_MASK ((1ULL << LOG_ERROR) | \
+		(1ULL << LOG_WARNING) | \
+		(1ULL << LOG_EVENT_MODE_SET) | \
+		(1ULL << LOG_EVENT_DETECTION) | \
+		(1ULL << LOG_EVENT_LINK_TRAINING) | \
+		(1ULL << LOG_EVENT_LINK_LOSS) | \
+		(1ULL << LOG_EVENT_UNDERFLOW) | \
+		(1ULL << LOG_RESOURCE) | \
+		(1ULL << LOG_FEATURE_OVERRIDE) | \
+		(1ULL << LOG_DETECTION_EDID_PARSER) | \
+		(1ULL << LOG_DC) | \
+		(1ULL << LOG_HW_HOTPLUG) | \
+		(1ULL << LOG_HW_SET_MODE) | \
+		(1ULL << LOG_HW_RESUME_S3) | \
+		(1ULL << LOG_HW_HPD_IRQ) | \
+		(1ULL << LOG_SYNC) | \
+		(1ULL << LOG_BANDWIDTH_VALIDATION) | \
+		(1ULL << LOG_MST) | \
+		(1ULL << LOG_DETECTION_DP_CAPS) | \
+		(1ULL << LOG_BACKLIGHT)) | \
+		(1ULL << LOG_I2C_AUX) | \
+		(1ULL << LOG_IF_TRACE) | \
+		(1ULL << LOG_HDMI_FRL) | \
+		(1ULL << LOG_DTN) /* | \
+		(1ULL << LOG_DEBUG) | \
+		(1ULL << LOG_BIOS) | \
+		(1ULL << LOG_SURFACE) | \
+		(1ULL << LOG_SCALER) | \
+		(1ULL << LOG_DML) | \
+		(1ULL << LOG_HW_LINK_TRAINING) | \
+		(1ULL << LOG_HW_AUDIO)| \
+		(1ULL << LOG_BANDWIDTH_CALCS)*/
 
 #endif /* __DAL_LOGGER_TYPES_H__ */
-- 
2.20.1

