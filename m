Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D99993A947
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388644AbfFIREe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:04:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388631AbfFIREd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:04:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE36220833;
        Sun,  9 Jun 2019 17:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099873;
        bh=PHC6wVTNr/ilVN+aLfu0QMFCGVE1NOjtBg+sd/FYZzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WwDE+Z/pDU6nwLa9jOvaAqh92FosCHA7bPPxl16S6XCL9H1512ED+dFZCPKbnbnQn
         gSw0I3ObJ7jT8dtDX8+1ipjLrXd4eDu2Gs6tptJ2VpgcQijOBKlEdUU3WA6Dw2S8ct
         Sv568Zb3cNxaYHvUz3GdhRp62zF0T7YoaOyJ7z+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maximilian Luz <luzmaximilian@gmail.com>
Subject: [PATCH 4.4 198/241] USB: Add LPM quirk for Surface Dock GigE adapter
Date:   Sun,  9 Jun 2019 18:42:20 +0200
Message-Id: <20190609164153.705490862@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maximilian Luz <luzmaximilian@gmail.com>

commit ea261113385ac0a71c2838185f39e8452d54b152 upstream.

Without USB_QUIRK_NO_LPM ethernet will not work and rtl8152 will
complain with

    r8152 <device...>: Stop submitting intr, status -71

Adding the quirk resolves this. As the dock is externally powered, this
should not have any drawbacks.

Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -64,6 +64,9 @@ static const struct usb_device_id usb_qu
 	/* Microsoft LifeCam-VX700 v2.0 */
 	{ USB_DEVICE(0x045e, 0x0770), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Microsoft Surface Dock Ethernet (RTL8153 GigE) */
+	{ USB_DEVICE(0x045e, 0x07c6), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Cherry Stream G230 2.0 (G85-231) and 3.0 (G85-232) */
 	{ USB_DEVICE(0x046a, 0x0023), .driver_info = USB_QUIRK_RESET_RESUME },
 


