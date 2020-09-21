Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7EF27302F
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbgIUQhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:37:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729040AbgIUQhM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:37:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 707D0206B7;
        Mon, 21 Sep 2020 16:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706231;
        bh=zPaXF53HJOhCMm4iH+1r//KMldENlKCw7dZCzzwKWwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yYpBVX3TPk0EjbJa7Xb0K6jvMy8j7qEwhBBZA37Y3kzG6JkVqCZH7RBb9WlxeculI
         gQZpF+hqH6/OR0R3lrarDVwi7lHJnyxsYEdEp9iAQAn90gVf5S70uof4aB2TaNpJwh
         ivFbIOc+n/vXxBJe9x8npgjkXyA/J3kg3tp13hQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>,
        Xie He <xie.he.0141@gmail.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 18/94] drivers/net/wan/hdlc_cisco: Add hard_header_len
Date:   Mon, 21 Sep 2020 18:27:05 +0200
Message-Id: <20200921162036.385560139@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 1a545ebe380bf4c1433e3c136e35a77764fda5ad ]

This driver didn't set hard_header_len. This patch sets hard_header_len
for it according to its header_ops->create function.

This driver's header_ops->create function (cisco_hard_header) creates
a header of (struct hdlc_header), so hard_header_len should be set to
sizeof(struct hdlc_header).

Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Acked-by: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/hdlc_cisco.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wan/hdlc_cisco.c b/drivers/net/wan/hdlc_cisco.c
index a408abc25512a..7f99fb666f196 100644
--- a/drivers/net/wan/hdlc_cisco.c
+++ b/drivers/net/wan/hdlc_cisco.c
@@ -377,6 +377,7 @@ static int cisco_ioctl(struct net_device *dev, struct ifreq *ifr)
 		memcpy(&state(hdlc)->settings, &new_settings, size);
 		spin_lock_init(&state(hdlc)->lock);
 		dev->header_ops = &cisco_header_ops;
+		dev->hard_header_len = sizeof(struct hdlc_header);
 		dev->type = ARPHRD_CISCO;
 		call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE, dev);
 		netif_dormant_on(dev);
-- 
2.25.1



