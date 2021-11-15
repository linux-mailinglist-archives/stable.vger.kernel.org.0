Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCCC8451E5F
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347120AbhKPAfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344836AbhKOTZf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCFE763236;
        Mon, 15 Nov 2021 19:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003118;
        bh=fks25m95ylT9sOoOxCGCDkMxg9akX8lyYSWHnRHlSo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cF155DSNkxP7Q4FK9YhsyRHoL6HEBxz/bACCKDvreGHxSXpbr+O9NIl3D1X/hNBZl
         XIZvGZV7NyLLU6ejJRplxFr9m06ICZY/ZyBJcCRb47xTnsRBmtbHmotwD8bzKXU7Z7
         Fpfrl5CJAgjNxr9mvT0Y9CXF1ejfBW03uLGTQdHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 818/917] litex_liteeth: Fix a double free in the remove function
Date:   Mon, 15 Nov 2021 18:05:13 +0100
Message-Id: <20211115165456.777049477@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit c45231a7668d6b632534f692b10592ea375b55b0 ]

'netdev' is a managed resource allocated in the probe using
'devm_alloc_etherdev()'.
It must not be freed explicitly in the remove function.

Fixes: ee7da21ac4c3 ("net: Add driver for LiteX's LiteETH network interface")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/litex/litex_liteeth.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/litex/litex_liteeth.c b/drivers/net/ethernet/litex/litex_liteeth.c
index a9bdbf0dcfe1e..5bb1cc8a2ce13 100644
--- a/drivers/net/ethernet/litex/litex_liteeth.c
+++ b/drivers/net/ethernet/litex/litex_liteeth.c
@@ -289,7 +289,6 @@ static int liteeth_remove(struct platform_device *pdev)
 	struct net_device *netdev = platform_get_drvdata(pdev);
 
 	unregister_netdev(netdev);
-	free_netdev(netdev);
 
 	return 0;
 }
-- 
2.33.0



