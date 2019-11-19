Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30D91101879
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbfKSFbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:31:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:51504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727173AbfKSFbu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:31:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B04AA21939;
        Tue, 19 Nov 2019 05:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141510;
        bh=IEDcQfMvzR+IzJeitdKQq+ocOapyJqcmGHUCSGPIY50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWsaYH0mGPmi6A2AsVjRR0fH8xYRZCP61J+pWRzd7zlZZHbb4dfKZLmQeq3NNM7kX
         QhqPEJbMsL2aD1NAsXgsrKX1HvU/3P23aU0a0AKEelmQFi9MwmvziIz6JKGC1nvRlR
         hFJv5a5/hdu/y710kM8/pD9zOpUTO3boPqJylvVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 145/422] failover: Fix error return code in net_failover_create
Date:   Tue, 19 Nov 2019 06:15:42 +0100
Message-Id: <20191119051408.102485521@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 09317da317e55e70ccbe23f65008348a4a1b7c7f ]

if failover_register failed, 'err' code should be set correctly

Fixes: cfc80d9a1163 ("net: Introduce net_failover driver")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/net_failover.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 5a749dc25bec4..beeb7eb76ca32 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -765,8 +765,10 @@ struct failover *net_failover_create(struct net_device *standby_dev)
 	netif_carrier_off(failover_dev);
 
 	failover = failover_register(failover_dev, &net_failover_ops);
-	if (IS_ERR(failover))
+	if (IS_ERR(failover)) {
+		err = PTR_ERR(failover);
 		goto err_failover_register;
+	}
 
 	return failover;
 
-- 
2.20.1



