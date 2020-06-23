Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54978205DF7
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389696AbgFWUSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:18:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389694AbgFWUSe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:18:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 074F72137B;
        Tue, 23 Jun 2020 20:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943513;
        bh=cT4ZXRSvQ1Jb/TQcdZWehksxRoZZc5PabZMVZPPEH8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIj7EQURjVQttFM5i+XyRDpM/klmP6DMOPn+hBn0yvHnL0HiFOzEBK1bQCdSJ3Ffb
         H/2W2tsNzhd/Ov3xszWLwQbqDn87D5E8JJmTjZ/LsV0yC8dCYR4gZgomSUdFxxhdZk
         +6hrMi0j3ZF0H86AfbypI86lQmPpFW5CL/GkR8W0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 5.7 421/477] drm/nouveau/kms: Fix regression by audio component transition
Date:   Tue, 23 Jun 2020 21:56:58 +0200
Message-Id: <20200623195427.429831841@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 61a41097e4bd4bf5d4abf3b3b58d5bf0856ce144 upstream.

Since the commit 742db30c4ee6 ("drm/nouveau: Add HD-audio component
notifier support"), the nouveau driver notifies and pokes the HD-audio
HPD and ELD via audio component, but this seems broken.  The culprit
is the naive assumption that crtc->index corresponds to the HDA pin.
Actually this rather corresponds to the MST dev_id (alias "pipe" in
the audio component framework) while the actual port number is given
from the output ior id number.

This patch corrects the assignment of port and dev_id arguments in the
audio component ops to recover from the HDMI/DP audio regression.

Fixes: 742db30c4ee6 ("drm/nouveau: Add HD-audio component notifier support")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207223
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/dispnv50/disp.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -482,15 +482,16 @@ nv50_dac_create(struct drm_connector *co
  * audio component binding for ELD notification
  */
 static void
-nv50_audio_component_eld_notify(struct drm_audio_component *acomp, int port)
+nv50_audio_component_eld_notify(struct drm_audio_component *acomp, int port,
+				int dev_id)
 {
 	if (acomp && acomp->audio_ops && acomp->audio_ops->pin_eld_notify)
 		acomp->audio_ops->pin_eld_notify(acomp->audio_ops->audio_ptr,
-						 port, -1);
+						 port, dev_id);
 }
 
 static int
-nv50_audio_component_get_eld(struct device *kdev, int port, int pipe,
+nv50_audio_component_get_eld(struct device *kdev, int port, int dev_id,
 			     bool *enabled, unsigned char *buf, int max_bytes)
 {
 	struct drm_device *drm_dev = dev_get_drvdata(kdev);
@@ -506,7 +507,8 @@ nv50_audio_component_get_eld(struct devi
 		nv_encoder = nouveau_encoder(encoder);
 		nv_connector = nouveau_encoder_connector_get(nv_encoder);
 		nv_crtc = nouveau_crtc(encoder->crtc);
-		if (!nv_connector || !nv_crtc || nv_crtc->index != port)
+		if (!nv_connector || !nv_crtc || nv_encoder->or != port ||
+		    nv_crtc->index != dev_id)
 			continue;
 		*enabled = drm_detect_monitor_audio(nv_connector->edid);
 		if (*enabled) {
@@ -600,7 +602,8 @@ nv50_audio_disable(struct drm_encoder *e
 
 	nvif_mthd(&disp->disp->object, 0, &args, sizeof(args));
 
-	nv50_audio_component_eld_notify(drm->audio.component, nv_crtc->index);
+	nv50_audio_component_eld_notify(drm->audio.component, nv_encoder->or,
+					nv_crtc->index);
 }
 
 static void
@@ -634,7 +637,8 @@ nv50_audio_enable(struct drm_encoder *en
 	nvif_mthd(&disp->disp->object, 0, &args,
 		  sizeof(args.base) + drm_eld_size(args.data));
 
-	nv50_audio_component_eld_notify(drm->audio.component, nv_crtc->index);
+	nv50_audio_component_eld_notify(drm->audio.component, nv_encoder->or,
+					nv_crtc->index);
 }
 
 /******************************************************************************


