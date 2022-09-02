Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5222A5AB061
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237990AbiIBMxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236398AbiIBMwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:52:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5A75C9CE;
        Fri,  2 Sep 2022 05:37:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3622FB82A71;
        Fri,  2 Sep 2022 12:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DCBC433C1;
        Fri,  2 Sep 2022 12:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122179;
        bh=V3FkCwM9i+GoSL/R/1gavDi9ac9+8/zlCT8RN7PV1BA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OsdJUfyo17IzaeVidKDeFfptxkMNu3tgtx6KSL6bjTUZvA2LHYA5y6LpKj91OX79H
         K4e+b9AGmGhHHllZIlPKRdQcnu2L5XwvS3rotqBCV60fRDCfnd/H+uDEzb730oMwfH
         HFX5d8EhxqdoxkMYqpB8Y+zAFsFz6hrU5Ygd1Cs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josip Pavic <Josip.Pavic@amd.com>,
        Jun Lei <Jun.Lei@amd.com>, Alex Hung <alex.hung@amd.com>,
        Aric Cyr <aric.cyr@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 38/72] drm/amd/display: Avoid MPC infinite loop
Date:   Fri,  2 Sep 2022 14:19:14 +0200
Message-Id: <20220902121406.033457164@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Josip Pavic <Josip.Pavic@amd.com>

[ Upstream commit 8de297dc046c180651c0500f8611663ae1c3828a ]

[why]
In some cases MPC tree bottom pipe ends up point to itself.  This causes
iterating from top to bottom to hang the system in an infinite loop.

[how]
When looping to next MPC bottom pipe, check that the pointer is not same
as current to avoid infinite loop.

Reviewed-by: Josip Pavic <Josip.Pavic@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Aric Cyr <aric.cyr@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c | 6 ++++++
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.c | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c
index 11019c2c62ccb..8192f1967e924 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c
@@ -126,6 +126,12 @@ struct mpcc *mpc1_get_mpcc_for_dpp(struct mpc_tree *tree, int dpp_id)
 	while (tmp_mpcc != NULL) {
 		if (tmp_mpcc->dpp_id == dpp_id)
 			return tmp_mpcc;
+
+		/* avoid circular linked list */
+		ASSERT(tmp_mpcc != tmp_mpcc->mpcc_bot);
+		if (tmp_mpcc == tmp_mpcc->mpcc_bot)
+			break;
+
 		tmp_mpcc = tmp_mpcc->mpcc_bot;
 	}
 	return NULL;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.c
index 15734db0cdea4..f3c311d093197 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.c
@@ -531,6 +531,12 @@ static struct mpcc *mpc2_get_mpcc_for_dpp(struct mpc_tree *tree, int dpp_id)
 	while (tmp_mpcc != NULL) {
 		if (tmp_mpcc->dpp_id == 0xf || tmp_mpcc->dpp_id == dpp_id)
 			return tmp_mpcc;
+
+		/* avoid circular linked list */
+		ASSERT(tmp_mpcc != tmp_mpcc->mpcc_bot);
+		if (tmp_mpcc == tmp_mpcc->mpcc_bot)
+			break;
+
 		tmp_mpcc = tmp_mpcc->mpcc_bot;
 	}
 	return NULL;
-- 
2.35.1



