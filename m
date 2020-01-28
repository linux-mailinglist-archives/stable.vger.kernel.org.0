Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD20614BB33
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgA1OKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:10:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:59274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726697AbgA1OKY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:10:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE43824685;
        Tue, 28 Jan 2020 14:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220624;
        bh=SxGtbT3Mgaz87pgcrFF12+gJMlFhmqiX1e0apsW2To0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fiC+wWv2XfEbUzDDmoJPRGM3eLuy9FqzONLdHezHgI3KDSwRVDIOLvGOOwpcz8h7I
         aMUV7AInvn3e/6NhXkaDT2QDrKIcKkUro/rdFYzTIeC4MT8nawbX/tLHQx8mA7GKrB
         unPa//xfXRq+4hvBZ+gbrSZvhtwyPdJm4MQvvxek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 082/183] ALSA: usb-audio: Handle the error from snd_usb_mixer_apply_create_quirk()
Date:   Tue, 28 Jan 2020 15:05:01 +0100
Message-Id: <20200128135838.117920239@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
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
index 1b81f18010d25..73149b9be29c9 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2552,7 +2552,9 @@ int snd_usb_create_mixer(struct snd_usb_audio *chip, int ctrlif,
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



