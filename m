Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8397D582F5F
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239262AbiG0RZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241817AbiG0RX6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:23:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB687B1DB;
        Wed, 27 Jul 2022 09:46:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20668B821D6;
        Wed, 27 Jul 2022 16:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E79C433D6;
        Wed, 27 Jul 2022 16:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940355;
        bh=q8Ov8be4qwisSLNLiF3Apy5coHceXShTJRLQIfONrDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=drQAAgXWKcq+GzrPaJx/syqcYXxegbLs1SgdInqi+UrqAC6V8bA8eRYwz8nKgJEC8
         mkpyunXFadYyZ3KKC5EqdljZpL236vOCAS9joLGC+GQcMEq/96z/Dp6A9dP4KmkWEU
         YDfgCBlZZQ+XTtM69BIi/jl0MAmACRoov7dwZgbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jude Shih <shenshih@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 195/201] drm/amd/display: Dont lock connection_mutex for DMUB HPD
Date:   Wed, 27 Jul 2022 18:11:39 +0200
Message-Id: <20220727161035.852969586@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit d82b3266ef88dc10fe0e7031b2bd8ba7eedb7e59 upstream.

[Why]
Per DRM spec we only need to hold that lock when touching
connector->state - which we do not do in that handler.

Taking this locking introduces unnecessary dependencies with other
threads which is bad for performance and opens up the potential for
a deadlock since there are multiple locks being held at once.

[How]
Remove the connection_mutex lock/unlock routine and just iterate over
the drm connectors normally. The iter helpers implicitly lock the
connection list so this is safe to do.

DC link access also does not need to be guarded since the link
table is static at creation - we don't dynamically add or remove links,
just streams.

Fixes: e27c41d5b068 ("drm/amd/display: Support for DMUB HPD interrupt handling")

Reviewed-by: Jude Shih <shenshih@amd.com>
Acked-by: Anson Jacob <Anson.Jacob@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -668,10 +668,7 @@ void dmub_hpd_callback(struct amdgpu_dev
 		return;
 	}
 
-	drm_modeset_lock(&dev->mode_config.connection_mutex, NULL);
-
 	link_index = notify->link_index;
-
 	link = adev->dm.dc->links[link_index];
 
 	drm_connector_list_iter_begin(dev, &iter);
@@ -684,7 +681,6 @@ void dmub_hpd_callback(struct amdgpu_dev
 		}
 	}
 	drm_connector_list_iter_end(&iter);
-	drm_modeset_unlock(&dev->mode_config.connection_mutex);
 
 }
 


