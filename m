Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E84C06041EA
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbiJSKuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbiJSKrx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:47:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1217B15B130;
        Wed, 19 Oct 2022 03:21:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0DC3B822E9;
        Wed, 19 Oct 2022 08:48:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411C9C433B5;
        Wed, 19 Oct 2022 08:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169283;
        bh=fTvT0ik4f6kDJvAqramL4MzipGYW+zF36KCJGMNC4nM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wsKPwc9T7iBvam+l4ol+dV3okT9chMEqDL4F0xhdU29U+Q4rvsf4U1Pruh6AwhRou
         h7P+Akde1nMwzYGdygBho9lYXsdGPpOALeyGrcwaaPMlDSq2Gz/41BrihJSSOL4sz8
         d2FvAnC1eKAB68sRWCab1QeJy8LxVk+7byN24aeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Roman Li <Roman.Li@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Fangzhi Zuo <Jerry.Zuo@amd.com>,
        Mark Broadworth <mark.broadworth@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 193/862] drm/amd/display: Validate DSC After Enable All New CRTCs
Date:   Wed, 19 Oct 2022 10:24:40 +0200
Message-Id: <20221019083258.514244822@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

commit 876fcc4222e1d0e5b73343f4010a8b66be058f48 upstream.

Before enabling new crtc, stream_count in dc_state does not sync with
that in drm_atomic_state. Validating dsc in such case would leave newly
added stream not jointly participating in dsc optimization with existing
streams, but simply using default initialized vcpi all the time which
gives wrong dsc determination decision.

Consider the scenaio where one 4k60 connected to the dock under dp-alt mode.
Since dp-alt mode is 2-lane setup, stream 1 consumes 63 slots with dsc needed.
Then hook up a second 4k60 to the dock.
stream 2 connected with 65 slot initialized by default without dsc.  dsc
pre validate will not jointly optimize stream 2 with stream 1 before
crtc 2 added into the dc_state. That leads to stream 2 not getting dsc
optimization, and trigger atomic_check failure all the time, as 65 > 63
limit.

After getting all new crtcs added into the state, stream_count in
dc_state correctly reflect that in drm_atomic_state which comes up with
correct dsc decision.

Fixes: 71be4b16d39a ("drm/amd/display: dsc validate fail not pass to atomic check")
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Roman Li <Roman.Li@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9408,10 +9408,6 @@ static int amdgpu_dm_atomic_check(struct
 				}
 			}
 		}
-		if (!pre_validate_dsc(state, &dm_state, vars)) {
-			ret = -EINVAL;
-			goto fail;
-		}
 	}
 #endif
 	for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
@@ -9545,6 +9541,15 @@ static int amdgpu_dm_atomic_check(struct
 		}
 	}
 
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+	if (dc_resource_is_dsc_encoding_supported(dc)) {
+		if (!pre_validate_dsc(state, &dm_state, vars)) {
+			ret = -EINVAL;
+			goto fail;
+		}
+	}
+#endif
+
 	/* Run this here since we want to validate the streams we created */
 	ret = drm_atomic_helper_check_planes(dev, state);
 	if (ret) {


