Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601162C66F2
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 14:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730496AbgK0Ndm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 08:33:42 -0500
Received: from marcansoft.com ([212.63.210.85]:44490 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730440AbgK0Ndl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Nov 2020 08:33:41 -0500
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Nov 2020 08:33:40 EST
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 7219741ECC;
        Fri, 27 Nov 2020 13:26:41 +0000 (UTC)
From:   Hector Martin <marcan@marcan.st>
To:     alsa-devel@alsa-project.org
Cc:     Detlef Urban <onkel@paraair.de>, Takashi Iwai <tiwai@suse.de>,
        Hector Martin <marcan@marcan.st>, stable@vger.kernel.org
Subject: [PATCH] ALSA: usb-audio: US16x08: fix value count for level meters
Date:   Fri, 27 Nov 2020 22:26:35 +0900
Message-Id: <20201127132635.18947-1-marcan@marcan.st>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The level meter control returns 34 integers of info. This fixes:

snd-usb-audio 3-1:1.0: control 2:0:0:Level Meter:0: access overflow

Cc: stable@vger.kernel.org
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 sound/usb/mixer_us16x08.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/mixer_us16x08.c b/sound/usb/mixer_us16x08.c
index 92b1a6d9c931..bd63a9ce6a70 100644
--- a/sound/usb/mixer_us16x08.c
+++ b/sound/usb/mixer_us16x08.c
@@ -607,7 +607,7 @@ static int snd_us16x08_eq_put(struct snd_kcontrol *kcontrol,
 static int snd_us16x08_meter_info(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_info *uinfo)
 {
-	uinfo->count = 1;
+	uinfo->count = 34;
 	uinfo->type = SNDRV_CTL_ELEM_TYPE_INTEGER;
 	uinfo->value.integer.max = 0x7FFF;
 	uinfo->value.integer.min = 0;
-- 
2.28.0

