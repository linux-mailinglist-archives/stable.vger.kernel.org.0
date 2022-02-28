Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 899384C76F5
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbiB1SKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:10:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240039AbiB1SHv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:07:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067A7B8B;
        Mon, 28 Feb 2022 09:48:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A094860909;
        Mon, 28 Feb 2022 17:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F7FC340F0;
        Mon, 28 Feb 2022 17:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070497;
        bh=2wWi9eM3qMqzJvLDsBqg8Qs3ojl5pW+KP4DJxb7mM6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WyVnLZ4GR5VnUTy793IOtOSL0fLCDeto9LBsZIh178Rt0MCoQU/aIBCoh3yP2mg9P
         Fd3iL+tLdjqWgHO3vpcrB8mBz+TbbCuVn3BLRTH7FDwnAp+6sgh2cBUaIL2X62+JoO
         l+kT4oU8FAlQEaCxeAEDb2bamhSZenkHpHdNbHPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Subject: [PATCH 5.16 129/164] usb: dwc2: drd: fix soft connect when gadget is unconfigured
Date:   Mon, 28 Feb 2022 18:24:51 +0100
Message-Id: <20220228172411.807031028@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

commit 32fde84362c40961726a5c91f35ad37355ccc0c6 upstream.

When the gadget driver hasn't been (yet) configured, and the cable is
connected to a HOST, the SFTDISCON gets cleared unconditionally, so the
HOST tries to enumerate it.
At the host side, this can result in a stuck USB port or worse. When
getting lucky, some dmesg can be observed at the host side:
 new high-speed USB device number ...
 device descriptor read/64, error -110

Fix it in drd, by checking the enabled flag before calling
dwc2_hsotg_core_connect(). It will be called later, once configured,
by the normal flow:
- udc_bind_to_driver
 - usb_gadget_connect
   - dwc2_hsotg_pullup
     - dwc2_hsotg_core_connect

Fixes: 17f934024e84 ("usb: dwc2: override PHY input signals with usb role switch support")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/1644999135-13478-1-git-send-email-fabrice.gasnier@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/core.h |    2 ++
 drivers/usb/dwc2/drd.c  |    6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc2/core.h
+++ b/drivers/usb/dwc2/core.h
@@ -1416,6 +1416,7 @@ void dwc2_hsotg_core_connect(struct dwc2
 void dwc2_hsotg_disconnect(struct dwc2_hsotg *dwc2);
 int dwc2_hsotg_set_test_mode(struct dwc2_hsotg *hsotg, int testmode);
 #define dwc2_is_device_connected(hsotg) (hsotg->connected)
+#define dwc2_is_device_enabled(hsotg) (hsotg->enabled)
 int dwc2_backup_device_registers(struct dwc2_hsotg *hsotg);
 int dwc2_restore_device_registers(struct dwc2_hsotg *hsotg, int remote_wakeup);
 int dwc2_gadget_enter_hibernation(struct dwc2_hsotg *hsotg);
@@ -1452,6 +1453,7 @@ static inline int dwc2_hsotg_set_test_mo
 					   int testmode)
 { return 0; }
 #define dwc2_is_device_connected(hsotg) (0)
+#define dwc2_is_device_enabled(hsotg) (0)
 static inline int dwc2_backup_device_registers(struct dwc2_hsotg *hsotg)
 { return 0; }
 static inline int dwc2_restore_device_registers(struct dwc2_hsotg *hsotg,
--- a/drivers/usb/dwc2/drd.c
+++ b/drivers/usb/dwc2/drd.c
@@ -109,8 +109,10 @@ static int dwc2_drd_role_sw_set(struct u
 		already = dwc2_ovr_avalid(hsotg, true);
 	} else if (role == USB_ROLE_DEVICE) {
 		already = dwc2_ovr_bvalid(hsotg, true);
-		/* This clear DCTL.SFTDISCON bit */
-		dwc2_hsotg_core_connect(hsotg);
+		if (dwc2_is_device_enabled(hsotg)) {
+			/* This clear DCTL.SFTDISCON bit */
+			dwc2_hsotg_core_connect(hsotg);
+		}
 	} else {
 		if (dwc2_is_device_mode(hsotg)) {
 			if (!dwc2_ovr_bvalid(hsotg, false))


