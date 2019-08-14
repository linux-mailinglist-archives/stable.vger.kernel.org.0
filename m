Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2398DA40
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731040AbfHNROO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:14:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731038AbfHNROO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:14:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CCF62084D;
        Wed, 14 Aug 2019 17:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802853;
        bh=Qxmb6vn3g3QEs2Y31wCulIpv1Hya/mij5H+crVxaM88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EHC3Wa+T57ba0CnRsEa+eahM0T0ONgixcwBgYy5DJZQc0CmI5Mx47k3Ed9itIOh6e
         w38N+N0nhJgd4irFPqgR+vFCyM7Lvg/C3d5XJqqmRdsBLT77ogGxJTd/sqbgPZPCLE
         qAAe7tln71Cfyp1EV8mUtcmJ8Cq3UTcSGWPOB6js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Bortoli <tomasbortoli@gmail.com>,
        syzbot+d6a5a1a3657b596ef132@syzkaller.appspotmail.com,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.14 52/69] can: peak_usb: pcan_usb_pro: Fix info-leaks to USB devices
Date:   Wed, 14 Aug 2019 19:01:50 +0200
Message-Id: <20190814165749.015597775@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
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
 


