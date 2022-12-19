Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E666665132B
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbiLST16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:27:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbiLST1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:27:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C9BFD32
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 11:27:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E87666109A
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA72FC433D2;
        Mon, 19 Dec 2022 19:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671478056;
        bh=19bQy99WCkTDK4fymAN4LNT7NWHggw+cNV4UA016A4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wBi0XLx6BvNosKnMB69DzDw+z3ZEWDE2VSaEAVzDBglZNoeM3c8NsONkkEqxmJcAz
         eYtfgSePFbbC/qQ9gFcOesiCaCornpCsnSPTESbVxZ/KDfUHoFN4u5qKMZwP1SSdGE
         8JrLhqMuZudcub1CbP2G4P2mJx5JI5XHvP7jhoKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bruno Thomsen <bruno.thomsen@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 07/17] USB: serial: cp210x: add Kamstrup RF sniffer PIDs
Date:   Mon, 19 Dec 2022 20:24:53 +0100
Message-Id: <20221219182940.965936772@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182940.739981110@linuxfoundation.org>
References: <20221219182940.739981110@linuxfoundation.org>
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

From: Bruno Thomsen <bruno.thomsen@gmail.com>

commit e88906b169ebcb8046e8f0ad76edd09ab41cfdfe upstream.

The RF sniffers are based on cp210x where the RF frontends
are based on a different USB stack.

RF sniffers can analyze packets meta data including power level
and perform packet injection.

Can be used to perform RF frontend self-test when connected to
a concentrator, ex. arch/arm/boot/dts/imx7d-flex-concentrator.dts

Signed-off-by: Bruno Thomsen <bruno.thomsen@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -195,6 +195,8 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x16DC, 0x0015) }, /* W-IE-NE-R Plein & Baus GmbH CML Control, Monitoring and Data Logger */
 	{ USB_DEVICE(0x17A8, 0x0001) }, /* Kamstrup Optical Eye/3-wire */
 	{ USB_DEVICE(0x17A8, 0x0005) }, /* Kamstrup M-Bus Master MultiPort 250D */
+	{ USB_DEVICE(0x17A8, 0x0011) }, /* Kamstrup 444 MHz RF sniffer */
+	{ USB_DEVICE(0x17A8, 0x0013) }, /* Kamstrup 870 MHz RF sniffer */
 	{ USB_DEVICE(0x17A8, 0x0101) }, /* Kamstrup 868 MHz wM-Bus C-Mode Meter Reader (Int Ant) */
 	{ USB_DEVICE(0x17A8, 0x0102) }, /* Kamstrup 868 MHz wM-Bus C-Mode Meter Reader (Ext Ant) */
 	{ USB_DEVICE(0x17F4, 0xAAAA) }, /* Wavesense Jazz blood glucose meter */


