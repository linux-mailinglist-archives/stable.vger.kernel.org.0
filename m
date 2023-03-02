Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 181DF6A86D8
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 17:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjCBQiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 11:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjCBQiU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 11:38:20 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BD757D33
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 08:37:34 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id s11so5981597edy.8
        for <stable@vger.kernel.org>; Thu, 02 Mar 2023 08:37:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tfY1Ul1QnfuQtui+4Ej95F51iCd9NVPI2d94LXtRwmo=;
        b=bDoI/39/km5XuwmNOoWn9p3W5zwRXDGImrlqwgWO1zuWUu1uLGMwSch+pf0z7lOVEk
         73JivL/5QyrKUaadxgCH/zBN/F+kuk2N5+pmDTVCqty5ou9Lp5ebIvJuY0sM6+2Ye5lX
         Ct4Fw8SaWySke/s2OpZJIlJv6gBiooF1l0PkA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tfY1Ul1QnfuQtui+4Ej95F51iCd9NVPI2d94LXtRwmo=;
        b=J/RKh3BSP0HEsgzwZKKVbIXr66hlE1msBZ4jO2jUkOGoyOABFE+7S5oLMAL2vtqJme
         a/f2zQzPtTe6YqFRTxPCvnDnZ1fzRo1qhxgRQJLaURH3HJEkX3e0hU1s+2WfINode4D1
         vgJb3l5Md+i8BE08JP0XFSTMLLXFgmafXe2zscvIR+MHK77tp9xtCj3LqzqQC/5pNXRC
         2yTS/w6ODgMBWyjn9PmPeEL7FKgxp3shr3aG+P0ltOzKu/563w2TYKWt056a/UNr+dro
         QBGDpgO2R8F4WRs00/fy9r7sMU6Fr1p69Pske0A+gu8uuKus1mF8fpT4B6befowe52as
         44YQ==
X-Gm-Message-State: AO0yUKWJNCl34lgnJHC3gsBkx5nTQ38BwvJr8w8/qC8/dDy0AJYeFmTX
        efJ/XXYHlIohAltV7GEULVEahQ==
X-Google-Smtp-Source: AK7set9auJrOCtINNaTDbetFrZVlHmp0QiBEME8aEHEdjzC6Rn02Ru1UVtQvJaLObY5/foEdxrwdfw==
X-Received: by 2002:a17:906:6543:b0:8a9:e031:c4ae with SMTP id u3-20020a170906654300b008a9e031c4aemr10818449ejn.2.1677775047510;
        Thu, 02 Mar 2023 08:37:27 -0800 (PST)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id os6-20020a170906af6600b008f7f6943d1dsm7173547ejb.42.2023.03.02.08.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 08:37:27 -0800 (PST)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yadi Brar <yadi.brar01@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Felipe Balbi <balbi@ti.com>
Cc:     alsa-devel@alsa-project.org,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        stable@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: gadget: u_audio: don't let userspace block driver unbind
Date:   Thu,  2 Mar 2023 17:36:47 +0100
Message-Id: <20230302163648.3349669-1-alvin@pqrs.dk>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

In the unbind callback for f_uac1 and f_uac2, a call to snd_card_free()
via g_audio_cleanup() will disconnect the card and then wait for all
resources to be released, which happens when the refcount falls to zero.
Since userspace can keep the refcount incremented by not closing the
relevant file descriptor, the call to unbind may block indefinitely.
This can cause a deadlock during reboot, as evidenced by the following
blocked task observed on my machine:

  task:reboot  state:D stack:0   pid:2827  ppid:569    flags:0x0000000c
  Call trace:
   __switch_to+0xc8/0x140
   __schedule+0x2f0/0x7c0
   schedule+0x60/0xd0
   schedule_timeout+0x180/0x1d4
   wait_for_completion+0x78/0x180
   snd_card_free+0x90/0xa0
   g_audio_cleanup+0x2c/0x64
   afunc_unbind+0x28/0x60
   ...
   kernel_restart+0x4c/0xac
   __do_sys_reboot+0xcc/0x1ec
   __arm64_sys_reboot+0x28/0x30
   invoke_syscall+0x4c/0x110
   ...

The issue can also be observed by opening the card with arecord and
then stopping the process through the shell before unbinding:

  # arecord -D hw:UAC2Gadget -f S32_LE -c 2 -r 48000 /dev/null
  Recording WAVE '/dev/null' : Signed 32 bit Little Endian, Rate 48000 Hz, Stereo
  ^Z[1]+  Stopped                    arecord -D hw:UAC2Gadget -f S32_LE -c 2 -r 48000 /dev/null
  # echo gadget.0 > /sys/bus/gadget/drivers/configfs-gadget/unbind
  (observe that the unbind command never finishes)

Fix the problem by using snd_card_free_when_closed() instead, which will
still disconnect the card as desired, but defer the task of freeing the
resources to the core once userspace closes its file descriptor.

Fixes: 132fcb460839 ("usb: gadget: Add Audio Class 2.0 Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/usb/gadget/function/u_audio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/u_audio.c b/drivers/usb/gadget/function/u_audio.c
index c1f62e91b012..4a42574b4a7f 100644
--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -1422,7 +1422,7 @@ void g_audio_cleanup(struct g_audio *g_audio)
 	uac = g_audio->uac;
 	card = uac->card;
 	if (card)
-		snd_card_free(card);
+		snd_card_free_when_closed(card);
 
 	kfree(uac->p_prm.reqs);
 	kfree(uac->c_prm.reqs);
-- 
2.39.1

