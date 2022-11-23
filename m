Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 412066358F7
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236157AbiKWKFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236770AbiKWKE0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:04:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EE81121F1
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:55:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D193B81EE6
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:55:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B10AC433D6;
        Wed, 23 Nov 2022 09:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197352;
        bh=JnJnvlZZy9vjTNKlPvZjDSsxAK8c+iBV6yQeRvO3Kug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g1P7jJpqEST88PbT51Q6gvC5FSV6J7LR+kS/RvUzI6k04e/fy6JjrPQdc+LPTf1+A
         S0sFEut5GboFrnOGaWqWzk1Zt0w2Z3IRorA3F/QXjnkQUmz6cyEWpBsz+hHfHsml0/
         ApWlt+N+BjLYzAUGs8OxdPHWQQ3mO9eITAjRFtaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nicolas Dumazet <ndumazet@google.com>
Subject: [PATCH 6.0 239/314] usb: add NO_LPM quirk for Realforce 87U Keyboard
Date:   Wed, 23 Nov 2022 09:51:24 +0100
Message-Id: <20221123084636.300702457@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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
 


