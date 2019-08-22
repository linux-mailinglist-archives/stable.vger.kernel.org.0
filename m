Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBBC99E16
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390248AbfHVRWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390086AbfHVRWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:22:24 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8815D23400;
        Thu, 22 Aug 2019 17:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494543;
        bh=Qxmb6vn3g3QEs2Y31wCulIpv1Hya/mij5H+crVxaM88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjLbz9wTxNUVQPH4Z86eUWQ/k4JUU7WkvfadNanE5tktece7lJ+aMfP11rhTFmvmL
         TrcRiitOJ4VtweJhWegj6/1VxYbJzurU4YZsmBofk66dASBA689rwDasa1D0VOdfN8
         tvGkAEjjVrzkP8nKG671kvqTEzR6JtnfZv+yh1lQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Bortoli <tomasbortoli@gmail.com>,
        syzbot+d6a5a1a3657b596ef132@syzkaller.appspotmail.com,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.4 24/78] can: peak_usb: pcan_usb_pro: Fix info-leaks to USB devices
Date:   Thu, 22 Aug 2019 10:18:28 -0700
Message-Id: <20190822171832.743353746@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
References: <20190822171832.012773482@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Bortoli <tomasbortoli@gmail.com>

commit ead16e53c2f0ed946d82d4037c630e2f60f4ab69 upstream.

Uninitialized Kernel memory can leak to USB devices.

Fix by using kzalloc() instead of kmalloc() on the affected buffers.

Signed-off-by: Tomas Bortoli <tomasbortoli@gmail.com>
Reported-by: syzbot+d6a5a1a3657b596ef132@syzkaller.appspotmail.com
Fixes: f14e22435a27 ("net: can: peak_usb: Do not do dma on the stack")
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
@@ -500,7 +500,7 @@ static int pcan_usb_pro_drv_loaded(struc
 	u8 *buffer;
 	int err;
 
-	buffer = kmalloc(PCAN_USBPRO_FCT_DRVLD_REQ_LEN, GFP_KERNEL);
+	buffer = kzalloc(PCAN_USBPRO_FCT_DRVLD_REQ_LEN, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 


