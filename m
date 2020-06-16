Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29781FBB5F
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbgFPPgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:36:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729609AbgFPPgO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:36:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F41A20B1F;
        Tue, 16 Jun 2020 15:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321774;
        bh=R8b4aXiaDVa9gpxOJ77HU6fmfPrXxPzH9NZlAi6jZ1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yXtUE/YkEvXaPhsPBPPFE2Wg2bz/6iKf00m9eT2VzPpONUZHng84KJGfTSYQTqGb6
         VNmAQMjZlXL9iplVA9hB/iYlpw4dsrnSqPJDWON6aNIw2J8aAurN3EAJHX223UU8k3
         oLbbZv9nfGun6HQxSTG2f23dtp2buA2WsrDYDjfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 003/134] net_failover: fixed rollback in net_failover_open()
Date:   Tue, 16 Jun 2020 17:33:07 +0200
Message-Id: <20200616153100.815427638@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit e8224bfe77293494626f6eec1884fee7b87d0ced ]

found by smatch:
drivers/net/net_failover.c:65 net_failover_open() error:
 we previously assumed 'primary_dev' could be null (see line 43)

Fixes: cfc80d9a1163 ("net: Introduce net_failover driver")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/net_failover.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -61,7 +61,8 @@ static int net_failover_open(struct net_
 	return 0;
 
 err_standby_open:
-	dev_close(primary_dev);
+	if (primary_dev)
+		dev_close(primary_dev);
 err_primary_open:
 	netif_tx_disable(dev);
 	return err;


