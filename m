Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBCE42E9A02
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728937AbhADQCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:02:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:40326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728143AbhADQCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:02:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67AD421D93;
        Mon,  4 Jan 2021 16:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776133;
        bh=CBrCcxd2iSOW3OMTBf9Xm+XbcFbP/662zUbb0baLBUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z9YT+d9OKlSdn/yZP0I/OqigjqQEzFzdPYJPB/12498bSGTgBwJ0TsyZDkAA3Q2r1
         hUZWNyNIf2435ak+Iapa9uFKGFmT0h78mFncDuRAvbW1RFwMTQaE2gcl9v4fFDvONn
         13z/NAXZfzWE1d5epKjsCqorMD79oCxfGKZod2gw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Harry Wentland <Harry.Wentland@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Chiawen Huang <chiawen.huang@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.10 06/63] drm/amd/display: Add get_dig_frontend implementation for DCEx
Date:   Mon,  4 Jan 2021 16:56:59 +0100
Message-Id: <20210104155709.116957895@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

commit 6bdeff12a96c9a5da95c8d11fefd145eb165e32a upstream.

Some old ASICs might not implement/require get_dig_frontend helper; in
this scenario, we can have a NULL pointer exception when we try to call
it inside vbios disable operation. For example, this situation might
happen when using Polaris12 with an eDP panel. This commit avoids this
situation by adding a specific get_dig_frontend implementation for DCEx.

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Harry Wentland <Harry.Wentland@amd.com>
Cc: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Cc: Chiawen Huang <chiawen.huang@amd.com>
Reported-and-tested-by: Borislav Petkov <bp@suse.de>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c |   44 +++++++++++++++++-
 drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.h |    2 
 2 files changed, 44 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
@@ -119,7 +119,8 @@ static const struct link_encoder_funcs d
 	.disable_hpd = dce110_link_encoder_disable_hpd,
 	.is_dig_enabled = dce110_is_dig_enabled,
 	.destroy = dce110_link_encoder_destroy,
-	.get_max_link_cap = dce110_link_encoder_get_max_link_cap
+	.get_max_link_cap = dce110_link_encoder_get_max_link_cap,
+	.get_dig_frontend = dce110_get_dig_frontend,
 };
 
 static enum bp_result link_transmitter_control(
@@ -235,6 +236,44 @@ static void set_link_training_complete(
 
 }
 
+unsigned int dce110_get_dig_frontend(struct link_encoder *enc)
+{
+	struct dce110_link_encoder *enc110 = TO_DCE110_LINK_ENC(enc);
+	u32 value;
+	enum engine_id result;
+
+	REG_GET(DIG_BE_CNTL, DIG_FE_SOURCE_SELECT, &value);
+
+	switch (value) {
+	case DCE110_DIG_FE_SOURCE_SELECT_DIGA:
+		result = ENGINE_ID_DIGA;
+		break;
+	case DCE110_DIG_FE_SOURCE_SELECT_DIGB:
+		result = ENGINE_ID_DIGB;
+		break;
+	case DCE110_DIG_FE_SOURCE_SELECT_DIGC:
+		result = ENGINE_ID_DIGC;
+		break;
+	case DCE110_DIG_FE_SOURCE_SELECT_DIGD:
+		result = ENGINE_ID_DIGD;
+		break;
+	case DCE110_DIG_FE_SOURCE_SELECT_DIGE:
+		result = ENGINE_ID_DIGE;
+		break;
+	case DCE110_DIG_FE_SOURCE_SELECT_DIGF:
+		result = ENGINE_ID_DIGF;
+		break;
+	case DCE110_DIG_FE_SOURCE_SELECT_DIGG:
+		result = ENGINE_ID_DIGG;
+		break;
+	default:
+		// invalid source select DIG
+		result = ENGINE_ID_UNKNOWN;
+	}
+
+	return result;
+}
+
 void dce110_link_encoder_set_dp_phy_pattern_training_pattern(
 	struct link_encoder *enc,
 	uint32_t index)
@@ -1665,7 +1704,8 @@ static const struct link_encoder_funcs d
 	.disable_hpd = dce110_link_encoder_disable_hpd,
 	.is_dig_enabled = dce110_is_dig_enabled,
 	.destroy = dce110_link_encoder_destroy,
-	.get_max_link_cap = dce110_link_encoder_get_max_link_cap
+	.get_max_link_cap = dce110_link_encoder_get_max_link_cap,
+	.get_dig_frontend = dce110_get_dig_frontend
 };
 
 void dce60_link_encoder_construct(
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.h
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.h
@@ -295,6 +295,8 @@ void dce110_link_encoder_connect_dig_be_
 	enum engine_id engine,
 	bool connect);
 
+unsigned int dce110_get_dig_frontend(struct link_encoder *enc);
+
 void dce110_link_encoder_set_dp_phy_pattern_training_pattern(
 	struct link_encoder *enc,
 	uint32_t index);


