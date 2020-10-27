Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E50229B45B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1782043AbgJ0PBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:01:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1781703AbgJ0PBH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:01:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F54520715;
        Tue, 27 Oct 2020 15:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810865;
        bh=b17DpFGqT6cMtVTdBRTSuTLuod89V9p/k6tpFioijtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXyxwKYliPg9KLSKTrK83AqWA4XXk+y4wlRAQ/x73vDzunZY7PK8VzowRrRr1Oo4/
         3yFOhAan/mHLK2/KvIzL9xevwP3f4lNXrPAlwk2D73iZMXMBaR2zX0RiBBTeiXbwPi
         TOjZHPu2WTgh2WiSmHnhi45cIweKb9t+7Zrwiwgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 291/633] net: enic: Cure the enic api locking trainwreck
Date:   Tue, 27 Oct 2020 14:50:34 +0100
Message-Id: <20201027135536.320440291@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit a53b59ece86c86d16d12ccdaa1ad0c78250a9d96 ]

enic_dev_wait() has a BUG_ON(in_interrupt()).

Chasing the callers of enic_dev_wait() revealed the gems of enic_reset()
and enic_tx_hang_reset() which are both invoked through work queues in
order to be able to call rtnl_lock(). So far so good.

After locking rtnl both functions acquire enic::enic_api_lock which
serializes against the (ab)use from infiniband. This is where the
trainwreck starts.

enic::enic_api_lock is a spin_lock() which implicitly disables preemption,
but both functions invoke a ton of functions under that lock which can
sleep. The BUG_ON(in_interrupt()) does not trigger in that case because it
can't detect the preempt disabled condition.

This clearly has never been tested with any of the mandatory debug options
for 7+ years, which would have caught that for sure.

Cure it by adding a enic_api_busy member to struct enic, which is modified
and evaluated with enic::enic_api_lock held.

If enic_api_devcmd_proxy_by_index() observes enic::enic_api_busy as true,
it drops enic::enic_api_lock and busy waits for enic::enic_api_busy to
become false.

It would be smarter to wait for a completion of that busy period, but
enic_api_devcmd_proxy_by_index() is called with other spin locks held which
obviously can't sleep.

Remove the BUG_ON(in_interrupt()) check as well because it's incomplete and
with proper debugging enabled the problem would have been caught from the
debug checks in schedule_timeout().

Fixes: 0b038566c0ea ("drivers/net: enic: Add an interface for USNIC to interact with firmware")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cisco/enic/enic.h      |  1 +
 drivers/net/ethernet/cisco/enic/enic_api.c  |  6 +++++
 drivers/net/ethernet/cisco/enic/enic_main.c | 27 ++++++++++++++++-----
 3 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic.h b/drivers/net/ethernet/cisco/enic/enic.h
index 18f3aeb88f22a..c67a16a48d624 100644
--- a/drivers/net/ethernet/cisco/enic/enic.h
+++ b/drivers/net/ethernet/cisco/enic/enic.h
@@ -169,6 +169,7 @@ struct enic {
 	u16 num_vfs;
 #endif
 	spinlock_t enic_api_lock;
+	bool enic_api_busy;
 	struct enic_port_profile *pp;
 
 	/* work queue cache line section */
diff --git a/drivers/net/ethernet/cisco/enic/enic_api.c b/drivers/net/ethernet/cisco/enic/enic_api.c
index b161f24522b87..b028ea2dec2b9 100644
--- a/drivers/net/ethernet/cisco/enic/enic_api.c
+++ b/drivers/net/ethernet/cisco/enic/enic_api.c
@@ -34,6 +34,12 @@ int enic_api_devcmd_proxy_by_index(struct net_device *netdev, int vf,
 	struct vnic_dev *vdev = enic->vdev;
 
 	spin_lock(&enic->enic_api_lock);
+	while (enic->enic_api_busy) {
+		spin_unlock(&enic->enic_api_lock);
+		cpu_relax();
+		spin_lock(&enic->enic_api_lock);
+	}
+
 	spin_lock_bh(&enic->devcmd_lock);
 
 	vnic_dev_cmd_proxy_by_index_start(vdev, vf);
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index cd5fe4f6b54ce..21093f33d2d73 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -2140,8 +2140,6 @@ static int enic_dev_wait(struct vnic_dev *vdev,
 	int done;
 	int err;
 
-	BUG_ON(in_interrupt());
-
 	err = start(vdev, arg);
 	if (err)
 		return err;
@@ -2329,6 +2327,13 @@ static int enic_set_rss_nic_cfg(struct enic *enic)
 		rss_hash_bits, rss_base_cpu, rss_enable);
 }
 
+static void enic_set_api_busy(struct enic *enic, bool busy)
+{
+	spin_lock(&enic->enic_api_lock);
+	enic->enic_api_busy = busy;
+	spin_unlock(&enic->enic_api_lock);
+}
+
 static void enic_reset(struct work_struct *work)
 {
 	struct enic *enic = container_of(work, struct enic, reset);
@@ -2338,7 +2343,9 @@ static void enic_reset(struct work_struct *work)
 
 	rtnl_lock();
 
-	spin_lock(&enic->enic_api_lock);
+	/* Stop any activity from infiniband */
+	enic_set_api_busy(enic, true);
+
 	enic_stop(enic->netdev);
 	enic_dev_soft_reset(enic);
 	enic_reset_addr_lists(enic);
@@ -2346,7 +2353,10 @@ static void enic_reset(struct work_struct *work)
 	enic_set_rss_nic_cfg(enic);
 	enic_dev_set_ig_vlan_rewrite_mode(enic);
 	enic_open(enic->netdev);
-	spin_unlock(&enic->enic_api_lock);
+
+	/* Allow infiniband to fiddle with the device again */
+	enic_set_api_busy(enic, false);
+
 	call_netdevice_notifiers(NETDEV_REBOOT, enic->netdev);
 
 	rtnl_unlock();
@@ -2358,7 +2368,9 @@ static void enic_tx_hang_reset(struct work_struct *work)
 
 	rtnl_lock();
 
-	spin_lock(&enic->enic_api_lock);
+	/* Stop any activity from infiniband */
+	enic_set_api_busy(enic, true);
+
 	enic_dev_hang_notify(enic);
 	enic_stop(enic->netdev);
 	enic_dev_hang_reset(enic);
@@ -2367,7 +2379,10 @@ static void enic_tx_hang_reset(struct work_struct *work)
 	enic_set_rss_nic_cfg(enic);
 	enic_dev_set_ig_vlan_rewrite_mode(enic);
 	enic_open(enic->netdev);
-	spin_unlock(&enic->enic_api_lock);
+
+	/* Allow infiniband to fiddle with the device again */
+	enic_set_api_busy(enic, false);
+
 	call_netdevice_notifiers(NETDEV_REBOOT, enic->netdev);
 
 	rtnl_unlock();
-- 
2.25.1



