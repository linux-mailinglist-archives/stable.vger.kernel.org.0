Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B26450F1F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240807AbhKOS04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:26:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:36900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241271AbhKOSYu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:24:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B578632BF;
        Mon, 15 Nov 2021 17:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998874;
        bh=QgycHk3TCnPaorplJPvu6rXIIvLJz5bXL2u74JNpPZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=secoBp6YMKRSzU0jIRJ9eOY+4tyPj3NLFlpFvp6/SbIW0HNXJ7ctFHJndAAHfAono
         bBJ+lrbgIkBo9g0D5psiTKMq5l5muGpJnJu6bI2/Fo5PF0Wk/isDTWO4snuOvEjeAn
         Mr5jGFik1guWv66x6n4zkMwgYczwHLEcwgFeYjMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongli Zhang <dongli.zhang@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 093/849] vmxnet3: do not stop tx queues after netif_device_detach()
Date:   Mon, 15 Nov 2021 17:52:56 +0100
Message-Id: <20211115165423.234582149@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 6e87f1fc4874a..ceecee4081384 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3749,7 +3749,6 @@ vmxnet3_suspend(struct device *device)
 	vmxnet3_free_intr_resources(adapter);
 
 	netif_device_detach(netdev);
-	netif_tx_stop_all_queues(netdev);
 
 	/* Create wake-up filters. */
 	pmConf = adapter->pm_conf;
-- 
2.33.0



