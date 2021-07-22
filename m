Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBDE3D2802
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbhGVPyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:54:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230117AbhGVPyN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:54:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B44FF6135C;
        Thu, 22 Jul 2021 16:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971688;
        bh=9svYroCqAikHkSj5CurQmI+qXmdbpMc+DVjWlYvkW8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i+oS6lawuXze+9zPXz3I2svRJRfdTKe7vHCLorvtSpVxMGlZ8pb06fe+X4DGPqr9R
         JAZVg7R5nMu4wMdw/mlRDi8qLizg+FbVMUihxjSFZP+VkXxeri+PA1HbgHhI607T8i
         44aNn96+ptYRyurqysNzLq7MD/yoLGhNk8SGx3+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 60/71] net: moxa: fix UAF in moxart_mac_probe
Date:   Thu, 22 Jul 2021 18:31:35 +0200
Message-Id: <20210722155619.900579293@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
References: <20210722155617.865866034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit c78eaeebe855fd93f2e77142ffd0404a54070d84 upstream.

In case of netdev registration failure the code path will
jump to init_fail label:

init_fail:
	netdev_err(ndev, "init failed\n");
	moxart_mac_free_memory(ndev);
irq_map_fail:
	free_netdev(ndev);
	return ret;

So, there is no need to call free_netdev() before jumping
to error handling path, since it can cause UAF or double-free
bug.

Fixes: 6c821bd9edc9 ("net: Add MOXA ART SoCs ethernet driver")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/moxa/moxart_ether.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -545,10 +545,8 @@ static int moxart_mac_probe(struct platf
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 
 	ret = register_netdev(ndev);
-	if (ret) {
-		free_netdev(ndev);
+	if (ret)
 		goto init_fail;
-	}
 
 	netdev_dbg(ndev, "%s: IRQ=%d address=%pM\n",
 		   __func__, ndev->irq, ndev->dev_addr);


