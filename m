Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D366BB058
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbjCOMRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjCOMRe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:17:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDDC94A4B
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:17:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA026B81DF8
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE58C433D2;
        Wed, 15 Mar 2023 12:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882630;
        bh=gg7CyZ2D7X39u6zpFvL2Ah8BqXunxCFsIzNbg692VnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOQskjxo/8RJVkH7tdpsHCeHk5qygV9WbPD4FtsyTm6igHiy9/GsyLnUWVJdRPgp9
         di36mVktzwAfS5CpeYzpoMwdmSzO2oXuEFgYDZ87/YUQCfWLyO9ErTEiXASj7aCxH5
         m6T9gVxCQtYCyBOl3G4IdGo+dndp9uBfSf++TeBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Harry Wentland <harry.wentland@amd.com>,
        Pekka Paalanen <ppaalanen@gmail.com>,
        Sebastian Wick <sebastian.wick@redhat.com>,
        Vitaly.Prosyak@amd.com, Uma Shankar <uma.shankar@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Joshua Ashton <joshua@froggi.es>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 03/68] drm/connector: print max_requested_bpc in state debugfs
Date:   Wed, 15 Mar 2023 13:11:57 +0100
Message-Id: <20230315115726.237855960@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harry Wentland <harry.wentland@amd.com>

commit 7d386975f6a495902e679a3a250a7456d7e54765 upstream.

This is useful to understand the bpc defaults and
support of a driver.

Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Cc: Pekka Paalanen <ppaalanen@gmail.com>
Cc: Sebastian Wick <sebastian.wick@redhat.com>
Cc: Vitaly.Prosyak@amd.com
Cc: Uma Shankar <uma.shankar@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Joshua Ashton <joshua@froggi.es>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org
Cc: amd-gfx@lists.freedesktop.org
Reviewed-By: Joshua Ashton <joshua@froggi.es>
Link: https://patchwork.freedesktop.org/patch/msgid/20230113162428.33874-3-harry.wentland@amd.com
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_atomic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -1006,6 +1006,7 @@ static void drm_atomic_connector_print_s
 	drm_printf(p, "connector[%u]: %s\n", connector->base.id, connector->name);
 	drm_printf(p, "\tcrtc=%s\n", state->crtc ? state->crtc->name : "(null)");
 	drm_printf(p, "\tself_refresh_aware=%d\n", state->self_refresh_aware);
+	drm_printf(p, "\tmax_requested_bpc=%d\n", state->max_requested_bpc);
 
 	if (connector->connector_type == DRM_MODE_CONNECTOR_WRITEBACK)
 		if (state->writeback_job && state->writeback_job->fb)


