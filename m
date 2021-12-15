Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47D8475EB3
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245418AbhLORYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:24:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44400 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245445AbhLORXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:23:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CFEE61A14;
        Wed, 15 Dec 2021 17:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822CDC36AE0;
        Wed, 15 Dec 2021 17:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589021;
        bh=pQE60b+PjcLVTwWbBbEUh82jS+EsMmj4rNuXKiHL/qY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ofLRA5X2eo4k9gMrq9M8Z4XY2HoR8OftKb7+PiFRMDFsezxe3ZM/WxC1LF15MONtL
         XLlPON9fzbur6Vyp1gQhklKy8nI6su6w+an5+Tm4NFp+NrI5NgJnFocBuTl7jqEXeu
         MScz6mIuxtTA7ryP8+vMdd87k5w02nARP5+qZKPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Lei <Jun.Lei@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Mustapha Ghaddar <mustapha.ghaddar@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 35/42] drm/amd/display: Fix for the no Audio bug with Tiled Displays
Date:   Wed, 15 Dec 2021 18:21:16 +0100
Message-Id: <20211215172027.855542858@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a60396d5be445..e94546187cf15 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1623,6 +1623,10 @@ bool dc_is_stream_unchanged(
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



