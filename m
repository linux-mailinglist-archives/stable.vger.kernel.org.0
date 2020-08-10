Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F2A240A29
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728518AbgHJPi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:38:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728519AbgHJPZX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:25:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6368320772;
        Mon, 10 Aug 2020 15:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073123;
        bh=LkQW149vxvATCcnfXNY3V0vJIT4un2JITToFateBwLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dl/Lp5T2JI13LmCQQhhNktEA7piuv5k7yViWiO00oKlSw1zjho8RvtPX/d8KVrpm4
         qC0Ep9TKAY+mL2H29ujzPhJWyr3lFVlO6oWh2Czyqa02nCHJ95GbWX+9mDkYCqNydP
         HX+pnY9s9DjUHCcpHJm8vnK1z5sb2HiSHrOUm4HE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rustam Kovhaev <rkovhaev@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+67b2bd0e34f952d0321e@syzkaller.appspotmail.com
Subject: [PATCH 5.7 44/79] usb: hso: check for return value in hso_serial_common_create()
Date:   Mon, 10 Aug 2020 17:21:03 +0200
Message-Id: <20200810151814.450888103@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rustam Kovhaev <rkovhaev@gmail.com>

[ Upstream commit e911e99a0770f760377c263bc7bac1b1593c6147 ]

in case of an error tty_register_device_attr() returns ERR_PTR(),
add IS_ERR() check

Reported-and-tested-by: syzbot+67b2bd0e34f952d0321e@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=67b2bd0e34f952d0321e
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/hso.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 5f123a8cf68ed..d2fdb5430d272 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2261,12 +2261,14 @@ static int hso_serial_common_create(struct hso_serial *serial, int num_urbs,
 
 	minor = get_free_serial_index();
 	if (minor < 0)
-		goto exit;
+		goto exit2;
 
 	/* register our minor number */
 	serial->parent->dev = tty_port_register_device_attr(&serial->port,
 			tty_drv, minor, &serial->parent->interface->dev,
 			serial->parent, hso_serial_dev_groups);
+	if (IS_ERR(serial->parent->dev))
+		goto exit2;
 
 	/* fill in specific data for later use */
 	serial->minor = minor;
@@ -2311,6 +2313,7 @@ static int hso_serial_common_create(struct hso_serial *serial, int num_urbs,
 	return 0;
 exit:
 	hso_serial_tty_unregister(serial);
+exit2:
 	hso_serial_common_free(serial);
 	return -1;
 }
-- 
2.25.1



