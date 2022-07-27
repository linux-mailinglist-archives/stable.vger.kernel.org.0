Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8279F582F66
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiG0RZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241820AbiG0RX6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:23:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C5F5F13F;
        Wed, 27 Jul 2022 09:46:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0123BB821BA;
        Wed, 27 Jul 2022 16:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4408AC433D6;
        Wed, 27 Jul 2022 16:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940358;
        bh=cy4gpRA98YLj8Iyj6Bl+z9CYy3YNiqaOtdXfRIfQZKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XRj997LZjg/sid8Y45sUp1bcA121KfkfAJ6ub909ep5RhlzhptgR9tPvtzQBWsexB
         QwHWoVGKRRgAMtOvIqG4Wrjca8TELkHP1frklogU6x1KmnkzcD7NZur2ZyCSNMjP+L
         CrjM1qJYAxhEeophfElVC/AQapajT4rdaWF3/GeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 196/201] drm/amd/display: invalid parameter check in dmub_hpd_callback
Date:   Wed, 27 Jul 2022 18:11:40 +0200
Message-Id: <20220727161035.901178428@linuxfoundation.org>
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

From: José Expósito <jose.exposito89@gmail.com>

commit 978ffac878fd64039f95798b15b430032d2d89d5 upstream.

The function performs a check on the "adev" input parameter, however, it
is used before the check.

Initialize the "dev" variable after the sanity check to avoid a possible
NULL pointer dereference.

Fixes: e27c41d5b0681 ("drm/amd/display: Support for DMUB HPD interrupt handling")
Addresses-Coverity-ID: 1493909 ("Null pointer dereference")
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -653,7 +653,7 @@ void dmub_hpd_callback(struct amdgpu_dev
 	struct drm_connector_list_iter iter;
 	struct dc_link *link;
 	uint8_t link_index = 0;
-	struct drm_device *dev = adev->dm.ddev;
+	struct drm_device *dev;
 
 	if (adev == NULL)
 		return;
@@ -670,6 +670,7 @@ void dmub_hpd_callback(struct amdgpu_dev
 
 	link_index = notify->link_index;
 	link = adev->dm.dc->links[link_index];
+	dev = adev->dm.ddev;
 
 	drm_connector_list_iter_begin(dev, &iter);
 	drm_for_each_connector_iter(connector, &iter) {


