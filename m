Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458D345BF26
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344054AbhKXMza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:55:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:56506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345982AbhKXMwk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:52:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6653561527;
        Wed, 24 Nov 2021 12:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757042;
        bh=7jsZVR4dqIyUhT42gN+YADJ1R/oC4molliGtyJIKMwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X5rRuczfuADR8GHv6TRM4CJztm9aW1lrMG7j+Wf+g9jlNKFisWMKxKv63wwhOJ6Vh
         UlB/XB0dF57Xsp1HdFc24aAQCMlLJloCW7y3BCYuySs8JIcjbA8T32m4W1xl8oV3yE
         MTiQ7xM3AhIrKAp0hBrvH/FLR18+ghm5F2F0mJKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongli Zhang <dongli.zhang@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 037/323] vmxnet3: do not stop tx queues after netif_device_detach()
Date:   Wed, 24 Nov 2021 12:53:47 +0100
Message-Id: <20211124115720.127676608@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
index e454dfc9ad8f2..c004819bebe35 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3634,7 +3634,6 @@ vmxnet3_suspend(struct device *device)
 	vmxnet3_free_intr_resources(adapter);
 
 	netif_device_detach(netdev);
-	netif_tx_stop_all_queues(netdev);
 
 	/* Create wake-up filters. */
 	pmConf = adapter->pm_conf;
-- 
2.33.0



