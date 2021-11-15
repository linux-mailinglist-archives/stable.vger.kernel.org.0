Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7603A450EAC
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241072AbhKOSSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:18:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:55786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240733AbhKOSNL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:13:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C7F6633C7;
        Mon, 15 Nov 2021 17:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998495;
        bh=F/MQ9D9uhSUZ5zk9Jd9AOnxbfTcNP8ZSpt7zQa+CjTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgYC8+hR9IgY8RUvN9RCvC07ynIHjbAtYvL3eeF/dgOhzVe4ybsnRWflgpZVdMxhV
         sNozEwp4y8YIuWXvTluT3w+UOpr5kfR2AXQjuNztaAk8CONFZkGeEQt12W969L9/R+
         epl3VNQ4EwbEmEggKGOKL29AVCbMMZI5CevIr6CU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 529/575] gve: Fix off by one in gve_tx_timeout()
Date:   Mon, 15 Nov 2021 18:04:14 +0100
Message-Id: <20211115165401.966803513@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 3e96b2a11c5bf..6cb75bb1ed052 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -959,7 +959,7 @@ static void gve_tx_timeout(struct net_device *dev, unsigned int txqueue)
 		goto reset;
 
 	ntfy_idx = gve_tx_idx_to_ntfy(priv, txqueue);
-	if (ntfy_idx > priv->num_ntfy_blks)
+	if (ntfy_idx >= priv->num_ntfy_blks)
 		goto reset;
 
 	block = &priv->ntfy_blocks[ntfy_idx];
-- 
2.33.0



