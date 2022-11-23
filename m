Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B83DD63537F
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 09:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236750AbiKWI4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 03:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236754AbiKWI4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 03:56:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE1FE9315
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 00:55:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93280B81EF2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 08:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F16C433C1;
        Wed, 23 Nov 2022 08:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669193757;
        bh=M1pDf2ryOH64RS4hj7gCVNQb7Z47DgJVBMWguwNNuIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQjUT08HwqylDwmyFhLkJeAZLK3DKB5dVpVhI9vihc/FfYlZPQRiOrcvsGzBzz60g
         V0cXkxILyoiulqkYMd54zdIZ0igJawWGZ07+UE/gry/QZ/ZnkvtbDN+6XThoxzaTIu
         GvQp5/X+Azy8PUg7UL26H8ZFpfFbwtzMd7UADDPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Davide Tronchin <davide.tronchin.94@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 51/76] USB: serial: option: remove old LARA-R6 PID
Date:   Wed, 23 Nov 2022 09:50:50 +0100
Message-Id: <20221123084548.429339889@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
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

From: Davide Tronchin <davide.tronchin.94@gmail.com>

commit 2ec106b96afc19698ff934323b633c0729d4c7f8 upstream.

Remove the UBLOX_PRODUCT_R6XX 0x90fa association since LARA-R6 00B final
product uses a new USB composition with different PID. 0x90fa PID used
only by LARA-R6 internal prototypes.

Move 0x90fa PID directly in the option_ids array since used by other
Qualcomm based modem vendors as pointed out in:

  https://lore.kernel.org/all/6572c4e6-d8bc-b8d3-4396-d879e4e76338@gmail.com

Signed-off-by: Davide Tronchin <davide.tronchin.94@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -243,7 +243,6 @@ static void option_instat_callback(struc
 #define QUECTEL_PRODUCT_UC15			0x9090
 /* These u-blox products use Qualcomm's vendor ID */
 #define UBLOX_PRODUCT_R410M			0x90b2
-#define UBLOX_PRODUCT_R6XX			0x90fa
 /* These Yuga products use Qualcomm's vendor ID */
 #define YUGA_PRODUCT_CLM920_NC5			0x9625
 
@@ -1118,7 +1117,7 @@ static const struct usb_device_id option
 	/* u-blox products using Qualcomm vendor ID */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, UBLOX_PRODUCT_R410M),
 	  .driver_info = RSVD(1) | RSVD(3) },
-	{ USB_DEVICE(QUALCOMM_VENDOR_ID, UBLOX_PRODUCT_R6XX),
+	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x90fa),
 	  .driver_info = RSVD(3) },
 	/* Quectel products using Quectel vendor ID */
 	{ USB_DEVICE(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC21),


