Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B956F23A607
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbgHCM2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:28:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727908AbgHCM2w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:28:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53FD3208E4;
        Mon,  3 Aug 2020 12:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457730;
        bh=jL9S8E1aRsFyMZRNQR4wIAVSmZSOi4xsEA0kdU+usTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M8dR4XBqc/vukeTsWMoh20nJWVHFWND5ymz7+AlENCI+UAtS0pz/ACLBPqNJs2O3P
         6WQq+lZ9Yh2hj00CvYliaQcRMth9EjwdwvkLr0DXJ+O3k3yhDhCrx3h9xgNNb0gtiv
         RA7eOqLiZtRwUrn1LlI8kJXVEBJxZbTAxGmygbck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Woojung.Huh@microchip.com" <Woojung.Huh@microchip.com>,
        Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 53/90] net: lan78xx: fix transfer-buffer memory leak
Date:   Mon,  3 Aug 2020 14:19:15 +0200
Message-Id: <20200803121900.193714519@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
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
index 54ce1ed1ea379..1da99abc6ed15 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3796,6 +3796,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 			usb_fill_int_urb(dev->urb_intr, dev->udev,
 					 dev->pipe_intr, buf, maxp,
 					 intr_complete, dev, period);
+			dev->urb_intr->transfer_flags |= URB_FREE_BUFFER;
 		}
 	}
 
-- 
2.25.1



