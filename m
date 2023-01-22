Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5FF676E09
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbjAVPG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjAVPG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:06:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B68113E8
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:06:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14814B80B14
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B71C433D2;
        Sun, 22 Jan 2023 15:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674399982;
        bh=kFpPWxvwMV/J90Vk46cv4c8nowOT2u9DT+kuLxtpccw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uh4fSco1Z6jXMvSfudSXiFcikPUwleiP/J+sNQSOfZh5oDuQCrbTQB85ePh3TLRUl
         RshIhJeqpLGdiCJe/wXOtZq0Tt06WrFFOpg+Z6irZQaU+k0N1wCSqtmfFD2UJY3tny
         jemFhb5QDXuqfBS/JcxQvA9AVYs/yqVQatlqxxH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Felipe Balbi <balbi@kernel.org>,
        Lorenzo Colitti <lorenzo@google.com>,
        Carlos Llamas <cmllamas@google.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        stable <stable@kernel.org>
Subject: [PATCH 4.14 20/25] usb: gadget: f_ncm: fix potential NULL ptr deref in ncm_bitrate()
Date:   Sun, 22 Jan 2023 16:04:20 +0100
Message-Id: <20230122150218.656696144@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150217.788215473@linuxfoundation.org>
References: <20230122150217.788215473@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

commit c6ec929595c7443250b2a4faea988c62019d5cd2 upstream.

In Google internal bug 265639009 we've received an (as yet) unreproducible
crash report from an aarch64 GKI 5.10.149-android13 running device.

AFAICT the source code is at:
  https://android.googlesource.com/kernel/common/+/refs/tags/ASB-2022-12-05_13-5.10

The call stack is:
  ncm_close() -> ncm_notify() -> ncm_do_notify()
with the crash at:
  ncm_do_notify+0x98/0x270
Code: 79000d0b b9000a6c f940012a f9400269 (b9405d4b)

Which I believe disassembles to (I don't know ARM assembly, but it looks sane enough to me...):

  // halfword (16-bit) store presumably to event->wLength (at offset 6 of struct usb_cdc_notification)
  0B 0D 00 79    strh w11, [x8, #6]

  // word (32-bit) store presumably to req->Length (at offset 8 of struct usb_request)
  6C 0A 00 B9    str  w12, [x19, #8]

  // x10 (NULL) was read here from offset 0 of valid pointer x9
  // IMHO we're reading 'cdev->gadget' and getting NULL
  // gadget is indeed at offset 0 of struct usb_composite_dev
  2A 01 40 F9    ldr  x10, [x9]

  // loading req->buf pointer, which is at offset 0 of struct usb_request
  69 02 40 F9    ldr  x9, [x19]

  // x10 is null, crash, appears to be attempt to read cdev->gadget->max_speed
  4B 5D 40 B9    ldr  w11, [x10, #0x5c]

which seems to line up with ncm_do_notify() case NCM_NOTIFY_SPEED code fragment:

  event->wLength = cpu_to_le16(8);
  req->length = NCM_STATUS_BYTECOUNT;

  /* SPEED_CHANGE data is up/down speeds in bits/sec */
  data = req->buf + sizeof *event;
  data[0] = cpu_to_le32(ncm_bitrate(cdev->gadget));

My analysis of registers and NULL ptr deref crash offset
  (Unable to handle kernel NULL pointer dereference at virtual address 000000000000005c)
heavily suggests that the crash is due to 'cdev->gadget' being NULL when executing:
  data[0] = cpu_to_le32(ncm_bitrate(cdev->gadget));
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
Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20230117131839.1138208-1-maze@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ncm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -92,7 +92,9 @@ static inline struct f_ncm *func_to_ncm(
 /* peak (theoretical) bulk transfer rate in bits-per-second */
 static inline unsigned ncm_bitrate(struct usb_gadget *g)
 {
-	if (gadget_is_superspeed(g) && g->speed >= USB_SPEED_SUPER_PLUS)
+	if (!g)
+		return 0;
+	else if (gadget_is_superspeed(g) && g->speed >= USB_SPEED_SUPER_PLUS)
 		return 4250000000U;
 	else if (gadget_is_superspeed(g) && g->speed == USB_SPEED_SUPER)
 		return 3750000000U;


