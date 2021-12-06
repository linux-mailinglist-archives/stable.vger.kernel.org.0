Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65FEE46AA03
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351008AbhLFVW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:22:57 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49326 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351185AbhLFVWr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:22:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1B8FECE1410;
        Mon,  6 Dec 2021 21:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4343EC341C6;
        Mon,  6 Dec 2021 21:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825554;
        bh=ijfdEIMXipzfofjjcBwYmFaTIINZkUL3W1yDWk+poaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kmzDBaV1ZZac8XmVsUL5rPz+HdXsBkXkhA2YMI1uHvienpy5l1H3LCL8BhY04PvCb
         UoiXPGWzPvFJWicApNe+06n127xZawWSYNxbYdw0qOqPjHUP+WyuOBJDvqW6JmD2Ga
         D0w2/lzUM74RCUuscWcNLZHqXGR2XhWinvazhaPDtKhRjh3w9uImZhYEPGKUUAD+gc
         tbNpDKhQrflMQzDw6ZZ78P4ERsSl57f2MjlKghKYIm809Q2shvhfGHZgZS1fXhv0Qg
         EYWqyM+0buEPnpIdFxPp2pVmbC+wPGC55M0kkwHmoGEY6dWdUY16ypKWh74DsKPQCo
         PfY5oImL4o6FA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mustapha Ghaddar <mghaddar@amd.com>, Jun Lei <Jun.Lei@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Mustapha Ghaddar <mustapha.ghaddar@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, aric.cyr@amd.com, mario.kleiner.de@gmail.com,
        Jimmy.Kizito@amd.com, liviu@dudau.co.uk, lee.jones@linaro.org,
        Dmytro.Laktyushkin@amd.com, Jerry.Zuo@amd.com,
        vladimir.stempen@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 08/10] drm/amd/display: Fix for the no Audio bug with Tiled Displays
Date:   Mon,  6 Dec 2021 16:17:27 -0500
Message-Id: <20211206211738.1661003-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211738.1661003-1-sashal@kernel.org>
References: <20211206211738.1661003-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mustapha Ghaddar <mghaddar@amd.com>

[ Upstream commit 5ceaebcda9061c04f439c93961f0819878365c0f ]

[WHY]
It seems like after a series of plug/unplugs we end up in a situation
where tiled display doesnt support Audio.

[HOW]
The issue seems to be related to when we check streams changed after an
HPD, we should be checking the audio_struct as well to see if any of its
values changed.

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Mustapha Ghaddar <mustapha.ghaddar@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index f25ac17f47fa9..95a5310e9e661 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1546,6 +1546,10 @@ bool dc_is_stream_unchanged(
 	if (old_stream->ignore_msa_timing_param != stream->ignore_msa_timing_param)
 		return false;
 
+	// Only Have Audio left to check whether it is same or not. This is a corner case for Tiled sinks
+	if (old_stream->audio_info.mode_count != stream->audio_info.mode_count)
+		return false;
+
 	return true;
 }
 
-- 
2.33.0

