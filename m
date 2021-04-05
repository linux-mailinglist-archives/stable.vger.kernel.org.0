Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF23353FAD
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239543AbhDEJNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:13:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239537AbhDEJNi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:13:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2BF460FE4;
        Mon,  5 Apr 2021 09:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614012;
        bh=ZLeGXEyXYb4QvPkjoyKLep8EeDJQ/JdGLGf/HuyhyIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WC+LGGFyOkAdJfvuqHps5eHAbvI4F8xWogxa8roZgjNexNSLyv6I1VMztMGaMacad
         p/SQfHbw1Wbie/Sfr40JSUQNeriRNvbrjofzkL5G7NTiO3TJSHv4v+gNYfzpfxF+YS
         9hdcRR5VlJmJ7PedzpwpCvr7CoSZhuCtOW3T27yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 051/152] net: bonding: fix error return code of bond_neigh_init()
Date:   Mon,  5 Apr 2021 10:53:20 +0200
Message-Id: <20210405085035.941084892@linuxfoundation.org>
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

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 2055a99da8a253a357bdfd359b3338ef3375a26c ]

When slave is NULL or slave_ops->ndo_neigh_setup is NULL, no error
return code of bond_neigh_init() is assigned.
To fix this bug, ret is assigned with -EINVAL in these cases.

Fixes: 9e99bfefdbce ("bonding: fix bond_neigh_init()")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 5fe5232cc3f3..fba6b6d1b430 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3917,11 +3917,15 @@ static int bond_neigh_init(struct neighbour *n)
 
 	rcu_read_lock();
 	slave = bond_first_slave_rcu(bond);
-	if (!slave)
+	if (!slave) {
+		ret = -EINVAL;
 		goto out;
+	}
 	slave_ops = slave->dev->netdev_ops;
-	if (!slave_ops->ndo_neigh_setup)
+	if (!slave_ops->ndo_neigh_setup) {
+		ret = -EINVAL;
 		goto out;
+	}
 
 	/* TODO: find another way [1] to implement this.
 	 * Passing a zeroed structure is fragile,
-- 
2.30.1



