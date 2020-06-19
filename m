Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAAD3200D27
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389770AbgFSOxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:53:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389767AbgFSOxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:53:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF96E21556;
        Fri, 19 Jun 2020 14:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578429;
        bh=Q5lsYS7fZAa4bA6lReP4Ek3N3GMs/7klMA+r8Ds98CU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wRO7bFb6BJ6s2TtF7fwuIw55mOV7LM+JIPYuVWGo/wBufkvulxtdYXgnKFlpoinry
         kr5AHiL6YM5jb6Rkw1//Vgljzss0ECQ3yOf6CEotRidVWwWarl0GG33lpQoEF1zEib
         RFmI+mqNFmocnMHYJRuIwu4uFIcK24epKmsNKD0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 002/267] net_failover: fixed rollback in net_failover_open()
Date:   Fri, 19 Jun 2020 16:29:47 +0200
Message-Id: <20200619141648.970529459@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
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
@@ -62,7 +62,8 @@ static int net_failover_open(struct net_
 	return 0;
 
 err_standby_open:
-	dev_close(primary_dev);
+	if (primary_dev)
+		dev_close(primary_dev);
 err_primary_open:
 	netif_tx_disable(dev);
 	return err;


