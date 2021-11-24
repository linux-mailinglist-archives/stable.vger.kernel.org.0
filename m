Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723B945BB23
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242322AbhKXMQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:16:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:49278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243671AbhKXMOx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:14:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7286861181;
        Wed, 24 Nov 2021 12:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755791;
        bh=KX+snrz288PpaC4aF8zeFUyd1faTVLRzfvV3PRrB66M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mkZ904V2Layxbh1ZnqI+DfeVuOiQ7UqggXxpnShw8zbpZY5t6KGJyqX4J4xEguynW
         xmmgTV6Fg1a3IVfMA3Pnv8xj8DASeCur7tzn948hWkIrj0PDFg5ZZ5N7zzl+lEDR3v
         wAehJJevgM5OCiR3VVjXKVNhjRiwI7L4BvWEYP0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongli Zhang <dongli.zhang@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 026/207] vmxnet3: do not stop tx queues after netif_device_detach()
Date:   Wed, 24 Nov 2021 12:54:57 +0100
Message-Id: <20211124115704.804872238@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongli Zhang <dongli.zhang@oracle.com>

[ Upstream commit 9159f102402a64ac85e676b75cc1f9c62c5b4b73 ]

The netif_device_detach() conditionally stops all tx queues if the queues
are running. There is no need to call netif_tx_stop_all_queues() again.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index c999b10531c59..56a8031b56b37 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3622,7 +3622,6 @@ vmxnet3_suspend(struct device *device)
 	vmxnet3_free_intr_resources(adapter);
 
 	netif_device_detach(netdev);
-	netif_tx_stop_all_queues(netdev);
 
 	/* Create wake-up filters. */
 	pmConf = adapter->pm_conf;
-- 
2.33.0



