Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F7F635559
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237268AbiKWJRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237336AbiKWJRG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:17:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5C4106110
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:16:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27748B81EF2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31317C433C1;
        Wed, 23 Nov 2022 09:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195008;
        bh=VXRv0y6xY0jPwHcNM1H07341PsyTBnUYhW9WJTx/3uM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XL0EPxiayOUTJ37pvRR1r/B+M3yFdjNDgbt/5fqLTUcOsgkvn63282eRgDv4mVzhf
         tkRyNlQ65ZUH0qAPVGUcWZ55QTaO55sTvAz40kxc/PPwOtL8+Y/rcz8mWX0i7k6E8L
         j5afLTvsWphVR4g2AbzI94mnjxNBgT2VSiCTDidg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Davide Tronchin <davide.tronchin.94@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 121/156] USB: serial: option: add u-blox LARA-R6 00B modem
Date:   Wed, 23 Nov 2022 09:51:18 +0100
Message-Id: <20221123084602.310565950@linuxfoundation.org>
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

commit d9e37a5c4d80ea25a7171ab8557a449115554e76 upstream.

The official LARA-R6 (00B) modem uses 0x908b PID. LARA-R6 00B does not
implement a QMI interface on port 4, the reservation (RSVD(4)) has been
added to meet other companies that implement QMI on that interface.

LARA-R6 00B USB composition exposes the following interfaces:
If 0: Diagnostic
If 1: AT parser
If 2: AT parser
If 3: AT parser/alternative functions

Signed-off-by: Davide Tronchin <davide.tronchin.94@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1126,6 +1126,8 @@ static const struct usb_device_id option
 	/* u-blox products using Qualcomm vendor ID */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, UBLOX_PRODUCT_R410M),
 	  .driver_info = RSVD(1) | RSVD(3) },
+	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x908b),	/* u-blox LARA-R6 00B */
+	  .driver_info = RSVD(4) },
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x90fa),
 	  .driver_info = RSVD(3) },
 	/* Quectel products using Quectel vendor ID */


