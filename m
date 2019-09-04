Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD37CA8E12
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733021AbfIDRz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:55:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:32994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733000AbfIDRz4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:55:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CABD522CED;
        Wed,  4 Sep 2019 17:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619756;
        bh=/zz8r7EZO+1IMMn/392TYhPu1fvB5TNuOucyXPt4Zrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FsphpiBbzwGW5HsFwkgQOK4u/jWDOGESBakwC18lTeTYv78SXOPzQxc0reEl7WeAH
         NA9BKtsaKb7dslCKYX0d9Z0oyiKYAHrtPgfNV7jEYp+NRw788J8zfaZLFvBeJuiNxR
         rdNqmG1KhhGiycuIgsZOTPL1EPeIBVPpZ/LGEufk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Xiayang <xywang.sjtu@sjtu.edu.cn>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 15/77] can: peak_usb: force the string buffer NULL-terminated
Date:   Wed,  4 Sep 2019 19:53:02 +0200
Message-Id: <20190904175305.089206368@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
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
index e13bc27b42911..b1d68f49b3989 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -881,7 +881,7 @@ static void peak_usb_disconnect(struct usb_interface *intf)
 
 		dev_prev_siblings = dev->prev_siblings;
 		dev->state &= ~PCAN_USB_STATE_CONNECTED;
-		strncpy(name, netdev->name, IFNAMSIZ);
+		strlcpy(name, netdev->name, IFNAMSIZ);
 
 		unregister_netdev(netdev);
 
-- 
2.20.1



