Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBD4B26905
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 19:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730213AbfEVRXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 13:23:16 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:45844 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730162AbfEVRXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 13:23:15 -0400
Received: by mail-vk1-f202.google.com with SMTP id z6so1188032vkd.12
        for <stable@vger.kernel.org>; Wed, 22 May 2019 10:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=GDrZgFBNCd/50aXdWTdcgTRUOjYwaX5HGtY6WfFhngs=;
        b=sc290qnHwXc0cP/EpBEFxX77HN9GvpSt6Kvh+/jGG62gWME3nV3nU63HHrO44wc18B
         fv0bFC35xEWf3o9csKO248kgmrB+Zl1Sgy982h7MMcaYRg37oeD1VL+ljyBT/wYg4BSd
         D0wMYBGbUyYr5HXkdvSKwnbhU6YM7ygcIn4TPBZRHKJEqonGO7MS2atOoWN3tIeONm0O
         cc6wBaWNP7CWi1kKS8D6zzQGr4JaXcP1fRZsm03pRJwIonPhM6KAxFDqXs+eDEyMgB0c
         Sg1y4+sA9fS67Z4gnVjVmfMlYO9UqxXxtr+98HB91zBJrU6yI1ns67j9elWZV5AvmH4B
         7BFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=GDrZgFBNCd/50aXdWTdcgTRUOjYwaX5HGtY6WfFhngs=;
        b=e+U92TMEk7zezEJQuL4ssbTB9u9a4Oi26iC5Qg4x9c3RKGKTrr4R7MVTqokhrsDQbk
         lz/wecjFDSmi7cDOZfby3hWTH2nEJk7wrLJ8bhLUuz3qxdax/1vTrL5RypxYCwUwjjyh
         9kQ7lK5PNUnQ6oH4Y77AAgigCo35PJOkJc/KL6xFKcZeKcidIfOX+g1byOD6J5zHhmNf
         Z5442pPPDCekQgUzUS/a1EHXmrBnlBXJRInKnVVfcpgU5v2Oskl+D5yMytoqI7DKgbea
         PSWk+GlZVupN7h+X8w90fhuQchnyI8OEFCLUDXEmHFmebXyPO5zLS9VIuexDCtJ5o6uT
         KTWw==
X-Gm-Message-State: APjAAAXTMmOPTyIcbNBSH8jLLT2WYfCj8IoWNodwSjURT88t5HOAJL6P
        Hwbvg0T9K7dHUgegK8bfNGzO5fZMlrI=
X-Google-Smtp-Source: APXvYqznEfMiFT/sTP+3uKBPFMKG8M/UXQZm4fwmBzzimZsavOF4d2pgZ9RMEzDF554YtuGSAzZIP1XzrRs=
X-Received: by 2002:a67:e891:: with SMTP id x17mr31819709vsn.206.1558545794431;
 Wed, 22 May 2019 10:23:14 -0700 (PDT)
Date:   Wed, 22 May 2019 10:23:12 -0700
Message-Id: <20190522172312.182489-1-surenb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH 1/1] ALSA: usb-audio: Fix UAF decrement if card has no live
 interfaces in card.c
From:   Suren Baghdasaryan <surenb@google.com>
To:     surenb@google.com
Cc:     Hui Peng <benquike@gmail.com>,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 5f8cf712582617d523120df67d392059eaf2fc4b upstream.

This is a backport to stable 3.18.y. Implementation in 3.18 differs using
chip->probing flag instead of chip->active atomic but it still has the UAF
issue.

If a USB sound card reports 0 interfaces, an error condition is triggered
and the function usb_audio_probe errors out. In the error path, there was a
use-after-free vulnerability where the memory object of the card was first
freed, followed by a decrement of the number of active chips. Moving the
decrement above the atomic_dec fixes the UAF.

[ The original problem was introduced in 3.1 kernel, while it was
  developed in a different form.  The Fixes tag below indicates the
  original commit but it doesn't mean that the patch is applicable
  cleanly. -- tiwai ]

Fixes: 362e4e49abe5 ("ALSA: usb-audio - clear chip->probing on error exit")
Reported-by: Hui Peng <benquike@gmail.com>
Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
Signed-off-by: Hui Peng <benquike@gmail.com>
Signed-off-by: Mathias Payer <mathias.payer@nebelwelt.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[surenb@google.com: resolve 3.18 differences]
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
Analysis for 3.18 codebase:
snd_usb_audio_create() sets card->device_data = chip
snd_usb_audio_probe() calls snd_card_free() and then resets chip->probing
snd_card_free() results in the following call chain:
 snd_card_free_when_closed() which waits on release_completion
 snd_card_do_free() calls snd_device_free_all() and signals release_completion
 snd_card_do_free() calls __snd_device_free()
 __snd_device_free() calls dev->ops->dev_free() == snd_usb_audio_dev_free()
 snd_usb_audio_dev_free() calls snd_usb_audio_free(chip) and frees "chip"
chip->probing = 0 results in UAF

 sound/usb/card.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index f7dbdc10bf77..59fb1ef3cd55 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -593,9 +593,12 @@ snd_usb_audio_probe(struct usb_device *dev,
 
  __error:
 	if (chip) {
+		/* chip->probing is inside the chip->card object,
+		 * reset before memory is possibly returned.
+		 */
+		chip->probing = 0;
 		if (!chip->num_interfaces)
 			snd_card_free(chip->card);
-		chip->probing = 0;
 	}
 	mutex_unlock(&register_mutex);
  __err_val:
-- 
2.21.0.1020.gf2820cf01a-goog

