Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1291761597E
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbiKBDMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiKBDMc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:12:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50339248F3
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:12:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E265A616DB
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:11:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DA3C433D6;
        Wed,  2 Nov 2022 03:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358719;
        bh=UPlBCDytGL6K7AIh8Bj348XOo71VKjaEn7zRWmXg+jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tymX+VsckXg23lXelYOzoLKPpl7xK8/utWEXzEfBeabGhMgEs0D7ZeuF1prB5MEhe
         cIjZ2TCHN/wdCL9VbwCkFa2uhrAhiY5CRj/7+H9ryKEDuciNzdntRggGxzcJx9B4IA
         CYQZgA/NYm8RTPKn3GOjdBN+BGlreXof3Y5HkDvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hannu Hartikainen <hannu@hrtk.in>,
        stable <stable@kernel.org>
Subject: [PATCH 5.10 06/91] USB: add RESET_RESUME quirk for NVIDIA Jetson devices in RCM
Date:   Wed,  2 Nov 2022 03:32:49 +0100
Message-Id: <20221102022055.222027327@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannu Hartikainen <hannu@hrtk.in>

commit fc4ade55c617dc73c7e9756b57f3230b4ff24540 upstream.

NVIDIA Jetson devices in Force Recovery mode (RCM) do not support
suspending, ie. flashing fails if the device has been suspended. The
devices are still visible in lsusb and seem to work otherwise, making
the issue hard to debug. This has been discovered in various forum
posts, eg. [1].

The patch has been tested on NVIDIA Jetson AGX Xavier, but I'm adding
all the Jetson models listed in [2] on the assumption that they all
behave similarly.

[1]: https://forums.developer.nvidia.com/t/flashing-not-working/72365
[2]: https://docs.nvidia.com/jetson/archives/l4t-archived/l4t-3271/index.html#page/Tegra%20Linux%20Driver%20Package%20Development%20Guide/quick_start.html

Signed-off-by: Hannu Hartikainen <hannu@hrtk.in>
Cc: stable <stable@kernel.org>  # after 6.1-rc3
Link: https://lore.kernel.org/r/20220919171610.30484-1-hannu@hrtk.in
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -388,6 +388,15 @@ static const struct usb_device_id usb_qu
 	/* Kingston DataTraveler 3.0 */
 	{ USB_DEVICE(0x0951, 0x1666), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* NVIDIA Jetson devices in Force Recovery mode */
+	{ USB_DEVICE(0x0955, 0x7018), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7019), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7418), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7721), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7c18), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7e19), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7f21), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* X-Rite/Gretag-Macbeth Eye-One Pro display colorimeter */
 	{ USB_DEVICE(0x0971, 0x2000), .driver_info = USB_QUIRK_NO_SET_INTF },
 


