Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9118635620
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237637AbiKWJ0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237641AbiKWJ0I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:26:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74457C4B4B
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:25:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1202161B40
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E3CC433C1;
        Wed, 23 Nov 2022 09:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195503;
        bh=JnJnvlZZy9vjTNKlPvZjDSsxAK8c+iBV6yQeRvO3Kug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y8o8aY7WeDwGSG6el5l4wA30DcHE9eM3p5G7rnsbturlmH3VCkfLDFsdXA4g7kLVZ
         EcFXmMKlzLW/16JBNc+cLwAj4uS50B11HF9SjzMsFh0OM/breI0AaK4X1No8S1s/bW
         /N+0vXEyn9Ezwb1thzgAEwSyHzqn/W5/ArnEwuuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nicolas Dumazet <ndumazet@google.com>
Subject: [PATCH 5.10 103/149] usb: add NO_LPM quirk for Realforce 87U Keyboard
Date:   Wed, 23 Nov 2022 09:51:26 +0100
Message-Id: <20221123084601.697642390@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dumazet <ndumazet@google.com>

commit 181135bb20dcb184edd89817831b888eb8132741 upstream.

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
Link: https://lore.kernel.org/r/20221109122946.706036-1-ndumazet@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -362,6 +362,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0781, 0x5583), .driver_info = USB_QUIRK_NO_LPM },
 	{ USB_DEVICE(0x0781, 0x5591), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* Realforce 87U Keyboard */
+	{ USB_DEVICE(0x0853, 0x011b), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* M-Systems Flash Disk Pioneers */
 	{ USB_DEVICE(0x08ec, 0x1000), .driver_info = USB_QUIRK_RESET_RESUME },
 


