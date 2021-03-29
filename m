Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4AC34C96B
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233675AbhC2I3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:29:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234058AbhC2I1m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:27:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFEB961959;
        Mon, 29 Mar 2021 08:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006397;
        bh=mn59pqmpapYyvMvd3w6aPOstX0re7g6q5OevhBUXP68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uWNNEd/OP0oBULtw2ZSwgF4vZ21uCIEuhTEq8m3brVNDUFnhu+tc0yll5h+WeHZY8
         qPrlJL/LLu+2FlD8WGdo5W8ny1eTZHKxpsDAzUfSCKM4uc30dGWvOH8LVarWXsFykr
         r6rvOCtvFhoieTgaS+B3LjRJgBRz8VfSXqnhLOH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 219/221] Revert "net: bonding: fix error return code of bond_neigh_init()"
Date:   Mon, 29 Mar 2021 09:59:10 +0200
Message-Id: <20210329075636.444052945@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
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
@@ -3918,15 +3918,11 @@ static int bond_neigh_init(struct neighb
 
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


