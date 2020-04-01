Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4EE919B3CE
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388288AbgDAQbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:31:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388284AbgDAQbO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:31:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D7B02063A;
        Wed,  1 Apr 2020 16:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758673;
        bh=iQ3XSb+1+W70hL2bq3JLGymvdhOzpDA6tBAKKyNBbk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGHOg6CXVBFjbLjLqzGmP/CTPgu9YRHQSr+fV4mhC6javsGZX4ml3fcsM/fd6mBiI
         D+yZVELrX6B4DEppzy4oI2w5FvIaeENr0WJyqJy9MDspJR5WnKHUON/eS0Rjk4va6p
         7GmBIZFlkDoqNmTTQpYLurNt4wkHNwhcRWgRLHKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 40/91] vxlan: check return value of gro_cells_init()
Date:   Wed,  1 Apr 2020 18:17:36 +0200
Message-Id: <20200401161527.519383441@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161512.917494101@linuxfoundation.org>
References: <20200401161512.917494101@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 384d91c267e621e0926062cfb3f20cb72dc16928 ]

gro_cells_init() returns error if memory allocation is failed.
But the vxlan module doesn't check the return value of gro_cells_init().

Fixes: 58ce31cca1ff ("vxlan: GRO support at tunnel layer")`
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2303,10 +2303,19 @@ static void vxlan_vs_add_dev(struct vxla
 /* Setup stats when device is created */
 static int vxlan_init(struct net_device *dev)
 {
+	struct vxlan_dev *vxlan = netdev_priv(dev);
+	int err;
+
 	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
 	if (!dev->tstats)
 		return -ENOMEM;
 
+	err = gro_cells_init(&vxlan->gro_cells, dev);
+	if (err) {
+		free_percpu(dev->tstats);
+		return err;
+	}
+
 	return 0;
 }
 
@@ -2584,8 +2593,6 @@ static void vxlan_setup(struct net_devic
 
 	vxlan->dev = dev;
 
-	gro_cells_init(&vxlan->gro_cells, dev);
-
 	for (h = 0; h < FDB_HASH_SIZE; ++h)
 		INIT_HLIST_HEAD(&vxlan->fdb_head[h]);
 }


