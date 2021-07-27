Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53543D7672
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236623AbhG0N3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:29:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236941AbhG0NU3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:20:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC8BD61ABB;
        Tue, 27 Jul 2021 13:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627391997;
        bh=MDcVSK2GDmf3O0O+rkmm2pczFRVhWr9fQajH+o6Cd1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mf3r8P6bLhnxdqF7Yzijfy7MZwBxnHnFSyzj52xKWNQUUGpUf/4bop04j7TdQiZ1c
         WpQEU4q8RLu4uqkJ0Vo1/z25ZVWRmVgblp45gb9jIz+NaMf7RI91JVqYpJ9QuZJ4Uq
         qmnlpATIN0LdeE+JXExoqqXHj+wKiKw/7NVsks2vDrLBborMJZ3ISrY7DVma4AA1EV
         oxTrXm5BNSuIvwDq6Wes+HGoYkueT6yU1m0eIsyUyxLlUZix9jUUZvCoAMUyHmVcsV
         5M20VEj5ddf2O7e+78Qj6l24Qw1ALfTvF+HJw7c7raiGyzieCzwHcnObveryUWFkVJ
         R3puPLMwXRKbQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Victor Lu <victorchengchi.lu@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Yongqiang Sun <Yongqiang.Sun@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 15/17] drm/amd/display: Fix comparison error in dcn21 DML
Date:   Tue, 27 Jul 2021 09:19:36 -0400
Message-Id: <20210727131938.834920-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727131938.834920-1-sashal@kernel.org>
References: <20210727131938.834920-1-sashal@kernel.org>
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
index 367c82b5ab4c..c09bca335068 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c
@@ -4888,7 +4888,7 @@ void dml21_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 				}
 			} while ((locals->PrefetchSupported[i][j] != true || locals->VRatioInPrefetchSupported[i][j] != true)
 					&& (mode_lib->vba.NextMaxVStartup != mode_lib->vba.MaxMaxVStartup[0][0]
-						|| mode_lib->vba.NextPrefetchMode < mode_lib->vba.MaxPrefetchMode));
+						|| mode_lib->vba.NextPrefetchMode <= mode_lib->vba.MaxPrefetchMode));
 
 			if (locals->PrefetchSupported[i][j] == true && locals->VRatioInPrefetchSupported[i][j] == true) {
 				mode_lib->vba.BandwidthAvailableForImmediateFlip = locals->ReturnBWPerState[i][0];
-- 
2.30.2

