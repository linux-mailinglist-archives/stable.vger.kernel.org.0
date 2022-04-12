Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D144FCACF
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244702AbiDLA4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343574AbiDLAz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:55:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDFA20BE9;
        Mon, 11 Apr 2022 17:49:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 171A8612A8;
        Tue, 12 Apr 2022 00:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85054C385A3;
        Tue, 12 Apr 2022 00:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724564;
        bh=w7aXpuwOrzhppGfZ0NAyhIFazOsTIW/sc7x6w0mpvO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sbZi6wSO054UbIYStQaMjEtv6pSpjTUTPhc5BtI+PU+53KA5R73RGr38z1Y+4Fqnk
         zHWyWqHB8JaweYbOrSlwK3yHVclF8Fj7wLf8UDDuwVxoi74zsD+UHnxQrKzzgcwdhp
         EGicGQ2XZTkBSeKEx3TDjGw3ugcyD+6V3DdXPbvSCiLZXfVrMPWmLtyNoh7/5qmKCJ
         rHg+BTHXF3r9Fnlw20Wya4Rut/f/9plkk8baAsKtwt+DmCkEok63372fxPHLenuLW8
         vCq0pzw9i5RHipgrw6jjVGGkazM51+1wp3KVP+12C22qo3H+AEzomreitObCLxbtAR
         sYEly7bDVdC4A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chiawen Huang <chiawen.huang@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>,
        Alex Hung <alex.hung@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, nicholas.kazlauskas@amd.com, Wayne.Lin@amd.com,
        Jun.Lei@amd.com, meenakshikumar.somasundaram@amd.com,
        michael.strauss@amd.com, Martin.Leung@amd.com,
        Jimmy.Kizito@amd.com, Eric.Yang2@amd.com, lee.jones@linaro.org,
        wenjing.liu@amd.com, roy.chan@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 05/30] drm/amd/display: FEC check in timing validation
Date:   Mon, 11 Apr 2022 20:48:39 -0400
Message-Id: <20220412004906.350678-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004906.350678-1-sashal@kernel.org>
References: <20220412004906.350678-1-sashal@kernel.org>
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

From: Chiawen Huang <chiawen.huang@amd.com>

[ Upstream commit 7d56a154e22ffb3613fdebf83ec34d5225a22993 ]

[Why]
disable/enable leads FEC mismatch between hw/sw FEC state.

[How]
check FEC status to fastboot on/off.

Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Chiawen Huang <chiawen.huang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 93f5229c303e..ac5323596c65 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1173,6 +1173,10 @@ bool dc_validate_seamless_boot_timing(const struct dc *dc,
 	if (!link->link_enc->funcs->is_dig_enabled(link->link_enc))
 		return false;
 
+	/* Check for FEC status*/
+	if (link->link_enc->funcs->fec_is_active(link->link_enc))
+		return false;
+
 	enc_inst = link->link_enc->funcs->get_dig_frontend(link->link_enc);
 
 	if (enc_inst == ENGINE_ID_UNKNOWN)
-- 
2.35.1

