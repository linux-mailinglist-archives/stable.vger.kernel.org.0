Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33366A0A26
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234534AbjBWNNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234530AbjBWNNP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:13:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C4E567AC
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:12:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CA9D5CE202D
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D13C433D2;
        Thu, 23 Feb 2023 13:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157922;
        bh=4NpeXNkKztQgWnBJ1Mp2MpHtHvx/y+0D/p6NCQ0XCk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cMx4a97G2MK/SuHz4iVP/0TuRg6dc6hlsMzPqH5ZwYFLVAMIwTRmu/yBen7jGnmUf
         J7NcjoEEJDuDBrQ7rG80m4Nbh8o5Eur8qIIIvEqrWLRt5FualDj3RRYQpH4l5fo9hu
         4ttnL4lRa/bYP36JBGUVNhJIWRZnLVfEDDV+Sp6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 03/36] drm/edid: Fix minimum bpc supported with DSC1.2 for HDMI sink
Date:   Thu, 23 Feb 2023 14:06:39 +0100
Message-Id: <20230223130429.236181780@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130429.072633724@linuxfoundation.org>
References: <20230223130429.072633724@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ankit Nautiyal <ankit.k.nautiyal@intel.com>

[ Upstream commit 18feaf6d0784dcba888859109676adf1e0260dfd ]

HF-VSDB/SCDB has bits to advertise support for 16, 12 and 10 bpc.
If none of the bits are set, the minimum bpc supported with DSC is 8.

This patch corrects the min bpc supported to be 8, instead of 0.

Fixes: 76ee7b905678 ("drm/edid: Parse DSC1.2 cap fields from HFVSDB block")
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Cc: Uma Shankar <uma.shankar@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>

v2: s/DSC1.2/DSC 1.2

Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220916100551.2531750-2-ankit.k.nautiyal@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_edid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 6ab048ba8021c..d940c76419c5a 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -4942,7 +4942,8 @@ static void drm_parse_hdmi_forum_vsdb(struct drm_connector *connector,
 			else if (hf_vsdb[11] & DRM_EDID_DSC_10BPC)
 				hdmi_dsc->bpc_supported = 10;
 			else
-				hdmi_dsc->bpc_supported = 0;
+				/* Supports min 8 BPC if DSC 1.2 is supported*/
+				hdmi_dsc->bpc_supported = 8;
 
 			dsc_max_frl_rate = (hf_vsdb[12] & DRM_EDID_DSC_MAX_FRL_RATE_MASK) >> 4;
 			drm_get_max_frl_rate(dsc_max_frl_rate, &hdmi_dsc->max_lanes,
-- 
2.39.0



