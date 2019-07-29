Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 846C3797EB
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbfG2UEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 16:04:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390032AbfG2Tpx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:45:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2AE12171F;
        Mon, 29 Jul 2019 19:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429552;
        bh=ZY24zMzUl487W9Xmc++d2mlHBn6l28pMRDTmBKYGDcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kYTDqltIi04W86xvV6nXTkqTrJqgj/a/7Fk4rKXOwcISil7WlehuDbb7lHIVruReh
         TRiC6ekB0bmsGHq9KxrFlmOVb24MYwJkfeoI2msv3ZGOU/9NR8SIbI5LZOGrcSPwu4
         2DCBGdmATRJjeJ9Wv31f3W+/l8dLPc4gcaCS2lRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Roman Li <Roman.Li@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 020/215] drm/amd/display: Fill prescale_params->scale for RGB565
Date:   Mon, 29 Jul 2019 21:20:16 +0200
Message-Id: <20190729190743.225595152@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



