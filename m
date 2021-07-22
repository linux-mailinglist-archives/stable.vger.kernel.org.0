Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4753D2807
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbhGVPyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:54:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231178AbhGVPyS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:54:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63DDA6135B;
        Thu, 22 Jul 2021 16:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971692;
        bh=paX9NK/DXwa2lWVXcA7FKr1ZkYnCNuqvXkpNU9MumzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lfjof81MsNc+FwSx95f1D5OFAAMiwWROXVygUQZUdAZy1BhVb92QQfjwtZ4e1vtok
         I3dc57p73YV46ZRq84i29q+Dywfsb1eTrTCygivg/jeXuoxnWGxKlYwHw0vCuaUpOj
         tlZWSU6MJ7X5RPf71hhMcF4O8G++UmIWK8MfRPmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 62/71] net: ti: fix UAF in tlan_remove_one
Date:   Thu, 22 Jul 2021 18:31:37 +0200
Message-Id: <20210722155619.969787707@linuxfoundation.org>
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
@@ -314,9 +314,8 @@ static void tlan_remove_one(struct pci_d
 	pci_release_regions(pdev);
 #endif
 
-	free_netdev(dev);
-
 	cancel_work_sync(&priv->tlan_tqueue);
+	free_netdev(dev);
 }
 
 static void tlan_start(struct net_device *dev)


