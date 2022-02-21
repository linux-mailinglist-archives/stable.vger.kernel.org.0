Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038D94BE88D
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349050AbiBUJXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:23:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350315AbiBUJWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:22:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19755381A8;
        Mon, 21 Feb 2022 01:09:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F27E608C4;
        Mon, 21 Feb 2022 09:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DEA9C340E9;
        Mon, 21 Feb 2022 09:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434592;
        bh=GD8jGo6Q+HJ1uMXDjuZtebM7kKMzIBsEqRPZY3MkF0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V/kqUpcMi20UACvqF4aTPkk1Tr5+D4NWETF+ZHCwwNHQ7tpX/qv/82gQC570JwDya
         XFHd3ColZKwYoKgFXIznkJsCYrwxC5H2CKEBa7rEvXB0lbGShjhkVkYTeZsO5zaGDD
         K131+SfK96JxkFM4TjXrgrOAF7rF2V+LPnh2iZto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, fuyufan <fuyufan@huawei.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.15 062/196] drm/atomic: Dont pollute crtc_state->mode_blob with error pointers
Date:   Mon, 21 Feb 2022 09:48:14 +0100
Message-Id: <20220221084933.007550158@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 439cf34c8e0a8a33d8c15a31be1b7423426bc765 upstream.

Make sure we don't assign an error pointer to crtc_state->mode_blob
as that will break all kinds of places that assume either NULL or a
valid pointer (eg. drm_property_blob_put()).

Cc: stable@vger.kernel.org
Reported-by: fuyufan <fuyufan@huawei.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220209091928.14766-1-ville.syrjala@linux.intel.com
Acked-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_atomic_uapi.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/drm_atomic_uapi.c
+++ b/drivers/gpu/drm/drm_atomic_uapi.c
@@ -76,15 +76,17 @@ int drm_atomic_set_mode_for_crtc(struct
 	state->mode_blob = NULL;
 
 	if (mode) {
+		struct drm_property_blob *blob;
+
 		drm_mode_convert_to_umode(&umode, mode);
-		state->mode_blob =
-			drm_property_create_blob(state->crtc->dev,
-						 sizeof(umode),
-						 &umode);
-		if (IS_ERR(state->mode_blob))
-			return PTR_ERR(state->mode_blob);
+		blob = drm_property_create_blob(crtc->dev,
+						sizeof(umode), &umode);
+		if (IS_ERR(blob))
+			return PTR_ERR(blob);
 
 		drm_mode_copy(&state->mode, mode);
+
+		state->mode_blob = blob;
 		state->enable = true;
 		drm_dbg_atomic(crtc->dev,
 			       "Set [MODE:%s] for [CRTC:%d:%s] state %p\n",


