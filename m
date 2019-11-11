Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC37F7ADB
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbfKKSaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:30:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:46558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727233AbfKKSaS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:30:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B01121872;
        Mon, 11 Nov 2019 18:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497017;
        bh=MhwysxzrPP8U0AyewFs2CO+gnz0t7KiWLupNAWT4sh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IjfeNgtLHm0iJpAqHu/+7Kzmk30I3UcrWCdVEpwWhSBBUB2InRYzZvYkpb6DnMGhl
         QmY4C9J99t7wCDJ+XffJIC1FXM+iNjRmXhiYkPs5nvZUk9O02qsfDPwLI8iIQTDLEX
         Zd6+Lwa0eSF3ap0WYBLeQXBwcSr9jdOIx/Pt2QiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bernd Krumboeck <b.krumboeck@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Johan Hovold <johan@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.4 18/43] can: usb_8dev: fix use-after-free on disconnect
Date:   Mon, 11 Nov 2019 19:28:32 +0100
Message-Id: <20191111181308.023127685@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181246.772983347@linuxfoundation.org>
References: <20191111181246.772983347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 3759739426186a924675651b388d1c3963c5710e upstream.

The driver was accessing its driver data after having freed it.

Fixes: 0024d8ad1639 ("can: usb_8dev: Add support for USB2CAN interface from 8 devices")
Cc: stable <stable@vger.kernel.org>     # 3.9
Cc: Bernd Krumboeck <b.krumboeck@gmail.com>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/usb/usb_8dev.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -1010,9 +1010,8 @@ static void usb_8dev_disconnect(struct u
 		netdev_info(priv->netdev, "device disconnected\n");
 
 		unregister_netdev(priv->netdev);
-		free_candev(priv->netdev);
-
 		unlink_all_urbs(priv);
+		free_candev(priv->netdev);
 	}
 
 }


