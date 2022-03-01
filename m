Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9624C95AD
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237694AbiCAUP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237709AbiCAUPX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:15:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63F075C35;
        Tue,  1 Mar 2022 12:14:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7B188CE1E66;
        Tue,  1 Mar 2022 20:14:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A78AC340EE;
        Tue,  1 Mar 2022 20:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165677;
        bh=sxwcnYZrfijUZ0ABVlMivZuPH26mfl99x4mhbGdhlos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cqLj8vkk1MyIDCY+7ct1w4mKPJ4guzps6Nsu7KkHh9yCx80L5C7unZQhIsk3OlkHL
         UhKC6h+h0cFFODRz32bIeKuN0gC4xCw9spjYp4yP1nxUxhGpmlZkr0GFv+A8j0kFlD
         +X3we79E57BwqokuhEUrW0Lz7tB/+xsDUAxSYBC3jbfWzT0VV9prF6sMEbzpCAf/5g
         3UvgES3ExovXhMuQ/6Hm/EUfyIUyFdu+41LtERWrBVV7aCA0IUXAoonGTmkoXFSitV
         DQ1weDdzOnXJARrlLXjY7WIx71H6d/cYoUtuCdm19oqYCgAV9KdCrHyhYRBFymi5XE
         rKJeqEsrTz/hQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime@cerno.tech>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sasha Levin <sashal@kernel.org>, emma@anholt.net,
        mripard@kernel.org, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.16 10/28] drm/vc4: hdmi: Unregister codec device on unbind
Date:   Tue,  1 Mar 2022 15:13:15 -0500
Message-Id: <20220301201344.18191-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201344.18191-1-sashal@kernel.org>
References: <20220301201344.18191-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit e40945ab7c7f966d0c37b7bd7b0596497dfe228d ]

On bind we will register the HDMI codec device but we don't unregister
it on unbind, leading to a device leakage. Unregister our device at
unbind.

Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220127111452.222002-1-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 8 ++++++++
 drivers/gpu/drm/vc4/vc4_hdmi.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 24f11c07bc3c7..2f53ba54b81ac 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1522,6 +1522,7 @@ static int vc4_hdmi_audio_init(struct vc4_hdmi *vc4_hdmi)
 		dev_err(dev, "Couldn't register the HDMI codec: %ld\n", PTR_ERR(codec_pdev));
 		return PTR_ERR(codec_pdev);
 	}
+	vc4_hdmi->audio.codec_pdev = codec_pdev;
 
 	dai_link->cpus		= &vc4_hdmi->audio.cpu;
 	dai_link->codecs	= &vc4_hdmi->audio.codec;
@@ -1561,6 +1562,12 @@ static int vc4_hdmi_audio_init(struct vc4_hdmi *vc4_hdmi)
 
 }
 
+static void vc4_hdmi_audio_exit(struct vc4_hdmi *vc4_hdmi)
+{
+	platform_device_unregister(vc4_hdmi->audio.codec_pdev);
+	vc4_hdmi->audio.codec_pdev = NULL;
+}
+
 static irqreturn_t vc4_hdmi_hpd_irq_thread(int irq, void *priv)
 {
 	struct vc4_hdmi *vc4_hdmi = priv;
@@ -2299,6 +2306,7 @@ static void vc4_hdmi_unbind(struct device *dev, struct device *master,
 	kfree(vc4_hdmi->hdmi_regset.regs);
 	kfree(vc4_hdmi->hd_regset.regs);
 
+	vc4_hdmi_audio_exit(vc4_hdmi);
 	vc4_hdmi_cec_exit(vc4_hdmi);
 	vc4_hdmi_hotplug_exit(vc4_hdmi);
 	vc4_hdmi_connector_destroy(&vc4_hdmi->connector);
diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.h b/drivers/gpu/drm/vc4/vc4_hdmi.h
index 33e9f665ab8e4..c0492da736833 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.h
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.h
@@ -113,6 +113,7 @@ struct vc4_hdmi_audio {
 	struct snd_soc_dai_link_component platform;
 	struct snd_dmaengine_dai_dma_data dma_data;
 	struct hdmi_audio_infoframe infoframe;
+	struct platform_device *codec_pdev;
 	bool streaming;
 };
 
-- 
2.34.1

