Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08E36A7C03
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 08:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjCBHtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 02:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjCBHtA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 02:49:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF6B136E9;
        Wed,  1 Mar 2023 23:48:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADB88B811D5;
        Thu,  2 Mar 2023 07:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE5FC433D2;
        Thu,  2 Mar 2023 07:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677743337;
        bh=FQxdqTVGL5Tmo2kQBo5EKP1J2REHE/x51/IRsTKSVWs=;
        h=From:To:Cc:Subject:Date:From;
        b=XspEgExULtgYyT2/JSwBsz6FMWvp73M05fblk0rUDtaIkFTNpa3sdJCl6KS+PB82O
         0LdrLpkJ3AJUGRWSrxuDxTRFwww4PHuL8dwQU+E3j9ZvDAicnUkuLaraD9IcFZxu8l
         RjPkuwP7WBg+veLyRJJhKrXA00wQHuwtfLADH41PV4xo293Pe9wtVthupiOvAckp6a
         H3GgcdBwxKozZR+64id5HFNFjaFmaJoWMa3xVoHHgslcFcby4bM8TWbnU+N4yx/4IZ
         b2Ltl7/MMiFVggQcODjkdw2E6CpHAXmjw3abDL0ZKFi8jEE8PGJRw6K/t/m4eZDZO8
         0PKvdSU99bu4w==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pXdgq-0002yX-KC; Thu, 02 Mar 2023 08:49:25 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>
Cc:     Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Douglas Anderson <dianders@chromium.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] drm/edid: fix info leak when failing to get panel id
Date:   Thu,  2 Mar 2023 08:47:04 +0100
Message-Id: <20230302074704.11371-1-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to clear the transfer buffer before fetching the EDID to
avoid leaking slab data to the logs on errors that leave the buffer
unchanged.

Fixes: 69c7717c20cc ("drm/edid: Dump the EDID when drm_edid_get_panel_id() has an error")
Cc: stable@vger.kernel.org	# 6.2
Cc: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/gpu/drm/drm_edid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 3841aba17abd..8707fe72a028 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -2797,7 +2797,7 @@ u32 drm_edid_get_panel_id(struct i2c_adapter *adapter)
 	 * the EDID then we'll just return 0.
 	 */
 
-	base_block = kmalloc(EDID_LENGTH, GFP_KERNEL);
+	base_block = kzalloc(EDID_LENGTH, GFP_KERNEL);
 	if (!base_block)
 		return 0;
 
-- 
2.39.2

