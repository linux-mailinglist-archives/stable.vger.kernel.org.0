Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08AB2F1767
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730111AbhAKOFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 09:05:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:50872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730086AbhAKNEA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:04:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DD1E22BEF;
        Mon, 11 Jan 2021 13:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370189;
        bh=pvktK5twh1eD4hu/UnoolytctEESt00y1DIetfJD+fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ADxl226iDAykrKg0Qdh/lpVx9NET5lGgq8fFUyKN5dh3nn7pX213DbOPF0wQhYB4d
         IBWVwFPe7bMN2SPHKQmGUlK1udOtC0a5HUMLgKP1zTJzWslNjtZwza+97ADcKli8Xs
         JbblHjgwuwiFfFY454qtIDwgsLrK6TsO6m29n1jM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 05/45] ethernet: ucc_geth: fix use-after-free in ucc_geth_remove()
Date:   Mon, 11 Jan 2021 14:00:43 +0100
Message-Id: <20210111130033.943663385@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.676306636@linuxfoundation.org>
References: <20210111130033.676306636@linuxfoundation.org>
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
@@ -3939,12 +3939,12 @@ static int ucc_geth_remove(struct platfo
 	struct device_node *np = ofdev->dev.of_node;
 
 	unregister_netdev(dev);
-	free_netdev(dev);
 	ucc_geth_memclean(ugeth);
 	if (of_phy_is_fixed_link(np))
 		of_phy_deregister_fixed_link(np);
 	of_node_put(ugeth->ug_info->tbi_node);
 	of_node_put(ugeth->ug_info->phy_node);
+	free_netdev(dev);
 
 	return 0;
 }


