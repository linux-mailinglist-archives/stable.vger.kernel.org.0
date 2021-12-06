Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D411C46A9D6
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350851AbhLFVUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:20:43 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48502 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350483AbhLFVUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:20:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E5477CE1626;
        Mon,  6 Dec 2021 21:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70BDC341C8;
        Mon,  6 Dec 2021 21:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825428;
        bh=fanTPIOiggeE08IYJBl2qo9gpsCFENd0t+vdv02drJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=btfywATqm5Fby+DYDUk9zXaakCiRMJebhUsHZtvyAWBDG/EbTmUJoiP+VlUFDCrCy
         9wxm8cTAGqwyy3kSkLfMdhBq399gdBASldBCDGH+azL+Q9/1m4pEdqmLLo5DOaozvD
         DgM8gKTmlwGQAJm9L+5orMvbeMAdGoGB7ILa8aPSjLpQNwOUW9t2mmmU/Zm6K44x66
         9WduOLULAJVIeHcM82WHCwWllhfojx9HTJ+ksWU0ViI5uhjlUbqTFJ4RmkSp/PoB59
         +ZcMnNniabohUSDqk9p0FD34ArxDtf8UWRz8V6pVNd3UnJfGCb13pub0P7Ou4SG/dF
         hoBPJ5rmMUKCg==
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
        daniel@ffwll.ch, aric.cyr@amd.com, nicholas.kazlauskas@amd.com,
        mario.kleiner.de@gmail.com, Jimmy.Kizito@amd.com,
        Dmytro.Laktyushkin@amd.com, Jerry.Zuo@amd.com,
        vladimir.stempen@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 13/15] drm/amd/display: Fix for the no Audio bug with Tiled Displays
Date:   Mon,  6 Dec 2021 16:15:13 -0500
Message-Id: <20211206211520.1660478-13-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211520.1660478-1-sashal@kernel.org>
References: <20211206211520.1660478-1-sashal@kernel.org>
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
index 59d48cf819ea8..5f4cdb05c4db9 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1698,6 +1698,10 @@ bool dc_is_stream_unchanged(
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

