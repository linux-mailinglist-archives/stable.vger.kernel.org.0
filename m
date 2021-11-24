Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA5345B9E2
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242050AbhKXMF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:05:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:60634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231804AbhKXMFP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:05:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE50C60FDC;
        Wed, 24 Nov 2021 12:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755326;
        bh=Ux977aZDcceaHlG4S58qwU3/Ah+HIIB7MtGZ05ZiaT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x5LEOImh1Cz/K3arXwWa8M/eRv4WqdM94Xbi0d5LmDE9NEaFE03w54q0fGmqVFJ84
         ZqYkq3s66pAI+TF/G6ncAdszevHii9vD+dN/hN7KsmARKc4kf1RRHOtYUeCDcYJC0B
         SdeqkKAHDX3S5Ison4joWmhC/sHHOFn8ln/JoRQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongli Zhang <dongli.zhang@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 022/162] vmxnet3: do not stop tx queues after netif_device_detach()
Date:   Wed, 24 Nov 2021 12:55:25 +0100
Message-Id: <20211124115659.049897130@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
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
index 419c045d07527..474ee7e723d00 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3389,7 +3389,6 @@ vmxnet3_suspend(struct device *device)
 	vmxnet3_free_intr_resources(adapter);
 
 	netif_device_detach(netdev);
-	netif_tx_stop_all_queues(netdev);
 
 	/* Create wake-up filters. */
 	pmConf = adapter->pm_conf;
-- 
2.33.0



