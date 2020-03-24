Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3B4E190EFC
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgCXNQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:16:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728470AbgCXNQd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:16:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AAC8206F6;
        Tue, 24 Mar 2020 13:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055792;
        bh=9dMFvrNqxpUvePmXG+6FIyrL9b0WiSp7fU/JGA6+lSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wxoZQf1W5hEabs6qAVxAD7PebLk0cpS0xTco4QQk1XiTmkJZ6AYzA91pTJJs7w6QV
         Zu8b3bC2BGdhmORpQq6NUZ2RWTwdPGpikYkdtcYJpWpAgubnvkOLLlo7ucGH6mJrJ0
         gPq8Q3UOgMm7/G9/gAG0QkXNKx+yKu5wyfgEP61w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josip Pavic <Josip.Pavic@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/102] drm/amd/display: fix dcc swath size calculations on dcn1
Date:   Tue, 24 Mar 2020 14:10:22 +0100
Message-Id: <20200324130809.552286024@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130806.544601211@linuxfoundation.org>
References: <20200324130806.544601211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



