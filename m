Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D992F1520
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbhAKNfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:35:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:60704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732050AbhAKNOD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:14:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FF7C22C97;
        Mon, 11 Jan 2021 13:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370827;
        bh=MiBOZlWZn8eKkAm3U62IIxQjb+mzZx8J80PCGwQh/gQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h60fNKUOclYO0HPDxrht7k90rSAXwr4fFFMdthbf+e4XvdsPC3bJRucp6cmgCeEIb
         nk3MHxqUFuMNnoIt6QKdCbMtBktLowuZvuHVwb2Yvhz6E2bFO84V5q+tHylFszK4p/
         0xc3UQ0h+XAI9b3EfafnXagtonjG6i5pVvuh6Jqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 021/145] net-sysfs: take the rtnl lock when storing xps_cpus
Date:   Mon, 11 Jan 2021 14:00:45 +0100
Message-Id: <20210111130049.526976461@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 1ad58225dba3f2f598d2c6daed4323f24547168f ]

Two race conditions can be triggered when storing xps cpus, resulting in
various oops and invalid memory accesses:

1. Calling netdev_set_num_tc while netif_set_xps_queue:

   - netif_set_xps_queue uses dev->tc_num as one of the parameters to
     compute the size of new_dev_maps when allocating it. dev->tc_num is
     also used to access the map, and the compiler may generate code to
     retrieve this field multiple times in the function.

   - netdev_set_num_tc sets dev->tc_num.

   If new_dev_maps is allocated using dev->tc_num and then dev->tc_num
   is set to a higher value through netdev_set_num_tc, later accesses to
   new_dev_maps in netif_set_xps_queue could lead to accessing memory
   outside of new_dev_maps; triggering an oops.

2. Calling netif_set_xps_queue while netdev_set_num_tc is running:

   2.1. netdev_set_num_tc starts by resetting the xps queues,
        dev->tc_num isn't updated yet.

   2.2. netif_set_xps_queue is called, setting up the map with the
        *old* dev->num_tc.

   2.3. netdev_set_num_tc updates dev->tc_num.

   2.4. Later accesses to the map lead to out of bound accesses and
        oops.

   A similar issue can be found with netdev_reset_tc.

One way of triggering this is to set an iface up (for which the driver
uses netdev_set_num_tc in the open path, such as bnx2x) and writing to
xps_cpus in a concurrent thread. With the right timing an oops is
triggered.

Both issues have the same fix: netif_set_xps_queue, netdev_set_num_tc
and netdev_reset_tc should be mutually exclusive. We do that by taking
the rtnl lock in xps_cpus_store.

Fixes: 184c449f91fe ("net: Add support for XPS with QoS via traffic classes")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/net-sysfs.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1396,7 +1396,13 @@ static ssize_t xps_cpus_store(struct net
 		return err;
 	}
 
+	if (!rtnl_trylock()) {
+		free_cpumask_var(mask);
+		return restart_syscall();
+	}
+
 	err = netif_set_xps_queue(dev, mask, index);
+	rtnl_unlock();
 
 	free_cpumask_var(mask);
 


