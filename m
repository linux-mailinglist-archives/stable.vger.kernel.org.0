Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E299147CE1
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388420AbgAXJzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:55:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387997AbgAXJzI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:55:08 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 220BF206D5;
        Fri, 24 Jan 2020 09:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859707;
        bh=V7+Srg/uvT5GfV1Jok2oMuGAHtGGv5gftaXZtvvOl0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i23BeELO/B0Vtx8jehuKQj1lffptmYf9oCwOVIN4HQdolVNsB0q6Lt8dHW5/Wpm91
         uKAhCVRQFs6ehAOAyiqGMgPHga+2BZ32cGgonlOSrVFx3hthyuHsTSvfpFcZw6gelF
         HbsqSfRp8laDHLJHhRteoJ7bHknmMTcEdlLfouMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 177/343] ALSA: usb-audio: Handle the error from snd_usb_mixer_apply_create_quirk()
Date:   Fri, 24 Jan 2020 10:29:55 +0100
Message-Id: <20200124092943.293425026@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 328e9f6973be2ee67862cb17bf6c0c5c5918cd72 ]

The error from snd_usb_mixer_apply_create_quirk() is ignored in the
current usb-audio driver code, which will continue the probing even
after the error.  Let's take it more serious.

Fixes: 7b1eda223deb ("ALSA: usb-mixer: factor out quirks")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 044193b2364d0..e6e4c3b9d9d3f 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2632,7 +2632,9 @@ int snd_usb_create_mixer(struct snd_usb_audio *chip, int ctrlif,
 	    (err = snd_usb_mixer_status_create(mixer)) < 0)
 		goto _error;
 
-	snd_usb_mixer_apply_create_quirk(mixer);
+	err = snd_usb_mixer_apply_create_quirk(mixer);
+	if (err < 0)
+		goto _error;
 
 	err = snd_device_new(chip->card, SNDRV_DEV_CODEC, mixer, &dev_ops);
 	if (err < 0)
-- 
2.20.1



