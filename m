Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90F266DEA0
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 14:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236029AbjAQNTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 08:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237184AbjAQNSv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 08:18:51 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E5A38EAD
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 05:18:49 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-4e62022894dso68385657b3.12
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 05:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gmQkSSw2R+/QTRROI20PCtYQmTwF6TMo3+FLq2700ts=;
        b=GbmqkYnrRNDoQKSWqXCvUO9yQ+cTyxZzkqHOp5TJFVcL6ZehuQ3O+5cyWFzFTc6SFb
         cV/ov89Omo4BytREE08YxKfzQu47AVmJIxYDTmhwgu5sp94+1xPV+8jCB4gUDF1dYtKM
         qp+bhl+Q3duDsph+vpBQMj24+z2PccGRy502Hfz9nVeYOgZKAn2+txMlXNXwpGY99P8k
         uqicligFUdX8z3GAFKpbCt5Rkf77Lsm0qR1vHzEYq7f1Fs67yldsHyb3CCEiNXhJJeaF
         CfiMYyLvV2yeKuus8GYVM8lNRdoIKJID7+RZDs3i1riEJtEXls/atn8KsOdIloxR+YnV
         Wmkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gmQkSSw2R+/QTRROI20PCtYQmTwF6TMo3+FLq2700ts=;
        b=dtUBm751VKqo7+N//q86dUKDzR/VQFjeBysuerAp1gDROlvCamD950GjdMyV8CVDO0
         cz4TTZmtv5G0fe2FnFPYiE/LnBzJENAssnE9nL7XltEcIfMtWOahBkr4T6jaAZk54rot
         Aw7JJveYubOHD1CSkcRG7CehVsxPtfxXdB5rEzNeMIAGUlUZvXj8HOnEZDyy32deKjAR
         CnZm8yncgbX5/+hpOH7GTvrg/4KgdwtuvVIrSlVMou7nXTZSSR60GkTECNxp2gfEhfGe
         YTZevY5OwVR6WyFVX//K35ntbo5RoXO6mdaA9ctNWv94jgHrahIoQHa6FYWRNUgtgZSp
         4H2g==
X-Gm-Message-State: AFqh2krbXgdKwLDGvV6N8rF6WL3xjMGFkVbXBaoATwg8Z+7HlFhZvA93
        GGdigSTqsHZg1wUM7OCTtYzmJU2J
X-Google-Smtp-Source: AMrXdXvMybh7TlNIa7mXNxDtQqYcZZTNfEn2XzG2HKIJssak/L6EArgovOc8FPnnKPVOtfowjxD3itwc
X-Received: from athina.mtv.corp.google.com ([2620:15c:211:200:9e58:2d3e:9f76:f099])
 (user=maze job=sendgmr) by 2002:a25:41cd:0:b0:75c:55f:b0d4 with SMTP id
 o196-20020a2541cd000000b0075c055fb0d4mr380688yba.13.1673961528294; Tue, 17
 Jan 2023 05:18:48 -0800 (PST)
Date:   Tue, 17 Jan 2023 05:18:39 -0800
Message-Id: <20230117131839.1138208-1-maze@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Subject: [PATCH] usb: gadget: f_ncm: fix potential NULL ptr deref in ncm_bitrate()
From:   "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>
To:     "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <zenczykowski@gmail.com>
Cc:     Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lorenzo Colitti <lorenzo@google.com>,
        Carlos Llamas <cmllamas@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In Google internal bug 265639009 we've received an (as yet) unreproducible
crash report from an aarch64 GKI 5.10.149-android13 running device.

AFAICT the source code is at:
  https://android.googlesource.com/kernel/common/+/refs/tags/ASB-2022-12-05=
_13-5.10

The call stack is:
  ncm_close() -> ncm_notify() -> ncm_do_notify()
with the crash at:
  ncm_do_notify+0x98/0x270
Code: 79000d0b b9000a6c f940012a f9400269 (b9405d4b)

Which I believe disassembles to (I don't know ARM assembly, but it looks sa=
ne enough to me...):

  // halfword (16-bit) store presumably to event->wLength (at offset 6 of s=
truct usb_cdc_notification)
  0B 0D 00 79    strh w11, [x8, #6]

  // word (32-bit) store presumably to req->Length (at offset 8 of struct u=
sb_request)
  6C 0A 00 B9    str  w12, [x19, #8]

  // x10 (NULL) was read here from offset 0 of valid pointer x9
  // IMHO we're reading 'cdev->gadget' and getting NULL
  // gadget is indeed at offset 0 of struct usb_composite_dev
  2A 01 40 F9    ldr  x10, [x9]

  // loading req->buf pointer, which is at offset 0 of struct usb_request
  69 02 40 F9    ldr  x9, [x19]

  // x10 is null, crash, appears to be attempt to read cdev->gadget->max_sp=
eed
  4B 5D 40 B9    ldr  w11, [x10, #0x5c]

which seems to line up with ncm_do_notify() case NCM_NOTIFY_SPEED code frag=
ment:

  event->wLength =3D cpu_to_le16(8);
  req->length =3D NCM_STATUS_BYTECOUNT;

  /* SPEED_CHANGE data is up/down speeds in bits/sec */
  data =3D req->buf + sizeof *event;
  data[0] =3D cpu_to_le32(ncm_bitrate(cdev->gadget));

My analysis of registers and NULL ptr deref crash offset
  (Unable to handle kernel NULL pointer dereference at virtual address 0000=
00000000005c)
heavily suggests that the crash is due to 'cdev->gadget' being NULL when ex=
ecuting:
  data[0] =3D cpu_to_le32(ncm_bitrate(cdev->gadget));
which calls:
  ncm_bitrate(NULL)
which then calls:
  gadget_is_superspeed(NULL)
which reads
  ((struct usb_gadget *)NULL)->max_speed
and hits a panic.

AFAICT, if I'm counting right, the offset of max_speed is indeed 0x5C.
(remember there's a GKI KABI reservation of 16 bytes in struct work_struct)

It's not at all clear to me how this is all supposed to work...
but returning 0 seems much better than panic-ing...

Cc: Felipe Balbi <balbi@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
---
 drivers/usb/gadget/function/f_ncm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_ncm.c b/drivers/usb/gadget/funct=
ion/f_ncm.c
index c36bcfa0e9b4..424bb3b666db 100644
--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -83,7 +83,9 @@ static inline struct f_ncm *func_to_ncm(struct usb_functi=
on *f)
 /* peak (theoretical) bulk transfer rate in bits-per-second */
 static inline unsigned ncm_bitrate(struct usb_gadget *g)
 {
-	if (gadget_is_superspeed(g) && g->speed >=3D USB_SPEED_SUPER_PLUS)
+	if (!g)
+		return 0;
+	else if (gadget_is_superspeed(g) && g->speed >=3D USB_SPEED_SUPER_PLUS)
 		return 4250000000U;
 	else if (gadget_is_superspeed(g) && g->speed =3D=3D USB_SPEED_SUPER)
 		return 3750000000U;
--=20
2.39.0.314.g84b9a713c41-goog

