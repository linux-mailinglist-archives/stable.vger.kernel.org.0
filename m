Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A2A3FDAAD
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245050AbhIAMd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:33:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244894AbhIAMcZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:32:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3571C610CB;
        Wed,  1 Sep 2021 12:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499488;
        bh=y0MmNWgRX5chVEjGuxM4JFyJqnnnRcqhozuIp+eYBb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2rn6SGvT6mDXOwHnZyvXH7dOjBTVi/3C3V2z8TZOgCYfVY24krcQTT34fqfbGzp5j
         n8EXfwpfZZST6QNLw7rP5oGKYv6WGpL6C3mTYBPP7EvbHCEu6JkbXAetkBPGudUqDq
         5owhndyzuNRt5CXyKsUjiIkBg0XREPEVM6YYvrkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 19/48] xgene-v2: Fix a resource leak in the error handling path of xge_probe()
Date:   Wed,  1 Sep 2021 14:28:09 +0200
Message-Id: <20210901122254.031128609@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122253.388326997@linuxfoundation.org>
References: <20210901122253.388326997@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 5ed74b03eb4d08f5dd281dcb5f1c9bb92b363a8d ]

A successful 'xge_mdio_config()' call should be balanced by a corresponding
'xge_mdio_remove()' call in the error handling path of the probe, as
already done in the remove function.

Update the error handling path accordingly.

Fixes: ea8ab16ab225 ("drivers: net: xgene-v2: Add MDIO support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/apm/xgene-v2/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ethernet/apm/xgene-v2/main.c
index 02b4f3af02b5..848be6bf2fd1 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.c
+++ b/drivers/net/ethernet/apm/xgene-v2/main.c
@@ -677,11 +677,13 @@ static int xge_probe(struct platform_device *pdev)
 	ret = register_netdev(ndev);
 	if (ret) {
 		netdev_err(ndev, "Failed to register netdev\n");
-		goto err;
+		goto err_mdio_remove;
 	}
 
 	return 0;
 
+err_mdio_remove:
+	xge_mdio_remove(ndev);
 err:
 	free_netdev(ndev);
 
-- 
2.30.2



