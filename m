Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D331D35408F
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240051AbhDEJSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:18:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240302AbhDEJSa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:18:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D0B66139D;
        Mon,  5 Apr 2021 09:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614305;
        bh=c+9aEKqtqi31QaPif7cyEo1vZEM8PFyRjLMX5ByhUYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1gslraPW1/m88EvUIStv8b0KZ7aIi5B76tX1MlTfCC5IN275Ds0vcsHE1zWM1CBkL
         aWYJ4pImbEzr7gFhV7pGH3qILRbTSQ5FGbiQew5BgNZPK3ncwddkQb88xZXErvYnvi
         +yye+sImUbcR/dZzZAeoSQJVcQEdyPVjymHi+Oto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 152/152] Revert "net: bonding: fix error return code of bond_neigh_init()"
Date:   Mon,  5 Apr 2021 10:55:01 +0200
Message-Id: <20210405085039.147625478@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David S. Miller <davem@davemloft.net>

commit 080bfa1e6d928a5d1f185cc44e5f3c251df06df5 upstream.

This reverts commit 2055a99da8a253a357bdfd359b3338ef3375a26c.

This change rejects legitimate configurations.

A slave doesn't need to exist nor implement ndo_slave_setup.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3917,15 +3917,11 @@ static int bond_neigh_init(struct neighb
 
 	rcu_read_lock();
 	slave = bond_first_slave_rcu(bond);
-	if (!slave) {
-		ret = -EINVAL;
+	if (!slave)
 		goto out;
-	}
 	slave_ops = slave->dev->netdev_ops;
-	if (!slave_ops->ndo_neigh_setup) {
-		ret = -EINVAL;
+	if (!slave_ops->ndo_neigh_setup)
 		goto out;
-	}
 
 	/* TODO: find another way [1] to implement this.
 	 * Passing a zeroed structure is fragile,


