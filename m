Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24AA2F12DD
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbhAKNBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:01:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:48768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727324AbhAKNBU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:01:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D98492253A;
        Mon, 11 Jan 2021 13:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370016;
        bh=F4ZPefPJpbj2ZBdsZA7UoVUvMOexsWORvGNt+yHtzIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tbeZBM09m6rco/HfWaUvcsEYjjeeoOgR3m9MFbDvj5OYlqCcg2IT49AB3eE+h2Aiz
         lVkrDCsEtSFTo5idUmSgxR3mKMkQtZKYDaMnLcRuudP8TV0vqNQL2Ypy6jt4ra0Uvw
         TLRRcHPvzPXbBGCpI9Ku4V/14G35ie5Rb634CASc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 14/38] ethernet: ucc_geth: fix use-after-free in ucc_geth_remove()
Date:   Mon, 11 Jan 2021 14:00:46 +0100
Message-Id: <20210111130033.153153905@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130032.469630231@linuxfoundation.org>
References: <20210111130032.469630231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

[ Upstream commit e925e0cd2a705aaacb0b907bb3691fcac3a973a4 ]

ugeth is the netdiv_priv() part of the netdevice. Accessing the memory
pointed to by ugeth (such as done by ucc_geth_memclean() and the two
of_node_puts) after free_netdev() is thus use-after-free.

Fixes: 80a9fad8e89a ("ucc_geth: fix module removal")
Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/ucc_geth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3934,10 +3934,10 @@ static int ucc_geth_remove(struct platfo
 	struct ucc_geth_private *ugeth = netdev_priv(dev);
 
 	unregister_netdev(dev);
-	free_netdev(dev);
 	ucc_geth_memclean(ugeth);
 	of_node_put(ugeth->ug_info->tbi_node);
 	of_node_put(ugeth->ug_info->phy_node);
+	free_netdev(dev);
 
 	return 0;
 }


