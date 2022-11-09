Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC65D622B88
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 13:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiKIMaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 07:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiKIMaD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 07:30:03 -0500
Received: from mail-ej1-x64a.google.com (mail-ej1-x64a.google.com [IPv6:2a00:1450:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C7C1DA65
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 04:30:02 -0800 (PST)
Received: by mail-ej1-x64a.google.com with SMTP id gt15-20020a1709072d8f00b007aaac7973fbso10338652ejc.23
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 04:30:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hfm2vkzYg9/wh9COPQNzqW4Ldq8cdkzQ10RWJLbmXvY=;
        b=NNM5Yuz++db6o9H0S+lALNGLamT6qyFGnjbiq+Q8DlXH1LGbRq9WswSV/NBqkGLp2z
         ccMXOzT1RDWLcN8ypsNpStSb3HvKOV+Q6haARhTbliony8JSOfPuAHCHabfhMGijGZpz
         qLOqv6meYGwGKNgkYVkFAhifAVzhvjTzgeNvHln1WlvMD000AcpN1aV3+xN+vnKktLYD
         gHTfCsMhgav+v1lczkjfs7WeZX6tzUSYt7Z3+7Ly+psXOlWp1FqGML3ydqgbo+2C7/WX
         oFpgetQLIIzmuJ+/2dqBgKvJ8DNWOjWLs0/JsTxWT7jZUPojKje/hgKbnolC/6wuaFAO
         8psg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hfm2vkzYg9/wh9COPQNzqW4Ldq8cdkzQ10RWJLbmXvY=;
        b=EEiwg+FSJ1V69M2A+4Va2itq2fPxN6VcrvPSAeK4onh9FYjLvo+90OCewnT2WeN4AL
         VAmxs0KuqfxnRigE+CGuYDYBUTxPbY/IkLC0aBovD08gkVvj2Rjiu71wzO32eCPZ4vKf
         wFWTUFwVQJXZMKqO50sPCkvrWc3NHIpYU7i5Qycy+UCTc+ZN7cpyEdJToXODuQ1XOu1m
         mg0PkYB87+zpIOgcqG2OFQVeTMAc5en5rvHUBfosjhxXxFWjA+KmUoPHTWKJ7tLgNfFY
         pe4T391GLFof6bocALja5nVElh8r0Ne+olQHM4zBNiRaTW0GRw6sBfFCSP7EUktcfSDp
         5YGw==
X-Gm-Message-State: ACrzQf22V7h5fcTQt+Msj4tbIwZ+b9zH/1ni8+EnuLIRKkgBBADjVgOf
        /tvIZZs4kqM+f+3GOSI4rk3C71oPm9YANg==
X-Google-Smtp-Source: AMsMyM79ofVQoqVpgvrNi+zoJLPFYtzSUeAAZrqLGGXGtunp6w2Skc0xV2Vsxzrch0XgfFAac6k0m/f6CJpSlw==
X-Received: from bistanclaque.zrh.corp.google.com ([2a00:79e0:42:204:64:5e47:7c33:fbda])
 (user=ndumazet job=sendgmr) by 2002:a17:907:1dec:b0:7aa:6262:f23f with SMTP
 id og44-20020a1709071dec00b007aa6262f23fmr23487247ejc.38.1667997000591; Wed,
 09 Nov 2022 04:30:00 -0800 (PST)
Date:   Wed,  9 Nov 2022 13:29:46 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221109122946.706036-1-ndumazet@google.com>
Subject: [PATCH v3] usb: add NO_LPM quirk for Realforce 87U Keyboard
From:   Nicolas Dumazet <ndumazet@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
Cc:     Petar Kostic <petar@kostic.dev>, Oliver Neukum <oneukum@suse.com>,
        Ole Ernst <olebowle@gmx.com>,
        Hannu Hartikainen <hannu@hrtk.in>,
        Jimmy Wang <wangjm221@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nicolas Dumazet <ndumazet@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Before adding this quirk, this (mechanical keyboard) device would not be
recognized, logging:

  new full-speed USB device number 56 using xhci_hcd
  unable to read config index 0 descriptor/start: -32
  chopping to 0 config(s)

It would take dozens of plugging/unpuggling cycles for the keyboard to
be recognized. Keyboard seems to simply work after applying this quirk.

This issue had been reported by users in two places already ([1], [2])
but nobody tried upstreaming a patch yet. After testing I believe their
suggested fix (DELAY_INIT + NO_LPM + DEVICE_QUALIFIER) was probably a
little overkill. I assume this particular combination was tested because
it had been previously suggested in [3], but only NO_LPM seems
sufficient for this device.

[1]: https://qiita.com/float168/items/fed43d540c8e2201b543
[2]: https://blog.kostic.dev/posts/making-the-realforce-87ub-work-with-usb30-on-Ubuntu/
[3]: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1678477

Cc: stable@vger.kernel.org
Signed-off-by: Nicolas Dumazet <ndumazet@google.com>
---

Changes:
  * v2 -> v3: fix s-o-b / patch format.
  * v1 -> v2 : add the entry to the right location (sorting entries by
    vendor/device id).

---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 0722d2131305..079e183cf3bf 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -362,6 +362,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x0781, 0x5583), .driver_info = USB_QUIRK_NO_LPM },
 	{ USB_DEVICE(0x0781, 0x5591), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* Realforce 87U Keyboard */
+	{ USB_DEVICE(0x0853, 0x011b), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* M-Systems Flash Disk Pioneers */
 	{ USB_DEVICE(0x08ec, 0x1000), .driver_info = USB_QUIRK_RESET_RESUME },
 
-- 
2.38.0.135.g90850a2211-goog

