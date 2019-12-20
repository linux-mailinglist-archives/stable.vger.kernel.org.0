Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADD5212782A
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 10:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbfLTJcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 04:32:06 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35564 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727202AbfLTJcG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 04:32:06 -0500
Received: by mail-lj1-f195.google.com with SMTP id j1so1943879lja.2;
        Fri, 20 Dec 2019 01:32:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vACzD6DaxQvgtCMU0tnPw1WJ51oVtIqk0pKAR9FuZpU=;
        b=FySB0IZnaU+ESH8XGKR4HwoXuak1WTgE8SPhZAkiDiUF7QIqJIRz4MVTSMJUE1u42T
         Z/hJR0SKqpWsujre0cXxBwwLxYtI99RqvYRBDS0HJYdf26BC3GDs3TmrwWq2LZFzGI7n
         wHmnXiN1F0zqVB6Vf5ONeRtsup9ijMbT9FNllAvJ2ftNkOusvc1cH6HO2acP4WmQeDOG
         pW9r0gUausnDAAS2DrpmGRrO8Wa0nzDVR936dEWlp9dSWoLTC+fy/nkLEBxvg2wLclDP
         OWiDsZDqrnawS/D+/TZPfVBQJqfqEtjSlRYljp+fMk1BLlkKS2BQ+wcYpddBP7EMv3X4
         AeJA==
X-Gm-Message-State: APjAAAW7bodVb8QNmL5QIrHYRGpdsc/jaOpROe8GYwCpxw/uyEC/XbCw
        bdtSnthJen6P6iR05lI+0jI=
X-Google-Smtp-Source: APXvYqx7d4xmf7k72/iB+L72Tyd+ARo47ZmuVxirOZXppNqFPl+yhzLOboPX4ybagaHMNyeKmQuMow==
X-Received: by 2002:a2e:910b:: with SMTP id m11mr9162003ljg.213.1576834323858;
        Fri, 20 Dec 2019 01:32:03 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id z7sm4437120lfa.81.2019.12.20.01.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 01:32:03 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iiEde-0000L0-4r; Fri, 20 Dec 2019 10:32:02 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] ALSA: usb-audio: fix set_format altsetting sanity check
Date:   Fri, 20 Dec 2019 10:31:34 +0100
Message-Id: <20191220093134.1248-1-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to check the return value of usb_altnum_to_altsetting() to
avoid dereferencing a NULL pointer when the requested alternate settings
is missing.

The format altsetting number may come from a quirk table and there does
not seem to be any other validation of it (the corresponding index is
checked however).

Fixes: b099b9693d23 ("ALSA: usb-audio: Avoid superfluous usb_set_interface() calls")
Cc: stable <stable@vger.kernel.org>     # 4.18
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 sound/usb/pcm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 9c8930bb00c8..73dd9d21bb42 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -506,9 +506,9 @@ static int set_format(struct snd_usb_substream *subs, struct audioformat *fmt)
 	if (WARN_ON(!iface))
 		return -EINVAL;
 	alts = usb_altnum_to_altsetting(iface, fmt->altsetting);
-	altsd = get_iface_desc(alts);
-	if (WARN_ON(altsd->bAlternateSetting != fmt->altsetting))
+	if (WARN_ON(!alts))
 		return -EINVAL;
+	altsd = get_iface_desc(alts);
 
 	if (fmt == subs->cur_audiofmt)
 		return 0;
-- 
2.24.1

