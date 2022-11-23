Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57EC963554E
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237287AbiKWJRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237308AbiKWJRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:17:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5868F10891B
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:16:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D904061B10
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD299C433C1;
        Wed, 23 Nov 2022 09:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195005;
        bh=QFGnn7q7ymSY6xi5+Jbc9Eit6+uYnFqG2uPeexq/A+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KymphvRyrVOeTr5Jjw+LeXme063DxQGN+NOnSQoatu7knFQ3NCQ2QjKDL/JlzNQz0
         ZXnum4/gdghZJdWHQDgKyhkozoAblCOj5ErsMXIvNSezjycaKNbgFzhoOEOdQl32vv
         QGqQ4Jtwx8EDFqD9n3Jeq5r+x2ztqGXRuOLUSygA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Davide Tronchin <davide.tronchin.94@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 120/156] USB: serial: option: remove old LARA-R6 PID
Date:   Wed, 23 Nov 2022 09:51:17 +0100
Message-Id: <20221123084602.275998468@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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
@@ -240,7 +240,6 @@ static void option_instat_callback(struc
 #define QUECTEL_PRODUCT_UC15			0x9090
 /* These u-blox products use Qualcomm's vendor ID */
 #define UBLOX_PRODUCT_R410M			0x90b2
-#define UBLOX_PRODUCT_R6XX			0x90fa
 /* These Yuga products use Qualcomm's vendor ID */
 #define YUGA_PRODUCT_CLM920_NC5			0x9625
 
@@ -1127,7 +1126,7 @@ static const struct usb_device_id option
 	/* u-blox products using Qualcomm vendor ID */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, UBLOX_PRODUCT_R410M),
 	  .driver_info = RSVD(1) | RSVD(3) },
-	{ USB_DEVICE(QUALCOMM_VENDOR_ID, UBLOX_PRODUCT_R6XX),
+	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x90fa),
 	  .driver_info = RSVD(3) },
 	/* Quectel products using Quectel vendor ID */
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC21, 0xff, 0xff, 0xff),


