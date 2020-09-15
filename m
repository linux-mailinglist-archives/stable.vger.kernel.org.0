Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00CB226B76E
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgIPAXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:23:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726691AbgIOOU6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:20:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2F8B22245;
        Tue, 15 Sep 2020 14:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179410;
        bh=wuwVLdXX2n13+HfWQm1zOODVzzKlPBYPTWU70RzIDXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UjQF7VB/bOI5Se8ZgPsG4pRLXk+y+7UWyG7kU9ND19jEb+o5HcnOaiWv2Sgaz3V/F
         dSFkiRYB3hyYhT1mjARspvCH1X241gpvFbJajutHZXaJI15R+kxnmZBWaWw/xFXXwl
         gydgHVFLQ9poXHNELr7NZjwQrTemN+AmLZ8dWrAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>,
        Xie He <xie.he.0141@gmail.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 31/78] drivers/net/wan/hdlc_cisco: Add hard_header_len
Date:   Tue, 15 Sep 2020 16:12:56 +0200
Message-Id: <20200915140635.142645939@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
References: <20200915140633.552502750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
index 320039d329c7d..c169a26e5359a 100644
--- a/drivers/net/wan/hdlc_cisco.c
+++ b/drivers/net/wan/hdlc_cisco.c
@@ -374,6 +374,7 @@ static int cisco_ioctl(struct net_device *dev, struct ifreq *ifr)
 		memcpy(&state(hdlc)->settings, &new_settings, size);
 		spin_lock_init(&state(hdlc)->lock);
 		dev->header_ops = &cisco_header_ops;
+		dev->hard_header_len = sizeof(struct hdlc_header);
 		dev->type = ARPHRD_CISCO;
 		call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE, dev);
 		netif_dormant_on(dev);
-- 
2.25.1



