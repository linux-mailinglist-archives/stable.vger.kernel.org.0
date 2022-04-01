Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE414EF157
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348256AbiDAOhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245702AbiDAOe5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:34:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DCB326EC;
        Fri,  1 Apr 2022 07:33:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B009E61CFE;
        Fri,  1 Apr 2022 14:33:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64270C2BBE4;
        Fri,  1 Apr 2022 14:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823587;
        bh=ZUcLceOkw7Vd2G5l6HGwom8StO7JnT3uCCURl3fyWaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pYI4cjJXERdTuDhbkOvMkJoMl4Bw73lglbig8Wmily8niBygtChaj2GI14wBZrQx+
         4CjpZTdy3hli8cwThmGPj4GH16p80uSwB/NpzxsxtlsDId5dQAwbbvdcJvayBchhKI
         0aAtaHqdSt1K62yeqqY6TdVzJXfEiWeO/ITuZBhFBsZCy3VpAdlHa+E/3sxenwK3S5
         NKcr3yiCCYym8z0bFTGKzzAdIE2m3DR2pPAFVqMNzia1XG6kwu4UnQgiJx6LYyL7zd
         RKpfgNaSDsW7DKlyDHCDrJxvYXtSnJ+iE/Xx7UmC+vy15b14wpKf7JK1YctlDCYk77
         XNenk1FYljcjw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dale Zhao <dale.zhao@amd.com>, Aric Cyr <Aric.Cyr@amd.com>,
        Wayne Lin <wayne.lin@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, Jun.Lei@amd.com, aric.cyr@amd.com,
        Jimmy.Kizito@amd.com, wenjing.liu@amd.com,
        nicholas.kazlauskas@amd.com, mario.kleiner.de@gmail.com,
        Dmytro.Laktyushkin@amd.com, Jerry.Zuo@amd.com,
        meenakshikumar.somasundaram@amd.com, eric.bernstein@amd.com,
        Martin.Leung@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.16 003/109] drm/amd/display: Add signal type check when verify stream backends same
Date:   Fri,  1 Apr 2022 10:31:10 -0400
Message-Id: <20220401143256.1950537-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dale Zhao <dale.zhao@amd.com>

[ Upstream commit 047db281c026de5971cedb5bb486aa29bd16a39d ]

[Why]
For allow eDP hot-plug feature, the stream signal may change to VIRTUAL
when plug-out and back to eDP when plug-in. OS will still setPathMode
with same timing for each plugging, but eDP gets no stream update as we
don't check signal type changing back as keeping it VIRTUAL. It's also
unsafe for future cases that stream signal is switched with same timing.

[How]
Check stream signal type change include previous HDMI signal case.

Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Dale Zhao <dale.zhao@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 6b066ceab412..3aa2040d2475 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1640,6 +1640,9 @@ static bool are_stream_backends_same(
 	if (is_timing_changed(stream_a, stream_b))
 		return false;
 
+	if (stream_a->signal != stream_b->signal)
+		return false;
+
 	if (stream_a->dpms_off != stream_b->dpms_off)
 		return false;
 
-- 
2.34.1

