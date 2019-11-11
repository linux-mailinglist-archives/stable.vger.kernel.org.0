Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB5D6F7E6F
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729749AbfKKSot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:44:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:36598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728627AbfKKSot (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:44:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AADF20674;
        Mon, 11 Nov 2019 18:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497888;
        bh=XXU3KuVpPqvwxj/p7e1akCU0d/Vt4OZCokodGA0grYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nppqzqb67HjYHrVchW+x3dCyjXMfhFkhhtzfy/PLRSMXw1rOH+mQN5Jb9Kbo3st+f
         uA1GkB0HFIIubMZKwy0hANPuzhX5n307LAVc7SL3N7d0W77ubo2tOvGQGvOipAUY93
         pxQGhOFFJ5x55V1729uMObSTTGB+No3i0ii9VwDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 088/125] macsec: fix refcnt leak in module exit routine
Date:   Mon, 11 Nov 2019 19:28:47 +0100
Message-Id: <20191111181451.823737572@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 2bce1ebed17da54c65042ec2b962e3234bad5b47 ]

When a macsec interface is created, it increases a refcnt to a lower
device(real device). when macsec interface is deleted, the refcnt is
decreased in macsec_free_netdev(), which is ->priv_destructor() of
macsec interface.

The problem scenario is this.
When nested macsec interfaces are exiting, the exit routine of the
macsec module makes refcnt leaks.

Test commands:
    ip link add dummy0 type dummy
    ip link add macsec0 link dummy0 type macsec
    ip link add macsec1 link macsec0 type macsec
    modprobe -rv macsec

[  208.629433] unregister_netdevice: waiting for macsec0 to become free. Usage count = 1

Steps of exit routine of macsec module are below.
1. Calls ->dellink() in __rtnl_link_unregister().
2. Checks refcnt and wait refcnt to be 0 if refcnt is not 0 in
netdev_run_todo().
3. Calls ->priv_destruvtor() in netdev_run_todo().

Step2 checks refcnt, but step3 decreases refcnt.
So, step2 waits forever.

This patch makes the macsec module do not hold a refcnt of the lower
device because it already holds a refcnt of the lower device with
netdev_upper_dev_link().

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 0dc92d2faa64d..05115fb0c97a9 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3008,12 +3008,10 @@ static const struct nla_policy macsec_rtnl_policy[IFLA_MACSEC_MAX + 1] = {
 static void macsec_free_netdev(struct net_device *dev)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
-	struct net_device *real_dev = macsec->real_dev;
 
 	free_percpu(macsec->stats);
 	free_percpu(macsec->secy.tx_sc.stats);
 
-	dev_put(real_dev);
 }
 
 static void macsec_setup(struct net_device *dev)
@@ -3268,8 +3266,6 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 	if (err < 0)
 		return err;
 
-	dev_hold(real_dev);
-
 	macsec->nest_level = dev_get_nest_level(real_dev) + 1;
 	netdev_lockdep_set_classes(dev);
 	lockdep_set_class_and_subclass(&dev->addr_list_lock,
-- 
2.20.1



