Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E008F28B993
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731400AbgJLOBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731061AbgJLNiF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:38:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D69F9206D9;
        Mon, 12 Oct 2020 13:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509884;
        bh=DPJ7hSF8Bve5Cv5O4DeRfsryLXidSFc+kkrXAutzhMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0wmf9JptQr5XeSN9Jb/T5HsjjHA/zDhT68NTOrZuh0Xsfk3kqMs/QHw07IEmTmplg
         BQarp77Cj/o1faiRfngxzhgTHJQROfj8iogQprcn24QqFKKDM1YctAz8LNCM8DUDnG
         Diw2LD03CxXP4YPp3t131gNbLGH8E2gAGLUBuMOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        Petko Manolov <petkan@nucleusys.com>,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 70/70] net: usb: rtl8150: set random MAC address when set_ethernet_addr() fails
Date:   Mon, 12 Oct 2020 15:27:26 +0200
Message-Id: <20201012132633.582211822@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132630.201442517@linuxfoundation.org>
References: <20201012132630.201442517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>

commit f45a4248ea4cc13ed50618ff066849f9587226b2 upstream.

When get_registers() fails in set_ethernet_addr(),the uninitialized
value of node_id gets copied over as the address.
So, check the return value of get_registers().

If get_registers() executed successfully (i.e., it returns
sizeof(node_id)), copy over the MAC address using ether_addr_copy()
(instead of using memcpy()).

Else, if get_registers() failed instead, a randomly generated MAC
address is set as the MAC address instead.

Reported-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
Tested-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
Acked-by: Petko Manolov <petkan@nucleusys.com>
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/rtl8150.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -277,12 +277,20 @@ static int write_mii_word(rtl8150_t * de
 		return 1;
 }
 
-static inline void set_ethernet_addr(rtl8150_t * dev)
+static void set_ethernet_addr(rtl8150_t *dev)
 {
-	u8 node_id[6];
+	u8 node_id[ETH_ALEN];
+	int ret;
 
-	get_registers(dev, IDR, sizeof(node_id), node_id);
-	memcpy(dev->netdev->dev_addr, node_id, sizeof(node_id));
+	ret = get_registers(dev, IDR, sizeof(node_id), node_id);
+
+	if (ret == sizeof(node_id)) {
+		ether_addr_copy(dev->netdev->dev_addr, node_id);
+	} else {
+		eth_hw_addr_random(dev->netdev);
+		netdev_notice(dev->netdev, "Assigned a random MAC address: %pM\n",
+			      dev->netdev->dev_addr);
+	}
 }
 
 static int rtl8150_set_mac_address(struct net_device *netdev, void *p)


