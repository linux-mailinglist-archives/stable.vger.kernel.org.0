Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B927E615AEC
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiKBDoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbiKBDoF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:44:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E672640
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:44:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F462B82063
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD47C433D7;
        Wed,  2 Nov 2022 03:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667360641;
        bh=oEXnzrPac/p2f1kS5mA5PWq27C3ZVkCof+DLYzM/U/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c/tELy//mL2XeLlTCFQjjgoqJsZuw7cuZFy2JQCqcZTKGdms+pl69nv+NF4ECUxnv
         u3eszEJcIRCp4UtZpnAwKZHOBla8ItpMfQI+vAPG6EbhFDSkbtfX6Pp0Nshi32Fnnq
         m/hHSqbWZCYoG1woyNiN058bd6rMycKKowKBX0H0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hannu Hartikainen <hannu@hrtk.in>,
        stable <stable@kernel.org>
Subject: [PATCH 4.9 12/44] USB: add RESET_RESUME quirk for NVIDIA Jetson devices in RCM
Date:   Wed,  2 Nov 2022 03:34:58 +0100
Message-Id: <20221102022049.469333317@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022049.017479464@linuxfoundation.org>
References: <20221102022049.017479464@linuxfoundation.org>
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
@@ -227,6 +227,15 @@ static const struct usb_device_id usb_qu
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
 


