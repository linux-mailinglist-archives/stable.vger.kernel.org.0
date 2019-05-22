Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 177AF26913
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 19:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbfEVR1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 13:27:03 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:39442 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729500AbfEVR1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 13:27:03 -0400
Received: by mail-qt1-f201.google.com with SMTP id b46so2707207qte.6
        for <stable@vger.kernel.org>; Wed, 22 May 2019 10:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=GDrZgFBNCd/50aXdWTdcgTRUOjYwaX5HGtY6WfFhngs=;
        b=HDch0fyonO76nulv6bx/pyYQB+ZJsheTlI/eSzV6LChzFc8bf0pVmFY6ISXNkP2RNo
         urMfiWQB2BNk4riB+5PGc2QZ7pmVUrtiyyFcBsaNnZnUpYqMQgoGwLJUXtwPoa6UwVXs
         G2JLwkDNGoWm8gqoYzkRAFfMQIbMsC+l18U6aNaWVLJLO8EywLPl7w6tf8Sb/VnR5g3G
         HWaGsxGDb0Mq5M+wtu9SSIXcQvEVwl++OhNbq9qOfG0Vj+raZeODuxV1sdQQ324GWI4T
         YOHIGj7+2z4O+cbXSAdnH5v8aAZxQDWo1UHwKDXwrbzN9MTpRnRBCYZWF/zbKaLfvMc8
         8jTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=GDrZgFBNCd/50aXdWTdcgTRUOjYwaX5HGtY6WfFhngs=;
        b=Rf0v8CFTOQ9roRxlljf+vnfxKanUn5oa+AzxwKk1F9AkormFyJGT6ijLDCqTLQJF4k
         yZxTe3x+YRoF6aOL+wAwrfUZ3oxfwguSqFQ0ksy97GiVQGI9aqycBUGAx6BR6lc8nQO4
         j+iTHkKkXNjuK/9CcWtZySlUMAOe0CIr9EItyVpesIcGfdKMQIfEZSj6uOeYAXHwFFn5
         eK7AwRQ+UETFLRYSyhhqFAaw1m7/C2qC8YUTTqb8etqggrI1y/5GvR7wUNhLtIYVEuMj
         Nd7xmRhvsU17NAGWVBzyXD1vUuHIbkFS6L/JHIoDQugInKwGzc4MwxZ4sk2o5OFzqpJs
         4crA==
X-Gm-Message-State: APjAAAUylsxN9TUYN74QibsuIfI3nvcuwkOSJ3gkL1jpXhgSY6zEuqX3
        lzvR/ZW67Rad1yz6CO+CT+BweeBh5rY=
X-Google-Smtp-Source: APXvYqzpVYQXKK9BrAQ22QPdc8hj66jbpZQyi15MqeS8wGqjUHYyi6O3dTkTesiBeRQj8YC1zBFY+VlmYNA=
X-Received: by 2002:ac8:3708:: with SMTP id o8mr75132809qtb.237.1558546022069;
 Wed, 22 May 2019 10:27:02 -0700 (PDT)
Date:   Wed, 22 May 2019 10:26:55 -0700
Message-Id: <20190522172655.183977-1-surenb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH 1/1] ALSA: usb-audio: Fix UAF decrement if card has no live
 interfaces in card.c
From:   Suren Baghdasaryan <surenb@google.com>
To:     surenb@google.com
Cc:     perex@perex.cz, tiwai@suse.de, mathias.payer@nebelwelt.net,
        benquike@gmail.com, kdeus@google.com, alsa-devel@alsa-project.org,
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

