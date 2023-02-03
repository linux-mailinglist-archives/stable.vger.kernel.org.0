Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F8F68952B
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbjBCKQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbjBCKQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:16:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2067B93AFA
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:15:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60C61B829C8
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA91C433D2;
        Fri,  3 Feb 2023 10:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419354;
        bh=UnE3vT5uESBE6CIl+3rDhCyUoCgqJKfhAFu6i7XDVl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s0cDtN5jcJtoDvTs2ykZs3e3uu/J4kxmrp+rdx8C95GYMZ04GeXeq7gq81KCCMX/Y
         ghF2Zv6Trl0ReR4CF0a+GeVRw5//B2OuwpfRaqq5y1wNhpfgP2w+9Do1rNMxhFPyL5
         HdCMDruUogBukAasLDlaJgwY2E2DjFmy472vcIOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.14 41/62] drm/radeon/dp: make radeon_dp_get_dp_link_config static
Date:   Fri,  3 Feb 2023 11:12:37 +0100
Message-Id: <20230203101014.732770326@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit d3f04c98ead2b89887e1e3c09b26e4917bacdd9e upstream.

It's not used outside this file any longer.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/atombios_dp.c |    8 ++++----
 drivers/gpu/drm/radeon/radeon_mode.h |    4 ----
 2 files changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -302,10 +302,10 @@ static int convert_bpc_to_bpp(int bpc)
 
 /***** radeon specific DP functions *****/
 
-int radeon_dp_get_dp_link_config(struct drm_connector *connector,
-				 const u8 dpcd[DP_DPCD_SIZE],
-				 unsigned pix_clock,
-				 unsigned *dp_lanes, unsigned *dp_rate)
+static int radeon_dp_get_dp_link_config(struct drm_connector *connector,
+					const u8 dpcd[DP_DPCD_SIZE],
+					unsigned pix_clock,
+					unsigned *dp_lanes, unsigned *dp_rate)
 {
 	int bpp = convert_bpc_to_bpp(radeon_get_monitor_bpc(connector));
 	static const unsigned link_rates[3] = { 162000, 270000, 540000 };
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -762,10 +762,6 @@ extern u8 radeon_dp_getsinktype(struct r
 extern bool radeon_dp_getdpcd(struct radeon_connector *radeon_connector);
 extern int radeon_dp_get_panel_mode(struct drm_encoder *encoder,
 				    struct drm_connector *connector);
-extern int radeon_dp_get_dp_link_config(struct drm_connector *connector,
-					const u8 *dpcd,
-					unsigned pix_clock,
-					unsigned *dp_lanes, unsigned *dp_rate);
 extern void radeon_dp_set_rx_power_state(struct drm_connector *connector,
 					 u8 power_state);
 extern void radeon_dp_aux_init(struct radeon_connector *radeon_connector);


