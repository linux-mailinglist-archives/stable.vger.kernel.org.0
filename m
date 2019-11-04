Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 228D8EF079
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730192AbfKDVtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:49:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730253AbfKDVtH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:49:07 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48E7A214E0;
        Mon,  4 Nov 2019 21:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904146;
        bh=AEX36XsO5lXsy2UodCcGI6ADsqU81+EXoRM9bAA0rL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RBnT+5a/zBqqoeHD9eI/D0qimdESwT5ExwTr9lHXWimODsiSxPVm1ETbM15y1gjFd
         ufT02DJfZguxrv3gzygUWOVNVLyTCQeG6GFogRmQhkIRg/n4Ckt3HYgToI5oLqIMR2
         vqKLLWj/cTwupgB4T4cf7uRqrVyJJTJ8Qa813Syo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f1842130bbcfb335bac1@syzkaller.appspotmail.com,
        Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 42/46] net: usb: sr9800: fix uninitialized local variable
Date:   Mon,  4 Nov 2019 22:45:13 +0100
Message-Id: <20191104211914.396887035@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104211830.912265604@linuxfoundation.org>
References: <20191104211830.912265604@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Vidic <vvidic@valentin-vidic.from.hr>

commit 77b6d09f4ae66d42cd63b121af67780ae3d1a5e9 upstream.

Make sure res does not contain random value if the call to
sr_read_cmd fails for some reason.

Reported-by: syzbot+f1842130bbcfb335bac1@syzkaller.appspotmail.com
Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/sr9800.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/sr9800.c
+++ b/drivers/net/usb/sr9800.c
@@ -336,7 +336,7 @@ static void sr_set_multicast(struct net_
 static int sr_mdio_read(struct net_device *net, int phy_id, int loc)
 {
 	struct usbnet *dev = netdev_priv(net);
-	__le16 res;
+	__le16 res = 0;
 
 	mutex_lock(&dev->phy_mutex);
 	sr_set_sw_mii(dev);


