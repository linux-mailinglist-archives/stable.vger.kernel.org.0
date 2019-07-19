Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9EE6D9A5
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 05:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfGSD5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:57:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727331AbfGSD52 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:57:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD60F2082E;
        Fri, 19 Jul 2019 03:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508647;
        bh=yEuq9qmtwlQ6EVFE9yGT/ICC0dbzEFSnl182tenkVHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQ5HxR2NCzkF2FnFF3WHVEpY/BmK3GTS4oxT1gjVF4bpXBWjxWNf77paiELhgchpz
         6HNSOGB2Zp941KOD4iLflfWEi7EohtCIWpzDF83XJjxpskRXQIYPYhaL3q5MStUKoZ
         C8TLTlSvIURW7AejpVItLIMg+B2EVMglNiuh1ilY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Roman Li <Roman.Li@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 018/171] drm/amd/display: Fill prescale_params->scale for RGB565
Date:   Thu, 18 Jul 2019 23:54:09 -0400
Message-Id: <20190719035643.14300-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 1352c779cb74d427f4150cbe779a2f7886f70cae ]

[Why]
An assertion is thrown when using SURFACE_PIXEL_FORMAT_GRPH_RGB565
formats on DCE since the prescale_params->scale wasn't being filled.

Found by a dmesg-fail when running the
igt@kms_plane@pixel-format-pipe-a-planes test on Baffin.

[How]
Fill in the scale parameter.

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Roman Li <Roman.Li@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
index 7ac50ab1b762..7d7e93c87c28 100644
--- a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
@@ -242,6 +242,9 @@ static void build_prescale_params(struct ipp_prescale_params *prescale_params,
 	prescale_params->mode = IPP_PRESCALE_MODE_FIXED_UNSIGNED;
 
 	switch (plane_state->format) {
+	case SURFACE_PIXEL_FORMAT_GRPH_RGB565:
+		prescale_params->scale = 0x2082;
+		break;
 	case SURFACE_PIXEL_FORMAT_GRPH_ARGB8888:
 	case SURFACE_PIXEL_FORMAT_GRPH_ABGR8888:
 		prescale_params->scale = 0x2020;
-- 
2.20.1

