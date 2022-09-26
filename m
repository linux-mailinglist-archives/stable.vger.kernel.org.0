Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF915EA1E2
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236937AbiIZK7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236939AbiIZK6c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:58:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD9849B7F;
        Mon, 26 Sep 2022 03:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8500160A55;
        Mon, 26 Sep 2022 10:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D7DC433C1;
        Mon, 26 Sep 2022 10:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188146;
        bh=7IkwgSY4ueYu2L9fhFnLnHUNzfHy2KWycaZiRDnLj6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m+9coGT6t27Rf8xFrptI8SgZO4CMgCkbbo3kxHhhDagqj6GXFVYTkukLDwSlBl4r3
         Fpx/8A0NGvhfBlu7TVQ4zEXS7y6KLdGB1OCoWll72jLkKbLbMRuahTauHt9a/Eodwm
         /FpIWKjHukolF+GQSXarGAI2TxlV9E84KTdyofxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jean-Francois Le Fillatre <jflf_kernel@gmx.com>,
        stable <stable@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/141] usb: add quirks for Lenovo OneLink+ Dock
Date:   Mon, 26 Sep 2022 12:10:51 +0200
Message-Id: <20220926100755.455644852@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Francois Le Fillatre <jflf_kernel@gmx.com>

[ Upstream commit 3d5f70949f1b1168fbb17d06eb5c57e984c56c58 ]

The Lenovo OneLink+ Dock contains two VL812 USB3.0 controllers:
17ef:1018 upstream
17ef:1019 downstream

Those two controllers both have problems with some USB3.0 devices,
particularly self-powered ones. Typical error messages include:

  Timeout while waiting for setup device command
  device not accepting address X, error -62
  unable to enumerate USB device

By process of elimination the controllers themselves were identified as
the cause of the problem. Through trial and error the issue was solved
by using USB_QUIRK_RESET_RESUME for both chips.

Signed-off-by: Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20220824191320.17883-1-jflf_kernel@gmx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/quirks.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index f03ee889ecc7..03473e20e218 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -438,6 +438,10 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x1532, 0x0116), .driver_info =
 			USB_QUIRK_LINEAR_UFRAME_INTR_BINTERVAL },
 
+	/* Lenovo ThinkPad OneLink+ Dock twin hub controllers (VIA Labs VL812) */
+	{ USB_DEVICE(0x17ef, 0x1018), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x17ef, 0x1019), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Lenovo USB-C to Ethernet Adapter RTL8153-04 */
 	{ USB_DEVICE(0x17ef, 0x720c), .driver_info = USB_QUIRK_NO_LPM },
 
-- 
2.35.1



