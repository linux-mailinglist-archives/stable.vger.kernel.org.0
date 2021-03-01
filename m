Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA63432867C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237342AbhCARLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:11:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:35372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236692AbhCAREW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:04:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9754D64FF4;
        Mon,  1 Mar 2021 16:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616770;
        bh=NzDcQ8lTX9om9ZZH8fgDUHt2fkdvcrw0G/E9TltytjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aJ7b6nh2mPW1E8wyrj5U+nIFPbXHUK5J4ngFES0wt8dh8JiF08KPdabx3mvcyyhQS
         pwD5zkSQD2JV6nhTIyLS6NKVJgvOHV//ZfeYD2nLzA3dsYvKVReCx4e+neVmolykBz
         c4qxeVzwqqjiQ/PeNzuteOMU7VZvz8kH6657qV4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mario Kleiner <mario.kleiner.de@gmail.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 088/247] drm/amd/display: Fix 10/12 bpc setup in DCE output bit depth reduction.
Date:   Mon,  1 Mar 2021 17:11:48 +0100
Message-Id: <20210301161035.992143519@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Kleiner <mario.kleiner.de@gmail.com>

[ Upstream commit 1916866dfa4aaceba1a70db83fde569387649d93 ]

In set_clamp(), the comments and definitions for the COLOR_DEPTH_101010
and COLOR_DEPTH_121212 cases directly contradict the code comment which
explains how this should work, whereas the COLOR_DEPTH_888 case
is consistent with the code comments. Comment says the bitmask should
be chosen to align to the top-most 10 or 12 MSB's on a 14 bit bus, but
the implementation contradicts that: 10 bit case sets a mask for 12 bpc
clamping, whereas 12 bit case sets a mask for 14 bpc clamping.

Note that during my limited testing on DCE-8.3 (HDMI deep color)
and DCE-11.2 (DP deep color), this didn't have any obvious ill
effects, neither did fixing it change anything obvious for the
better, so this fix may be inconsequential on DCE, and just
reduce the confusion of innocent bystanders when reading the code
and trying to investigate problems with 10 bpc+ output.

Fixes: 4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")

Signed-off-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_transform.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c b/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c
index ab63d0d0304cb..6fd57cfb112f5 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c
@@ -429,12 +429,12 @@ static void set_clamp(
 		clamp_max = 0x3FC0;
 		break;
 	case COLOR_DEPTH_101010:
-		/* 10bit MSB aligned on 14 bit bus '11 1111 1111 1100' */
-		clamp_max = 0x3FFC;
+		/* 10bit MSB aligned on 14 bit bus '11 1111 1111 0000' */
+		clamp_max = 0x3FF0;
 		break;
 	case COLOR_DEPTH_121212:
-		/* 12bit MSB aligned on 14 bit bus '11 1111 1111 1111' */
-		clamp_max = 0x3FFF;
+		/* 12bit MSB aligned on 14 bit bus '11 1111 1111 1100' */
+		clamp_max = 0x3FFC;
 		break;
 	default:
 		clamp_max = 0x3FC0;
-- 
2.27.0



