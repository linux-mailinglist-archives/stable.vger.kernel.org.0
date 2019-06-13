Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E41754414E
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391535AbfFMQNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:13:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731207AbfFMImx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:42:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9470E21479;
        Thu, 13 Jun 2019 08:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415373;
        bh=xuLEzwhyNFJ2HZQLEKuZAx6LJY39JVZkhMurscu71Xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SbQ+yBWXo0MCQQgBRqhyuSJQCwheNZQ5LN2vFbXgxRCytz3iCA7/xwhXhZNa8yuXA
         9m6FrXfhOgJTd7sPuo90E+YDmMP6m286oZm1uzjivQXzdJPRuwqxmlt/v0NJw9e1M2
         81fD/xbO/Q3U20yIo6ghnAyzOn48PgwRB03bFAbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 072/118] net: thunderbolt: Unregister ThunderboltIP protocol handler when suspending
Date:   Thu, 13 Jun 2019 10:33:30 +0200
Message-Id: <20190613075648.088056720@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9872760eb7b1d4f6066ad8b560714a5d0a728fdb ]

The XDomain protocol messages may start as soon as Thunderbolt control
channel is started. This means that if the other host starts sending
ThunderboltIP packets early enough they will be passed to the network
driver which then gets confused because its resume hook is not called
yet.

Fix this by unregistering the ThunderboltIP protocol handler when
suspending and registering it back on resume.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/thunderbolt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index e0d6760f3219..4b5af2413970 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -1285,6 +1285,7 @@ static int __maybe_unused tbnet_suspend(struct device *dev)
 		tbnet_tear_down(net, true);
 	}
 
+	tb_unregister_protocol_handler(&net->handler);
 	return 0;
 }
 
@@ -1293,6 +1294,8 @@ static int __maybe_unused tbnet_resume(struct device *dev)
 	struct tb_service *svc = tb_to_service(dev);
 	struct tbnet *net = tb_service_get_drvdata(svc);
 
+	tb_register_protocol_handler(&net->handler);
+
 	netif_carrier_off(net->dev);
 	if (netif_running(net->dev)) {
 		netif_device_attach(net->dev);
-- 
2.20.1



