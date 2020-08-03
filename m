Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479D423A440
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgHCMZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:25:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727021AbgHCMZI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:25:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DEB3204EC;
        Mon,  3 Aug 2020 12:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457507;
        bh=rZcy60kFi4xUciZ3M6ajETGC0IBrF7cILGnScHXKouI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTeifUL65PIoIjF0iBm84C95pypZ7WWaKtbewr1t/pqc/otUkjd2Iqwq+vowcVnSe
         hCj4s80WTPF64ptyJ/WJOPogopyXjm6Z3NfFV17NyQJ0XnLqrqE0lsRQQeL8rnovhn
         fJcTtqS4hRsDs9TLcwdr8iaseVcVeqGfEJr43ymU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Woojung.Huh@microchip.com" <Woojung.Huh@microchip.com>,
        Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 063/120] net: lan78xx: fix transfer-buffer memory leak
Date:   Mon,  3 Aug 2020 14:18:41 +0200
Message-Id: <20200803121905.872450320@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 63634aa679ba8b5e306ad0727120309ae6ba8a8e ]

The interrupt URB transfer-buffer was never freed on disconnect or after
probe errors.

Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
Cc: Woojung.Huh@microchip.com <Woojung.Huh@microchip.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index d7162690e3f3d..ee062b27cfa7b 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3788,6 +3788,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 			usb_fill_int_urb(dev->urb_intr, dev->udev,
 					 dev->pipe_intr, buf, maxp,
 					 intr_complete, dev, period);
+			dev->urb_intr->transfer_flags |= URB_FREE_BUFFER;
 		}
 	}
 
-- 
2.25.1



