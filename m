Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45B2418631E
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbgCPCkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:40:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729719AbgCPCeC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:34:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16EE72074D;
        Mon, 16 Mar 2020 02:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326042;
        bh=9dMFvrNqxpUvePmXG+6FIyrL9b0WiSp7fU/JGA6+lSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ytlp+cv9/Kf/LWBmpgqkwg549yXFF5vj5zQR2eHtiQRUNYcln3x/nN3LNHftzIKfW
         rLldsG255oED0LSVhPeAOURK5ZTtWz/v0XPJP7bZeMnQouDhOlqeFaa0+e9/xO9x/V
         +KA6DMt2TtOKjhE3jsbcQUQ+/xwxGD3hYISrLP/w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josip Pavic <Josip.Pavic@amd.com>, Aric Cyr <Aric.Cyr@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 35/41] drm/amd/display: fix dcc swath size calculations on dcn1
Date:   Sun, 15 Mar 2020 22:33:13 -0400
Message-Id: <20200316023319.749-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316023319.749-1-sashal@kernel.org>
References: <20200316023319.749-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josip Pavic <Josip.Pavic@amd.com>

[ Upstream commit a0275dfc82c9034eefbeffd556cca6dd239d7925 ]

[Why]
Swath sizes are being calculated incorrectly. The horizontal swath size
should be the product of block height, viewport width, and bytes per
element, but the calculation uses viewport height instead of width. The
vertical swath size is similarly incorrectly calculated. The effect of
this is that we report the wrong DCC caps.

[How]
Use viewport width in the horizontal swath size calculation and viewport
height in the vertical swath size calculation.

Signed-off-by: Josip Pavic <Josip.Pavic@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubbub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubbub.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubbub.c
index a02c10e23e0d6..d163388c99a06 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubbub.c
@@ -840,8 +840,8 @@ static void hubbub1_det_request_size(
 
 	hubbub1_get_blk256_size(&blk256_width, &blk256_height, bpe);
 
-	swath_bytes_horz_wc = height * blk256_height * bpe;
-	swath_bytes_vert_wc = width * blk256_width * bpe;
+	swath_bytes_horz_wc = width * blk256_height * bpe;
+	swath_bytes_vert_wc = height * blk256_width * bpe;
 
 	*req128_horz_wc = (2 * swath_bytes_horz_wc <= detile_buf_size) ?
 			false : /* full 256B request */
-- 
2.20.1

