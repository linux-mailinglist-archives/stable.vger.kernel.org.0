Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F42541767
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352540AbiFGVDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379037AbiFGVB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:01:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D085188E5D;
        Tue,  7 Jun 2022 11:46:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16688B82018;
        Tue,  7 Jun 2022 18:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E413C385A2;
        Tue,  7 Jun 2022 18:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627573;
        bh=K8cwRLy74nAcCeG16MeX91VwfthlBiQKw/yx2Lx2yrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSdp7ax7dD5jHf7UdMMb/VP+niYer8Q357UeAGPb+Ru5JlVBY376lVlIvx2LTLg9I
         2WAD4wpRHK2fGNnPWkAULKaVMuwqW1NAR5KC3s6qIXBjWoE1ynP0U3T7DPsoidjjZS
         Ev0Tph7oqE6QP/80ADikbgysZdE6EqABZROM3nh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Monish Kumar R <monish.kumar.r@intel.com>
Subject: [PATCH 5.18 017/879] USB: new quirk for Dell Gen 2 devices
Date:   Tue,  7 Jun 2022 18:52:15 +0200
Message-Id: <20220607165003.172540432@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Monish Kumar R <monish.kumar.r@intel.com>

commit 97fa5887cf283bb75ffff5f6b2c0e71794c02400 upstream.

Add USB_QUIRK_NO_LPM and USB_QUIRK_RESET_RESUME quirks for Dell usb gen
2 device to not fail during enumeration.

Found this bug on own testing

Signed-off-by: Monish Kumar R <monish.kumar.r@intel.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220520130044.17303-1-monish.kumar.r@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -510,6 +510,9 @@ static const struct usb_device_id usb_qu
 	/* DJI CineSSD */
 	{ USB_DEVICE(0x2ca3, 0x0031), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* DELL USB GEN2 */
+	{ USB_DEVICE(0x413c, 0xb062), .driver_info = USB_QUIRK_NO_LPM | USB_QUIRK_RESET_RESUME },
+
 	/* VCOM device */
 	{ USB_DEVICE(0x4296, 0x7570), .driver_info = USB_QUIRK_CONFIG_INTF_STRINGS },
 


