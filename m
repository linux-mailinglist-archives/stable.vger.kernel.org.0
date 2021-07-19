Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDC63CDF91
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344570AbhGSPKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:10:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345457AbhGSPJX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:09:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3507606A5;
        Mon, 19 Jul 2021 15:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709729;
        bh=+UwK8f6qFkk6sE0w4N68AeWGB7dIv3vu+bt6wlyxoVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Us3kd1aYvfatwzrXVPcWkhWeo6WAdJUhLG4z0+UepDIdIvi/6ooOBhOOJK+OtpJ+I
         TChOVGy6+RkcIyEStjyyfgMweezG0iUGLPxDpUQPL6BtPt0uzY1vjN7ZcJAorCuL5G
         jlhS3aa+WtlxTLpl2hm27JHTCEwR7IHeB1NRLjXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Geoffrey D. Bennett" <g@b4.vu>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/149] ALSA: usb-audio: scarlett2: Fix scarlett2_*_ctl_put() return values
Date:   Mon, 19 Jul 2021 16:52:45 +0200
Message-Id: <20210719144914.919988622@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geoffrey D. Bennett <g@b4.vu>

[ Upstream commit c5d8e008032f3cd5f266d552732973a960b0bd4b ]

Mixer control put callbacks should return 1 if the value is changed.
Fix the sw_hw, level, pad, and button controls accordingly.

Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Link: https://lore.kernel.org/r/20210620164645.GA9221@m.b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_scarlett_gen2.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/usb/mixer_scarlett_gen2.c b/sound/usb/mixer_scarlett_gen2.c
index 9c98d5b79011..322dc5b6be63 100644
--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -1184,6 +1184,8 @@ static int scarlett2_sw_hw_enum_ctl_put(struct snd_kcontrol *kctl,
 	/* Send SW/HW switch change to the device */
 	err = scarlett2_usb_set_config(mixer, SCARLETT2_CONFIG_SW_HW_SWITCH,
 				       index, val);
+	if (err == 0)
+		err = 1;
 
 unlock:
 	mutex_unlock(&private->data_mutex);
@@ -1244,6 +1246,8 @@ static int scarlett2_level_enum_ctl_put(struct snd_kcontrol *kctl,
 	/* Send switch change to the device */
 	err = scarlett2_usb_set_config(mixer, SCARLETT2_CONFIG_LEVEL_SWITCH,
 				       index, val);
+	if (err == 0)
+		err = 1;
 
 unlock:
 	mutex_unlock(&private->data_mutex);
@@ -1294,6 +1298,8 @@ static int scarlett2_pad_ctl_put(struct snd_kcontrol *kctl,
 	/* Send switch change to the device */
 	err = scarlett2_usb_set_config(mixer, SCARLETT2_CONFIG_PAD_SWITCH,
 				       index, val);
+	if (err == 0)
+		err = 1;
 
 unlock:
 	mutex_unlock(&private->data_mutex);
@@ -1349,6 +1355,8 @@ static int scarlett2_button_ctl_put(struct snd_kcontrol *kctl,
 	/* Send switch change to the device */
 	err = scarlett2_usb_set_config(mixer, SCARLETT2_CONFIG_BUTTONS,
 				       index, val);
+	if (err == 0)
+		err = 1;
 
 unlock:
 	mutex_unlock(&private->data_mutex);
-- 
2.30.2



