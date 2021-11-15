Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA72451296
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346939AbhKOThy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:37:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244905AbhKOTSL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C9E663331;
        Mon, 15 Nov 2021 18:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000728;
        bh=GdLprI4WU8Ew+RSklB+cf5vA1BQe4CmMAA4yj7FDGvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zST5W1Dqkv4Frk1Uf3VMG3WwxbpQHbYsRj9Y2QqmirHiPKTKnqLmUJTzJbiO141ba
         IZB1hZrrjgPrsNkaP2F7XzL0p74Jqn8uq9oNd+jSJrwGRriKM3/m4SXhsFuKggjfDf
         GgC09LGHZZeEvYxBRjKNDiFGstAKAA08jhLsjFP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 769/849] gve: Fix off by one in gve_tx_timeout()
Date:   Mon, 15 Nov 2021 18:04:12 +0100
Message-Id: <20211115165446.269650213@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 1c360cc1cc883fbdf0a258b4df376571fbeac5ee ]

The priv->ntfy_blocks[] has "priv->num_ntfy_blks" elements so this >
needs to be >= to prevent an off by one bug.  The priv->ntfy_blocks[]
array is allocated in gve_alloc_notify_blocks().

Fixes: 87a7f321bb6a ("gve: Recover from queue stall due to missed IRQ")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 8c996e72748d2..959352fceead7 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1132,7 +1132,7 @@ static void gve_tx_timeout(struct net_device *dev, unsigned int txqueue)
 		goto reset;
 
 	ntfy_idx = gve_tx_idx_to_ntfy(priv, txqueue);
-	if (ntfy_idx > priv->num_ntfy_blks)
+	if (ntfy_idx >= priv->num_ntfy_blks)
 		goto reset;
 
 	block = &priv->ntfy_blocks[ntfy_idx];
-- 
2.33.0



