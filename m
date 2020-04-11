Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC5271A579A
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729801AbgDKXMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729802AbgDKXMY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:12:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A51C20708;
        Sat, 11 Apr 2020 23:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646744;
        bh=aDChP5idrZ/k+CYEo72uydj4YxtXZTloiRawtuaXssw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iW4BYERkKMJTceP6vyFkf2HauFhmfBVOzg7qB2w0h77rRcb0/371vfrJjQ/rYxPJS
         0GIfFLgLcu+n+AiFcSZJ/MPgqlzt2+d4Swjc67Png/4NDiCafWoVezBC1oTEb4tyh5
         nHaeMDSNkIxAzorrOIcRkKVrEp+U7cA+b31U73I4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Leung <martin.leung@amd.com>, Aric Cyr <Aric.Cyr@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 17/66] drm/amd/display: writing stereo polarity register if swapped
Date:   Sat, 11 Apr 2020 19:11:14 -0400
Message-Id: <20200411231203.25933-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231203.25933-1-sashal@kernel.org>
References: <20200411231203.25933-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Leung <martin.leung@amd.com>

[ Upstream commit e592e85f3378246dd66b861fa60ef803d8cece6b ]

[why]
on some displays that prefer swapped polarity we were seeing L/R images
swapped because OTG_STEREO_SYNC_OUTPUT_POLARITY would always be mapped
to 0

[how]
fix initial dal3 implementation to properly update the polarity field
according to the crtc_stereo_flags (same as
OTG_STEREO_EYE_FLAG_POLARITY)

Signed-off-by: Martin Leung <martin.leung@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c
index 411f89218e019..ff3a87c9d5194 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c
@@ -1161,7 +1161,7 @@ static void optc1_enable_stereo(struct timing_generator *optc,
 			REG_UPDATE_3(OTG_STEREO_CONTROL,
 				OTG_STEREO_EN, stereo_en,
 				OTG_STEREO_SYNC_OUTPUT_LINE_NUM, 0,
-				OTG_STEREO_SYNC_OUTPUT_POLARITY, 0);
+				OTG_STEREO_SYNC_OUTPUT_POLARITY, flags->RIGHT_EYE_POLARITY == 0 ? 0 : 1);
 
 		if (flags->PROGRAM_POLARITY)
 			REG_UPDATE(OTG_STEREO_CONTROL,
-- 
2.20.1

