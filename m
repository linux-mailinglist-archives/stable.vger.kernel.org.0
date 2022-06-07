Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DD75410B2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354460AbiFGT3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356695AbiFGT2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:28:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724591A0AE1;
        Tue,  7 Jun 2022 11:10:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D9046191F;
        Tue,  7 Jun 2022 18:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554F5C385A2;
        Tue,  7 Jun 2022 18:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625427;
        bh=K8cwRLy74nAcCeG16MeX91VwfthlBiQKw/yx2Lx2yrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1vuVRfb+hk1LMvf9hJPPOT3q3l5DEV9anAuS5GdXRkbKa11lNiRYiXIca7zKigm9O
         mn0B/HnSdhhYfNgs7d17ladQG9xY6l7xxUK0ZD3/9Nf7BCiBrE8bS8Zkq9miISSVeu
         H0fArcN07aACJJ7Nmkt3CuzfNJvu8ygAJ4Xrt5MU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Monish Kumar R <monish.kumar.r@intel.com>
Subject: [PATCH 5.17 016/772] USB: new quirk for Dell Gen 2 devices
Date:   Tue,  7 Jun 2022 18:53:28 +0200
Message-Id: <20220607164949.482801417@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
 


