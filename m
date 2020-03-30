Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB8311975B3
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 09:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbgC3Ham (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 03:30:42 -0400
Received: from mail-qv1-f66.google.com ([209.85.219.66]:36141 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729197AbgC3Ham (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 03:30:42 -0400
Received: by mail-qv1-f66.google.com with SMTP id z13so8429785qvw.3;
        Mon, 30 Mar 2020 00:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YSCR8aNaMptUVJblHXzimEhpdjR3BXiCbmHpK02W3lk=;
        b=LncIDrPvKfAaA0dhcA1CA6xSu37hTu7qLw8XmXxotN2+at1XgNjhyFv4Y4I7H4/w0W
         DAWchdINvtcWP8flC+eMYf6hCKTriOhJgVZYvRomEiET7v2tXpQaYI8hiIaCT9BAYkjm
         y7AaQcqmNHSoL5o3zCMd5He3nETzjhpQMyoi9L3oc+EqyuYRQupNNGTcOnnG06WfolPA
         +9cpmsf56FAWCiwrkrr7yeD2N1k1dV3ZFestnmeVy08IF22w8zrTD2/BNwb/2vDBqo3J
         KnbcuxptAesv8x2caZvZy32Jaia2ZCLtDj+TP2gM1PQgnmptCWo19XIPSadg4j/3+6m2
         gR9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YSCR8aNaMptUVJblHXzimEhpdjR3BXiCbmHpK02W3lk=;
        b=s8iW/VulnLRIOe6U1EhRkxgoOeo6LexOcMTpo4trQ2/mGgsyT4tjk2GwkfYrICuOhp
         gcub3K2GHzpbKbznw2ZFUIT1vnzNck27NUYlg/lvwuwvhUkDHdx0b7k1pDJA+7FJhhh8
         fpaiMaYQ0JG5ynQgX0+D38eGr8XFjUgcRo8o1DU+2AW9SHR4UHGYWayX1VEraPnlG3R/
         QgNwEqcjQPZa4xT0Y8jPCYK3jK/cERhPFpO/u9x5Mkhm4eM4BdPuNM6LbYp9O0X8Uznz
         IVH+aGNgaTq5nwmTT5DEo5FqRCv915bGOnqZxQoyRgHR5pmSApjTQnSsUuiKbjcSY4id
         +LKg==
X-Gm-Message-State: ANhLgQ3qxoefazYudjb3TMbCEPHD8QM2IVeXgOdIoo6d1NxRXqq8Fr+W
        8W5ktTdbGHuJBKN7BEc22kY=
X-Google-Smtp-Source: ADFU+vslCt+RBP2jHzxrwlc3lOO1Rt8opKMEjAVebM0NpBBzZdmUI5QhM+bbgTpwxrVgYbGYdpiuXA==
X-Received: by 2002:a05:6214:118d:: with SMTP id t13mr10076777qvv.192.1585553440691;
        Mon, 30 Mar 2020 00:30:40 -0700 (PDT)
Received: from stingray.lan (pool-173-76-255-234.bstnma.fios.verizon.net. [173.76.255.234])
        by smtp.gmail.com with ESMTPSA id n63sm10078499qka.80.2020.03.30.00.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 00:30:40 -0700 (PDT)
From:   Thomas Hebb <tommyhebb@gmail.com>
To:     alsa-devel@alsa-project.org, linux-kernel@vger.kernel.or
Cc:     Kailang Yang <kailang@realtek.com>,
        Thomas Hebb <tommyhebb@gmail.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hui Wang <hui.wang@canonical.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Jian-Hong Pan <jian-hong@endlessm.com>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Sergey Bostandzhyan <jin@mediatomb.cc>,
        Takashi Iwai <tiwai@suse.com>,
        Tomas Espeleta <tomas.espeleta@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ALSA: hda/realtek - Set principled PC Beep configuration for ALC256
Date:   Mon, 30 Mar 2020 03:30:31 -0400
Message-Id: <d631643464d38603f6d672d9340a331f6a016a1c.1585553414.git.tommyhebb@gmail.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <cover.1585553414.git.tommyhebb@gmail.com>
References: <cover.1585553414.git.tommyhebb@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Realtek PC Beep Hidden Register[1] is currently set by
patch_realtek.c in two different places:

In alc_fill_eapd_coef(), it's set to the value 0x5757, corresponding to
non-beep input on 1Ah and no 1Ah loopback to either headphones or
speakers. (Although, curiously, the loopback amp is still enabled.) This
write was added fairly recently by commit e3743f431143 ("ALSA:
hda/realtek - Dell headphone has noise on unmute for ALC236") and is a
safe default. However, it happens in the wrong place:
alc_fill_eapd_coef() runs on module load and cold boot but not on S3
resume, meaning the register loses its value after suspend.

Conversely, in alc256_init(), the register is updated to unset bit 13
(disable speaker loopback) and set bit 5 (set non-beep input on 1Ah).
Although this write does run on S3 resume, it's not quite enough to fix
up the register's default value of 0x3717. What's missing is a set of
bit 14 to disable headphone loopback. Without that, we end up with a
feedback loop where the headphone jack is being driven by amplified
samples of itself[2].

This change eliminates the write in alc_fill_eapd_coef() and replaces
the update in alc256_init() with a write of the fixed value 0x4727. This
value ought to have the same behavior as 0x5757--disabling all PC Beep
routing that isn't part of the HDA node graph--but it has two
differences:

 1. To enable non-beep input on 1Ah, the `b` field is set to 1, like the
    previous code in alc256_init() used, instead of 2, like the value
    written by alc_fill_eapd_coef() used. My testing shows these two
    values to behave identically, but, in case there is a difference,
    a bitwise update of the register seems like a more reliable source
    of truth than a magic number written without explanation.

 2. Loopback amplification is disabled (unset L and R bits) because no
    loopback path is in use.

Affects the ALC255, ALC256, ALC257, ALC235, and ALC236 codecs.

[1] Newly documented in Documentation/sound/hd-audio/realtek-pc-beep.rst

[2] Setting the "Headphone Mic Boost" control from userspace changes
this feedback loop and has been a widely-shared workaround for headphone
noise on laptops like the Dell XPS 13 9350. This commit eliminates the
feedback loop and makes the workaround unnecessary.

Fixes: e3743f431143 ("ALSA: hda/realtek - Dell headphone has noise on unmute for ALC236")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
---

 sound/pci/hda/patch_realtek.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 63e1a56f705b..024dd61a788b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -367,7 +367,9 @@ static void alc_fill_eapd_coef(struct hda_codec *codec)
 	case 0x10ec0215:
 	case 0x10ec0233:
 	case 0x10ec0235:
+	case 0x10ec0236:
 	case 0x10ec0255:
+	case 0x10ec0256:
 	case 0x10ec0257:
 	case 0x10ec0282:
 	case 0x10ec0283:
@@ -379,11 +381,6 @@ static void alc_fill_eapd_coef(struct hda_codec *codec)
 	case 0x10ec0300:
 		alc_update_coef_idx(codec, 0x10, 1<<9, 0);
 		break;
-	case 0x10ec0236:
-	case 0x10ec0256:
-		alc_write_coef_idx(codec, 0x36, 0x5757);
-		alc_update_coef_idx(codec, 0x10, 1<<9, 0);
-		break;
 	case 0x10ec0275:
 		alc_update_coef_idx(codec, 0xe, 0, 1<<0);
 		break;
@@ -3269,7 +3266,13 @@ static void alc256_init(struct hda_codec *codec)
 	alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x4); /* Hight power */
 	alc_update_coefex_idx(codec, 0x53, 0x02, 0x8000, 1 << 15); /* Clear bit */
 	alc_update_coefex_idx(codec, 0x53, 0x02, 0x8000, 0 << 15);
-	alc_update_coef_idx(codec, 0x36, 1 << 13, 1 << 5); /* Switch pcbeep path to Line in path*/
+	/*
+	 * Expose headphone mic (or possibly Line In on some machines) instead
+	 * of PC Beep on 1Ah, and disable 1Ah loopback for all outputs. See
+	 * Documentation/sound/hd-audio/realtek-pc-beep.rst for details of
+	 * this register.
+	 */
+	alc_write_coef_idx(codec, 0x36, 0x4727);
 }
 
 static void alc256_shutup(struct hda_codec *codec)
-- 
2.25.2

