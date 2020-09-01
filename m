Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEF52597C1
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgIAPdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731156AbgIAPdF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:33:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38CD7205F4;
        Tue,  1 Sep 2020 15:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974384;
        bh=BEll8sFvUbNOHlfpKXOfgKFukcive1Uh8g55XCOmxSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jxX58DwAROaXdnAu93RP1jIb3jWlwWuPLzktYVkU0DmEjixnKjxJncCLNb132nlTZ
         ho7QrRrInwe9pD5qwT2qpxgYPJLfrAnQihOYeuP+W23HNFDy+N7f1FB7Xa/DKMwsPQ
         r2oVYfieDx/WVaFvUnadNbPzd0iIbW5noaMQDqHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Koo <Anthony.Koo@amd.com>,
        Ashley Thomas <Ashley.Thomas2@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 128/214] drm/amd/display: Switch to immediate mode for updating infopackets
Date:   Tue,  1 Sep 2020 17:10:08 +0200
Message-Id: <20200901150959.112930944@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthony Koo <Anthony.Koo@amd.com>

[ Upstream commit abba907c7a20032c2d504fd5afe3af7d440a09d0 ]

[Why]
Using FRAME_UPDATE will result in infopacket to be potentially updated
one frame late.
In commit stream scenarios for previously active stream, some stale
infopacket data from previous config might be erroneously sent out on
initial frame after stream is re-enabled.

[How]
Switch to using IMMEDIATE_UPDATE mode

Signed-off-by: Anthony Koo <Anthony.Koo@amd.com>
Reviewed-by: Ashley Thomas <Ashley.Thomas2@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/dcn10/dcn10_stream_encoder.c  | 16 ++++++++--------
 .../amd/display/dc/dcn10/dcn10_stream_encoder.h  | 14 ++++++++++++++
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c
index 9aa258f3550b6..ddf66046616d6 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c
@@ -121,35 +121,35 @@ void enc1_update_generic_info_packet(
 	switch (packet_index) {
 	case 0:
 		REG_UPDATE(AFMT_VBI_PACKET_CONTROL1,
-				AFMT_GENERIC0_FRAME_UPDATE, 1);
+				AFMT_GENERIC0_IMMEDIATE_UPDATE, 1);
 		break;
 	case 1:
 		REG_UPDATE(AFMT_VBI_PACKET_CONTROL1,
-				AFMT_GENERIC1_FRAME_UPDATE, 1);
+				AFMT_GENERIC1_IMMEDIATE_UPDATE, 1);
 		break;
 	case 2:
 		REG_UPDATE(AFMT_VBI_PACKET_CONTROL1,
-				AFMT_GENERIC2_FRAME_UPDATE, 1);
+				AFMT_GENERIC2_IMMEDIATE_UPDATE, 1);
 		break;
 	case 3:
 		REG_UPDATE(AFMT_VBI_PACKET_CONTROL1,
-				AFMT_GENERIC3_FRAME_UPDATE, 1);
+				AFMT_GENERIC3_IMMEDIATE_UPDATE, 1);
 		break;
 	case 4:
 		REG_UPDATE(AFMT_VBI_PACKET_CONTROL1,
-				AFMT_GENERIC4_FRAME_UPDATE, 1);
+				AFMT_GENERIC4_IMMEDIATE_UPDATE, 1);
 		break;
 	case 5:
 		REG_UPDATE(AFMT_VBI_PACKET_CONTROL1,
-				AFMT_GENERIC5_FRAME_UPDATE, 1);
+				AFMT_GENERIC5_IMMEDIATE_UPDATE, 1);
 		break;
 	case 6:
 		REG_UPDATE(AFMT_VBI_PACKET_CONTROL1,
-				AFMT_GENERIC6_FRAME_UPDATE, 1);
+				AFMT_GENERIC6_IMMEDIATE_UPDATE, 1);
 		break;
 	case 7:
 		REG_UPDATE(AFMT_VBI_PACKET_CONTROL1,
-				AFMT_GENERIC7_FRAME_UPDATE, 1);
+				AFMT_GENERIC7_IMMEDIATE_UPDATE, 1);
 		break;
 	default:
 		break;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.h b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.h
