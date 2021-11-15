Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC51451E62
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345195AbhKPAfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:45404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344863AbhKOTZh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FE30633E2;
        Mon, 15 Nov 2021 19:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003145;
        bh=GdLprI4WU8Ew+RSklB+cf5vA1BQe4CmMAA4yj7FDGvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jIQrp29XaerTpT3QaoyKPPbKO/NY9du4HzjV1R1R2oFYbVX7TeV2z80Vyaf5A91Zw
         /kPuZFdlca93+ov/pocFF+8nBLjpqszaJjaE7izEsKzanBTcNt0O5odFd528gaAdmC
         daNgcfVA/3UCgq6+RbdRLEhPNm8Cf74IwqO7MYsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 827/917] gve: Fix off by one in gve_tx_timeout()
Date:   Mon, 15 Nov 2021 18:05:22 +0100
Message-Id: <20211115165457.096442417@linuxfoundation.org>
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



