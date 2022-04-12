Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927964FCA4F
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345298AbiDLAxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244191AbiDLAvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:51:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFDE32EF7;
        Mon, 11 Apr 2022 17:47:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4ECC9B819BC;
        Tue, 12 Apr 2022 00:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86207C385A4;
        Tue, 12 Apr 2022 00:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724450;
        bh=DDpiuvyZPMOVx2gNhL7oXsN4aLctbYZMvh6l2bO/8k4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h40daArEAgC2iJMn/9HXmJo6XnyogNGrUgPRzansfoVPW9WqNR0xFQ/87rR8vB77x
         8tVDjHQ318BV1WEfVBE//Fr/Us02DeGmp/iESokpRRxPZE7xAbGQ1zaYXK2WaqLTN0
         7i/wivY4RcBilltk9cxFal8JbMmWzVa6Nsfe+mW1pNUGdV629gsjS5/JGWj7AHL7Kg
         DtReIMHEwf5ItGCvEC8/xcMowuEe8GNQUP9Oupf4QmGcdZ2BytgCgN7VzmRVYALNNU
         U/RmtJAwAz3e0iog3gLdurdeyUFLTnOKhOU/r/LE3CD1eF4vxmsc6SGwWA9OWCAVTK
         B0oYyTWGs8Utg==
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
        aric.cyr@amd.com, meenakshikumar.somasundaram@amd.com,
        michael.strauss@amd.com, Martin.Leung@amd.com,
        Jimmy.Kizito@amd.com, Eric.Yang2@amd.com, lee.jones@linaro.org,
        wenjing.liu@amd.com, roy.chan@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 07/41] drm/amd/display: FEC check in timing validation
Date:   Mon, 11 Apr 2022 20:46:19 -0400
Message-Id: <20220412004656.350101-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004656.350101-1-sashal@kernel.org>
References: <20220412004656.350101-1-sashal@kernel.org>
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
index b37c4d2e7a1e..35a27fe48f66 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1377,6 +1377,10 @@ bool dc_validate_seamless_boot_timing(const struct dc *dc,
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

