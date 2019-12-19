Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A640C126DA2
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbfLSSib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:38:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:56456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728029AbfLSSi2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:38:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4229D20716;
        Thu, 19 Dec 2019 18:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780707;
        bh=coJOFxAiKb+uPufThTPWg13jI6dvaaj+h4Taafrpa30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cN4GXL+ilLKNOZimoVtuRyaW3ymeiuOgSgErR7OX1Y762ZrSxcFDQbCf4MHEwvtHC
         /Zg9CIQC+Wq1BNamxaQy3Vlo7eAex3NEmh+G5TiBK54CJqxrdnJvKk4tw5/cK/QPHi
         4pkANDCqTLY5SmXj+b2IhX3nVy0dcuZ4AngXXGO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 085/162] staging: rtl8712: fix interface sanity check
Date:   Thu, 19 Dec 2019 19:33:13 +0100
Message-Id: <20191219183212.966280307@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit c724f776f048538ecfdf53a52b7a522309f5c504 upstream.

Make sure to use the current alternate setting when verifying the
interface descriptors to avoid binding to an invalid interface.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: 2865d42c78a9 ("staging: r8712u: Add the new driver to the mainline kernel")
Cc: stable <stable@vger.kernel.org>     # 2.6.37
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191210114751.5119-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8712/usb_intf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -263,7 +263,7 @@ static uint r8712_usb_dvobj_init(struct
 
 	pdvobjpriv->padapter = padapter;
 	padapter->EepromAddressSize = 6;
-	phost_iface = &pintf->altsetting[0];
+	phost_iface = pintf->cur_altsetting;
 	piface_desc = &phost_iface->desc;
 	pdvobjpriv->nr_endpoint = piface_desc->bNumEndpoints;
 	if (pusbd->speed == USB_SPEED_HIGH) {


