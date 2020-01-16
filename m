Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69B6D13F5F9
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388903AbgAPTAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:00:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:36298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388013AbgAPRGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:06:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD3B72467E;
        Thu, 16 Jan 2020 17:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194377;
        bh=rmIYOVrInVtY/X4i4RXusQ8tbGpMEuAWcvDaBFWfCas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u02kYy88PHUrRdU1lrkTZzrgWDNwbAzSdqlMF0XI2oz/yoGcz9JlW2dEmR0GEu/8K
         pcOnd4SgvY9K1EUwSYSxwQXUJ/qZnqgHoq9lisQ3HG4dWQBgnG36FUgcKhtsQPUBTM
         YdoU9ZtYAOC3r8AznFcc9S6DCr44isQWVDsvIpKw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 309/671] ALSA: usb-audio: Handle the error from snd_usb_mixer_apply_create_quirk()
Date:   Thu, 16 Jan 2020 11:59:07 -0500
Message-Id: <20200116170509.12787-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d7778f2bcbf8..6ac6a0980124 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -3480,7 +3480,9 @@ int snd_usb_create_mixer(struct snd_usb_audio *chip, int ctrlif,
 	if (err < 0)
 		goto _error;
 
-	snd_usb_mixer_apply_create_quirk(mixer);
+	err = snd_usb_mixer_apply_create_quirk(mixer);
+	if (err < 0)
+		goto _error;
 
 	err = snd_device_new(chip->card, SNDRV_DEV_CODEC, mixer, &dev_ops);
 	if (err < 0)
-- 
2.20.1

