Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C195497E00
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 12:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237545AbiAXLay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 06:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237517AbiAXLay (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 06:30:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A8AC06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 03:30:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7711FB80CD1
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 11:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19BEC340E1;
        Mon, 24 Jan 2022 11:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643023851;
        bh=CQNinU484sqpGG0lWkL5knAaLJDv4FurAmZ8w/9/JO4=;
        h=Subject:To:Cc:From:Date:From;
        b=PuqSVkdtEO4K4C9Q+7L+dDaDrX0BHubKY28x3giaO2gS8tXVURggp02VvehUA5Aid
         8ldqjYj1tO3ukvfts6M7yMO2jr9+RK1kl2Ph+CSmq3cUqpz8YMBmwj+IBdyQxnHIbK
         wfsNWJGTQAhOmq8T32wGuPa7SsbV55NVrb3c1QME=
Subject: FAILED: patch "[PATCH] drm/vc4: hdmi: Check the device state in prepare()" failed to apply to 5.16-stable tree
To:     maxime@cerno.tech, daniel.vetter@ffwll.ch
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 12:30:40 +0100
Message-ID: <1643023840130185@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a64ff88cb5eb0b9a6855a24ff326e948931e3a8e Mon Sep 17 00:00:00 2001
From: Maxime Ripard <maxime@cerno.tech>
Date: Mon, 25 Oct 2021 16:11:11 +0200
Subject: [PATCH] drm/vc4: hdmi: Check the device state in prepare()

Even though we already check that the encoder->crtc pointer is there
during in startup(), which is part of the open() path in ASoC, nothing
guarantees that our encoder state won't change between the time when we
open the device and the time we prepare it.

Move the sanity checks we do in startup() to a helper and call it from
prepare().

Link: https://lore.kernel.org/r/20211025141113.702757-8-maxime@cerno.tech
Fixes: 91e99e113929 ("drm/vc4: hdmi: Register HDMI codec")
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 71e3d1044d84..0adaa6f7eaef 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1395,20 +1395,36 @@ static inline struct vc4_hdmi *dai_to_hdmi(struct snd_soc_dai *dai)
 	return snd_soc_card_get_drvdata(card);
 }
 
+static bool vc4_hdmi_audio_can_stream(struct vc4_hdmi *vc4_hdmi)
+{
+	struct drm_encoder *encoder = &vc4_hdmi->encoder.base.base;
+
+	lockdep_assert_held(&vc4_hdmi->mutex);
+
+	/*
+	 * The encoder doesn't have a CRTC until the first modeset.
+	 */
+	if (!encoder->crtc)
+		return false;
+
+	/*
+	 * If the encoder is currently in DVI mode, treat the codec DAI
+	 * as missing.
+	 */
+	if (!(HDMI_READ(HDMI_RAM_PACKET_CONFIG) & VC4_HDMI_RAM_PACKET_ENABLE))
+		return false;
+
+	return true;
+}
+
 static int vc4_hdmi_audio_startup(struct device *dev, void *data)
 {
 	struct vc4_hdmi *vc4_hdmi = dev_get_drvdata(dev);
-	struct drm_encoder *encoder = &vc4_hdmi->encoder.base.base;
 	unsigned long flags;
 
 	mutex_lock(&vc4_hdmi->mutex);
 
-	/*
-	 * If the HDMI encoder hasn't probed, or the encoder is
-	 * currently in DVI mode, treat the codec dai as missing.
-	 */
-	if (!encoder->crtc || !(HDMI_READ(HDMI_RAM_PACKET_CONFIG) &
-				VC4_HDMI_RAM_PACKET_ENABLE)) {
+	if (!vc4_hdmi_audio_can_stream(vc4_hdmi)) {
 		mutex_unlock(&vc4_hdmi->mutex);
 		return -ENODEV;
 	}
@@ -1538,6 +1554,11 @@ static int vc4_hdmi_audio_prepare(struct device *dev, void *data,
 
 	mutex_lock(&vc4_hdmi->mutex);
 
+	if (!vc4_hdmi_audio_can_stream(vc4_hdmi)) {
+		mutex_unlock(&vc4_hdmi->mutex);
+		return -EINVAL;
+	}
+
 	vc4_hdmi_audio_set_mai_clock(vc4_hdmi, sample_rate);
 
 	spin_lock_irqsave(&vc4_hdmi->hw_lock, flags);

