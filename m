Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169173FDC26
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344036AbhIAMrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:47:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345869AbhIAMpI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:45:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33A7661159;
        Wed,  1 Sep 2021 12:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499959;
        bh=GSrMGi3p2ZVGJglgw3oyssmrlkN+AUsMS7KZAjFK5ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X7uTQZCoWJuYROW1EaxOlqIBB7h0oPTLpa0zgbMAfaIuv4ZglU43SipQmnPuGvxWv
         cHsPQaAzU0Ks2bh00VCcq7IV1UpzBxGjf0wVuQbqHvOgloA9oxWHl9X8gm6gFzhxqk
         uh91vk/rUG/VDhE2FE8uh+z6rD4jls7kDpcQlioY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 049/113] xgene-v2: Fix a resource leak in the error handling path of xge_probe()
Date:   Wed,  1 Sep 2021 14:28:04 +0200
Message-Id: <20210901122303.610040575@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
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
index 860c18fb7aae..80399c8980bd 100644
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



