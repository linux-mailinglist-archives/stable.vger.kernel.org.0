Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED0238EFDA
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbhEXQAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:00:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235777AbhEXP7K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:59:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F7E161976;
        Mon, 24 May 2021 15:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871102;
        bh=wQ3cUDzajtzAgRCgFmhBdmz2T03T9h32BJQe1ALwaCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zy2yxtUhxiI1PTThnNo27YQiZlpSuC7wwOz2IRstJnBw6iH2J3hRmp0uqRAFJbnOo
         UUuBgaoaFOrVYulQA+7RCqzooJyu8ndIoKnTT/LVUA8kZYEGYpGutDr5k1aYnunB3F
         e4eKk4NdmR4wo5EgpEemvUwj5Lz2A9ErhmXcXLb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikola Cornij <nikola.cornij@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Harry Wentland <Harry.Wentland@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.12 075/127] drm/amd/display: Use the correct max downscaling value for DCN3.x family
Date:   Mon, 24 May 2021 17:26:32 +0200
Message-Id: <20210524152337.392160817@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikola Cornij <nikola.cornij@amd.com>

commit 84c63d040938f64a7dc195696301166e75231bf5 upstream.

[why]
As per spec, DCN3.x can do 6:1 downscaling and DCN2.x can do 4:1. The
max downscaling limit value for DCN2.x is 250, which means it's
calculated as 1000 / 4 = 250. For DCN3.x this then gives 1000 / 6 = 167.

[how]
Set maximum downscaling limit to 167 for DCN3.x

Signed-off-by: Nikola Cornij <nikola.cornij@amd.com>
Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Reviewed-by: Harry Wentland <Harry.Wentland@amd.com>
Acked-by: Stylon Wang <stylon.wang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c   |    7 ++++---
 drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c |    7 ++++---
 drivers/gpu/drm/amd/display/dc/dcn302/dcn302_resource.c |    7 ++++---
 3 files changed, 12 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
@@ -826,10 +826,11 @@ static const struct dc_plane_cap plane_c
 			.fp16 = 16000
 	},
 
+	/* 6:1 downscaling ratio: 1000/6 = 166.666 */
 	.max_downscale_factor = {
-			.argb8888 = 600,
-			.nv12 = 600,
-			.fp16 = 600
+			.argb8888 = 167,
+			.nv12 = 167,
+			.fp16 = 167
 	}
 };
 
--- a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
@@ -843,10 +843,11 @@ static const struct dc_plane_cap plane_c
 			.fp16 = 16000
 	},
 
+	/* 6:1 downscaling ratio: 1000/6 = 166.666 */
 	.max_downscale_factor = {
-			.argb8888 = 600,
-			.nv12 = 600,
-			.fp16 = 600
+			.argb8888 = 167,
+			.nv12 = 167,
+			.fp16 = 167
 	},
 	64,
 	64
--- a/drivers/gpu/drm/amd/display/dc/dcn302/dcn302_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn302/dcn302_resource.c
@@ -282,10 +282,11 @@ static const struct dc_plane_cap plane_c
 				.nv12 = 16000,
 				.fp16 = 16000
 		},
+		/* 6:1 downscaling ratio: 1000/6 = 166.666 */
 		.max_downscale_factor = {
-				.argb8888 = 600,
-				.nv12 = 600,
-				.fp16 = 600
+				.argb8888 = 167,
+				.nv12 = 167,
+				.fp16 = 167
 		},
 		16,
 		16