index a512cbea00d17..b9656614950e3 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.h
@@ -275,7 +275,14 @@ struct dcn10_stream_enc_registers {
 	SE_SF(DIG0_AFMT_VBI_PACKET_CONTROL1, AFMT_GENERIC2_FRAME_UPDATE, mask_sh),\
 	SE_SF(DIG0_AFMT_VBI_PACKET_CONTROL1, AFMT_GENERIC3_FRAME_UPDATE, mask_sh),\
 	SE_SF(DIG0_AFMT_VBI_PACKET_CONTROL1, AFMT_GENERIC4_FRAME_UPDATE, mask_sh),\
+	SE_SF(DIG0_AFMT_VBI_PACKET_CONTROL1, AFMT_GENERIC0_IMMEDIATE_UPDATE, mask_sh),\
+	SE_SF(DIG0_AFMT_VBI_PACKET_CONTROL1, AFMT_GENERIC1_IMMEDIATE_UPDATE, mask_sh),\
+	SE_SF(DIG0_AFMT_VBI_PACKET_CONTROL1, AFMT_GENERIC2_IMMEDIATE_UPDATE, mask_sh),\
+	SE_SF(DIG0_AFMT_VBI_PACKET_CONTROL1, AFMT_GENERIC3_IMMEDIATE_UPDATE, mask_sh),\
 	SE_SF(DIG0_AFMT_VBI_PACKET_CONTROL1, AFMT_GENERIC4_IMMEDIATE_UPDATE, mask_sh),\
+	SE_SF(DIG0_AFMT_VBI_PACKET_CONTROL1, AFMT_GENERIC5_IMMEDIATE_UPDATE, mask_sh),\
+	SE_SF(DIG0_AFMT_VBI_PACKET_CONTROL1, AFMT_GENERIC6_IMMEDIATE_UPDATE, mask_sh),\
+	SE_SF(DIG0_AFMT_VBI_PACKET_CONTROL1, AFMT_GENERIC7_IMMEDIATE_UPDATE, mask_sh),\
 	SE_SF(DIG0_AFMT_VBI_PACKET_CONTROL1, AFMT_GENERIC5_FRAME_UPDATE, mask_sh),\
 	SE_SF(DIG0_AFMT_VBI_PACKET_CONTROL1, AFMT_GENERIC6_FRAME_UPDATE, mask_sh),\
 	SE_SF(DIG0_AFMT_VBI_PACKET_CONTROL1, AFMT_GENERIC7_FRAME_UPDATE, mask_sh),\
@@ -339,7 +346,14 @@ struct dcn10_stream_enc_registers {
 	type AFMT_GENERIC2_FRAME_UPDATE;\
 	type AFMT_GENERIC3_FRAME_UPDATE;\
 	type AFMT_GENERIC4_FRAME_UPDATE;\
+	type AFMT_GENERIC0_IMMEDIATE_UPDATE;\
+	type AFMT_GENERIC1_IMMEDIATE_UPDATE;\
+	type AFMT_GENERIC2_IMMEDIATE_UPDATE;\
+	type AFMT_GENERIC3_IMMEDIATE_UPDATE;\
 	type AFMT_GENERIC4_IMMEDIATE_UPDATE;\
+	type AFMT_GENERIC5_IMMEDIATE_UPDATE;\
+	type AFMT_GENERIC6_IMMEDIATE_UPDATE;\
+	type AFMT_GENERIC7_IMMEDIATE_UPDATE;\
 	type AFMT_GENERIC5_FRAME_UPDATE;\
 	type AFMT_GENERIC6_FRAME_UPDATE;\
 	type AFMT_GENERIC7_FRAME_UPDATE;\
-- 
2.25.1



