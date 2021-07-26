Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD8D3D5D40
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235241AbhGZPAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235236AbhGZPAS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:00:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 498D860E08;
        Mon, 26 Jul 2021 15:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314046;
        bh=mp11EiE24wDcNafm9JEypj8lxrQqDu93h6rWFarLp/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0qkx7ieTYfGBfk8PqIuFEx8ExJ+dhXqMdJG9C5kTLj10Wqonu/5e2GKKic0xkdkj8
         +bdzvJwEInXgvkKqybL9IBk4xeIDYgE/L1UTdKENjHzv+YVoZIeI0SDqVXrj3BqI3Q
         H5UWVi3s616qnP62PQgqzg/J+UbPp37Idwfm2WU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 14/47] net: ti: fix UAF in tlan_remove_one
Date:   Mon, 26 Jul 2021 17:38:32 +0200
Message-Id: <20210726153823.430732332@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153822.980271128@linuxfoundation.org>
References: <20210726153822.980271128@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit 0336f8ffece62f882ab3012820965a786a983f70 upstream.

priv is netdev private data and it cannot be
used after free_netdev() call. Using priv after free_netdev()
can cause UAF bug. Fix it by moving free_netdev() at the end of the
function.

Fixes: 1e0a8b13d355 ("tlan: cancel work at remove path")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/tlan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -313,9 +313,8 @@ static void tlan_remove_one(struct pci_d
 	pci_release_regions(pdev);
 #endif
 
-	free_netdev(dev);
-
 	cancel_work_sync(&priv->tlan_tqueue);
+	free_netdev(dev);
 }
 
 static void tlan_start(struct net_device *dev)


