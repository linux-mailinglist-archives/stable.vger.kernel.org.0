Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA7D4119A54
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbfLJVv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:51:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:54504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727594AbfLJVHu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:07:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7E2624688;
        Tue, 10 Dec 2019 21:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012069;
        bh=LA4jwc5q3lPFXscqOD5f2qDp4cgi4LzaCbXLHdoRLws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fs8XgcAWKNtXJ7iyIL8R8dVSPwdloZclkp3no5L66TyR32mZX0oziEKCHxYs7p9vs
         WXKeR0YlY0saTaYzN7QU05e9qkzj/FoB6xG2jjMqYt9Qe/YRG46xDJcK3ryH3QWhiC
         f8K0hI1POx1IWOZdIMrfxTvB/7WpM5TaEFAcNRFA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nikola Cornij <nikola.cornij@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 050/350] drm/amd/display: Set number of pipes to 1 if the second pipe was disabled
Date:   Tue, 10 Dec 2019 16:02:35 -0500
Message-Id: <20191210210735.9077-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikola Cornij <nikola.cornij@amd.com>

[ Upstream commit 2fef0faa1cdc5d41ce3ef83f7b8f7e7ecb02d700 ]

[why]
Some ODM-related register settings are inconsistently updated by VBIOS, causing
the state in DC to be invalid, which would then end up crashing in certain
use-cases (such as disable/enable device).

[how]
Check the enabled status of the second pipe when determining the number of
OPTC sources. If the second pipe is disabled, set the number of sources to 1
regardless of other settings (that may not be updated correctly).

Signed-off-by: Nikola Cornij <nikola.cornij@amd.com>
Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c
index 2137e2be21404..dda90995ba933 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c
@@ -287,6 +287,10 @@ void optc2_get_optc_source(struct timing_generator *optc,
 		*num_of_src_opp = 2;
 	else
 		*num_of_src_opp = 1;
+
+	/* Work around VBIOS not updating OPTC_NUM_OF_INPUT_SEGMENT */
+	if (*src_opp_id_1 == 0xf)
+		*num_of_src_opp = 1;
 }
 
 void optc2_set_dwb_source(struct timing_generator *optc,
-- 
2.20.1

