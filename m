Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B2B561BF2
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235458AbiF3Nux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235463AbiF3NuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:50:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF893A738;
        Thu, 30 Jun 2022 06:48:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB69E62006;
        Thu, 30 Jun 2022 13:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59B5C34115;
        Thu, 30 Jun 2022 13:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656596934;
        bh=uNMYW2t6tC3DwTd7860gjzRynFLv06ws74P8S6lPbe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WSAgASjJlneMge8nCvxY5L3TLNQtgngu3Oi5KYTiW+vlXUPfwJihDPqd8jiTbFwp3
         co5NsFjJ0FQOyMTh/QDS2bkJXdSnKs6cwccoVxWxW72nq+cp7JONLaStHFzfTjOZkm
         cNE4L1h+VLwreSL36USuArNhho4Taa1/73Eats1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Carlo Lobrano <c.lobrano@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 06/29] USB: serial: option: add Telit LE910Cx 0x1250 composition
Date:   Thu, 30 Jun 2022 15:46:06 +0200
Message-Id: <20220630133231.390695184@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133231.200642128@linuxfoundation.org>
References: <20220630133231.200642128@linuxfoundation.org>
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

From: Carlo Lobrano <c.lobrano@gmail.com>

commit 342fc0c3b345525da21112bd0478a0dc741598ea upstream.

Add support for the following Telit LE910Cx composition:

0x1250: rmnet, tty, tty, tty, tty

Reviewed-by: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Carlo Lobrano <c.lobrano@gmail.com>
Link: https://lore.kernel.org/r/20220614075623.2392607-1-c.lobrano@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1253,6 +1253,7 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1231, 0xff),	/* Telit LE910Cx (RNDIS) */
 	  .driver_info = NCTRL(2) | RSVD(3) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x1250, 0xff, 0x00, 0x00) },	/* Telit LE910Cx (rmnet) */
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x1260),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x1261),


