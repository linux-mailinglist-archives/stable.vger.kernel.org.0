Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D81668DA3F
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbfHNRQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:16:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731049AbfHNROQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:14:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A163821721;
        Wed, 14 Aug 2019 17:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802856;
        bh=haDGDPpQ1Pj1EGxaFFI0G/sBZ/fd/kn1SmnmBMF/z+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m+2qbvR50GlQ5guh8a/P3y5Vgz/SpgPhWwCrlsZLwyXfdaqjYY61hx8Ti7TgnlBUJ
         RrVr1Xpvq2A7EYI4pZAzLe4RXtB0QJxsge8hPzsabKySERhnao2MwYVEQb4PPT7YDJ
         Oe3h9bHDMxx2d6cpwL1MK6tiICuGPunxJ5Hq6ulw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Bortoli <tomasbortoli@gmail.com>,
        syzbot+513e4d0985298538bf9b@syzkaller.appspotmail.com,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.14 53/69] can: peak_usb: pcan_usb_fd: Fix info-leaks to USB devices
Date:   Wed, 14 Aug 2019 19:01:51 +0200
Message-Id: <20190814165749.050344988@linuxfoundation.org>
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

commit 30a8beeb3042f49d0537b7050fd21b490166a3d9 upstream.

Uninitialized Kernel memory can leak to USB devices.

Fix by using kzalloc() instead of kmalloc() on the affected buffers.

Signed-off-by: Tomas Bortoli <tomasbortoli@gmail.com>
Reported-by: syzbot+513e4d0985298538bf9b@syzkaller.appspotmail.com
Fixes: 0a25e1f4f185 ("can: peak_usb: add support for PEAK new CANFD USB adapters")
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -852,7 +852,7 @@ static int pcan_usb_fd_init(struct peak_
 			goto err_out;
 
 		/* allocate command buffer once for all for the interface */
-		pdev->cmd_buffer_addr = kmalloc(PCAN_UFD_CMD_BUFFER_SIZE,
+		pdev->cmd_buffer_addr = kzalloc(PCAN_UFD_CMD_BUFFER_SIZE,
 						GFP_KERNEL);
 		if (!pdev->cmd_buffer_addr)
 			goto err_out_1;


