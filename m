Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802C43D5EEC
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236858AbhGZPPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:15:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237143AbhGZPKX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:10:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF33860525;
        Mon, 26 Jul 2021 15:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314652;
        bh=AVG/V3mE47Kbx4CCekMm8Z+YoAvRZy+Gk5vndcJj/SY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=arkJGd0FZ4TK9Xeay37j5UFDbByyThnsY73vfEs0U65oJnfMPxNd8W9xeK1ODE33L
         AD1cYUPK3vPY4IBSGitpjuRTz9h06nmq7C66PcxcX6r95vWZ7D5R7A28pKJhkG4Pq0
         RZfvtvjTucEguzwIYkheUxSM7sQ88i2jWl5iyJY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 044/120] net: ti: fix UAF in tlan_remove_one
Date:   Mon, 26 Jul 2021 17:38:16 +0200
Message-Id: <20210726153833.807597062@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
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
@@ -312,9 +312,8 @@ static void tlan_remove_one(struct pci_d
 	pci_release_regions(pdev);
 #endif
 
-	free_netdev(dev);
-
 	cancel_work_sync(&priv->tlan_tqueue);
+	free_netdev(dev);
 }
 
 static void tlan_start(struct net_device *dev)


