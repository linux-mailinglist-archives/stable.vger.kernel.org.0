Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74FD1BCB32
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbgD1Szd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729324AbgD1Sc0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:32:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A559321744;
        Tue, 28 Apr 2020 18:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098746;
        bh=cz1vgpRm5YCqvx3UdUnNBTpYLfd4rEWDwTC1kBDrYpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p26Sf6Bb1IzOIkO0dC9X7XX1x+NbIfKkvP4BQa2mWc3x3J6/npl4M+oaI7i7Zkt3y
         71P4YnjQtUs4DHRL1FsFE+RySGyYYG9UF3J+8xqb1X42FcjXeHI2ABw3UAlF/vFJ7m
         +vtv9i7m9BFClChLCcQyxmZxV1FQbZtDcYecNTGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.6 106/167] ALSA: hda/hdmi: Add module option to disable audio component binding
Date:   Tue, 28 Apr 2020 20:24:42 +0200
Message-Id: <20200428182238.565943595@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit b392350ec3f229ad9603d3816f753479e441d99a upstream.

As the recent regression showed, we want sometimes to turn off the
audio component binding just for debugging.  This patch adds the
module option to control it easily without compilation.

Fixes: ade49db337a9 ("ALSA: hda/hdmi - Allow audio component for AMD/ATI and Nvidia HDMI")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207223
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200415162523.27499-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -38,6 +38,10 @@ static bool static_hdmi_pcm;
 module_param(static_hdmi_pcm, bool, 0644);
 MODULE_PARM_DESC(static_hdmi_pcm, "Don't restrict PCM parameters per ELD info");
 
+static bool enable_acomp = true;
+module_param(enable_acomp, bool, 0444);
+MODULE_PARM_DESC(enable_acomp, "Enable audio component binding (default=yes)");
+
 struct hdmi_spec_per_cvt {
 	hda_nid_t cvt_nid;
 	int assigned;
@@ -2638,6 +2642,11 @@ static void generic_acomp_init(struct hd
 {
 	struct hdmi_spec *spec = codec->spec;
 
+	if (!enable_acomp) {
+		codec_info(codec, "audio component disabled by module option\n");
+		return;
+	}
+
 	spec->port2pin = port2pin;
 	setup_drm_audio_ops(codec, ops);
 	if (!snd_hdac_acomp_init(&codec->bus->core, &spec->drm_audio_ops,


