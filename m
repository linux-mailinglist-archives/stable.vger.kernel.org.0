Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C44489E1C6
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730437AbfH0Hzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:55:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729882AbfH0Hzx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:55:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 655B22173E;
        Tue, 27 Aug 2019 07:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892552;
        bh=1Eir6p1IJc3GuA2YZmW8Q30KvMsKNY/uEj1b4mVJxhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0FrP7qabd6+3CSwL29xaJFXxaJ5V4F0va3FayK+3dDk8tTtW+El/U31lNd9mvUzC/
         ju9YDVELrvxRmeBCmJ12vDU2v7/su1tpiO1nrnfPH3hKr2k+XQN8Nm3oPFH05cDtx9
         mr3BPlOlLSzysHaNo6OO+OeIlwVJzLthEc0m60Bo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Xiayang <xywang.sjtu@sjtu.edu.cn>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 32/98] can: peak_usb: force the string buffer NULL-terminated
Date:   Tue, 27 Aug 2019 09:50:11 +0200
Message-Id: <20190827072719.856511677@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e787f19373b8a5fa24087800ed78314fd17b984a ]

strncpy() does not ensure NULL-termination when the input string size
equals to the destination buffer size IFNAMSIZ. The output string is
passed to dev_info() which relies on the NULL-termination.

Use strlcpy() instead.

This issue is identified by a Coccinelle script.

Signed-off-by: Wang Xiayang <xywang.sjtu@sjtu.edu.cn>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index 740ef47eab017..43b0fa2b99322 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -863,7 +863,7 @@ static void peak_usb_disconnect(struct usb_interface *intf)
 
 		dev_prev_siblings = dev->prev_siblings;
 		dev->state &= ~PCAN_USB_STATE_CONNECTED;
-		strncpy(name, netdev->name, IFNAMSIZ);
+		strlcpy(name, netdev->name, IFNAMSIZ);
 
 		unregister_netdev(netdev);
 
-- 
2.20.1



