Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FECD3D76A2
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237124AbhG0NaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:30:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236679AbhG0NUQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:20:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CD1061AA2;
        Tue, 27 Jul 2021 13:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627391972;
        bh=z2FjiORDyxIYRNRSzL6v0RUHqVEtdMKdX2dCqsCiIac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JSc3d82AhyYyfhtpPR648CLNGQh/zrpDfoN1qWxgsBtUrZamqmDhgG1gRnix5tlK2
         HzwUaSu3IjxK2PQyc8Rgnr+y2iETJOQqfD9/dRmPRTDlLs5fFIG3As8nbhxmz3XCGm
         4sEAiFtA9EJrw2RVW8aLIY6pmvVMmsP017b+GyxKJFVsDF1Aws/i73JZq4uvVcNtUE
         6kqlDSQjqWT8XuGoaRnZMvBXhO5FdMKbPXANjs8kID3PUY5rZCc5aBEd7iCZ2d2LHQ
         vNkj5ATYFSLy5tuZ3pFLkxVaDzFqgk/0kC356Q8SbMo//MPVUkEnlKRTYCyhYA1xCF
         FGk1RGwIPGS+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Victor Lu <victorchengchi.lu@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Yongqiang Sun <Yongqiang.Sun@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 17/21] drm/amd/display: Fix comparison error in dcn21 DML
Date:   Tue, 27 Jul 2021 09:19:04 -0400
Message-Id: <20210727131908.834086-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727131908.834086-1-sashal@kernel.org>
References: <20210727131908.834086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Victor Lu <victorchengchi.lu@amd.com>

[ Upstream commit ec3102dc6b36c692104c4a0546d4119de59a3bc1 ]

[why]
A comparison error made it possible to not iterate through all the
specified prefetch modes.

[how]
Correct "<" to "<="

Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Reviewed-by: Yongqiang Sun <Yongqiang.Sun@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Victor Lu <victorchengchi.lu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c b/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c
index 398210d1af34..f49743929357 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c
@@ -4889,7 +4889,7 @@ void dml21_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 				}
 			} while ((locals->PrefetchSupported[i][j] != true || locals->VRatioInPrefetchSupported[i][j] != true)
 					&& (mode_lib->vba.NextMaxVStartup != mode_lib->vba.MaxMaxVStartup[0][0]
-						|| mode_lib->vba.NextPrefetchMode < mode_lib->vba.MaxPrefetchMode));
+						|| mode_lib->vba.NextPrefetchMode <= mode_lib->vba.MaxPrefetchMode));
 
 			if (locals->PrefetchSupported[i][j] == true && locals->VRatioInPrefetchSupported[i][j] == true) {
 				mode_lib->vba.BandwidthAvailableForImmediateFlip = locals->ReturnBWPerState[i][0];
-- 
2.30.2

