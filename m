Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337D34523FF
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243038AbhKPBfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:35:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:42462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242069AbhKOSgo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:36:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACC3E6324A;
        Mon, 15 Nov 2021 18:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999352;
        bh=D6135yZNhnbtuV52ruDB2qSvcFalQAVynZGw/c955oU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R8OMCbavT0/dHojpQjcGBitIAz5Bnl3ChS6YXKbn9ToBYalI6DYBd48jFJKbbk9Vd
         VLHX2i903WSEbjG/3/6jyAoI8kbyFQzOoZhSPrKdow2vtwE1wful4sjyqW9swgjxt9
         qgSDNRK6bGYhRlb7l49xip+R19P+KJB4DWxL8wMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 266/849] net-sysfs: try not to restart the syscall if it will fail eventually
Date:   Mon, 15 Nov 2021 17:55:49 +0100
Message-Id: <20211115165429.252607313@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 146e5e733310379f51924111068f08a3af0db830 ]

Due to deadlocks in the networking subsystem spotted 12 years ago[1],
a workaround was put in place[2] to avoid taking the rtnl lock when it
was not available and restarting the syscall (back to VFS, letting
userspace spin). The following construction is found a lot in the net
sysfs and sysctl code:

  if (!rtnl_trylock())
          return restart_syscall();

This can be problematic when multiple userspace threads use such
interfaces in a short period, making them to spin a lot. This happens
for example when adding and moving virtual interfaces: userspace
programs listening on events, such as systemd-udevd and NetworkManager,
do trigger actions reading files in sysfs. It gets worse when a lot of
virtual interfaces are created concurrently, say when creating
containers at boot time.

Returning early without hitting the above pattern when the syscall will
fail eventually does make things better. While it is not a fix for the
issue, it does ease things.

[1] https://lore.kernel.org/netdev/49A4D5D5.5090602@trash.net/
    https://lore.kernel.org/netdev/m14oyhis31.fsf@fess.ebiederm.org/
    and https://lore.kernel.org/netdev/20090226084924.16cb3e08@nehalam/
[2] Rightfully, those deadlocks are *hard* to solve.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net-sysfs.c | 55 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index b2e49eb7001d6..dfa5ecff7f738 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -175,6 +175,14 @@ static int change_carrier(struct net_device *dev, unsigned long new_carrier)
 static ssize_t carrier_store(struct device *dev, struct device_attribute *attr,
 			     const char *buf, size_t len)
 {
+	struct net_device *netdev = to_net_dev(dev);
+
+	/* The check is also done in change_carrier; this helps returning early
+	 * without hitting the trylock/restart in netdev_store.
+	 */
+	if (!netdev->netdev_ops->ndo_change_carrier)
+		return -EOPNOTSUPP;
+
 	return netdev_store(dev, attr, buf, len, change_carrier);
 }
 
@@ -196,6 +204,12 @@ static ssize_t speed_show(struct device *dev,
 	struct net_device *netdev = to_net_dev(dev);
 	int ret = -EINVAL;
 
+	/* The check is also done in __ethtool_get_link_ksettings; this helps
+	 * returning early without hitting the trylock/restart below.
+	 */
+	if (!netdev->ethtool_ops->get_link_ksettings)
+		return ret;
+
 	if (!rtnl_trylock())
 		return restart_syscall();
 
@@ -216,6 +230,12 @@ static ssize_t duplex_show(struct device *dev,
 	struct net_device *netdev = to_net_dev(dev);
 	int ret = -EINVAL;
 
+	/* The check is also done in __ethtool_get_link_ksettings; this helps
+	 * returning early without hitting the trylock/restart below.
+	 */
+	if (!netdev->ethtool_ops->get_link_ksettings)
+		return ret;
+
 	if (!rtnl_trylock())
 		return restart_syscall();
 
@@ -468,6 +488,14 @@ static ssize_t proto_down_store(struct device *dev,
 				struct device_attribute *attr,
 				const char *buf, size_t len)
 {
+	struct net_device *netdev = to_net_dev(dev);
+
+	/* The check is also done in change_proto_down; this helps returning
+	 * early without hitting the trylock/restart in netdev_store.
+	 */
+	if (!netdev->netdev_ops->ndo_change_proto_down)
+		return -EOPNOTSUPP;
+
 	return netdev_store(dev, attr, buf, len, change_proto_down);
 }
 NETDEVICE_SHOW_RW(proto_down, fmt_dec);
@@ -478,6 +506,12 @@ static ssize_t phys_port_id_show(struct device *dev,
 	struct net_device *netdev = to_net_dev(dev);
 	ssize_t ret = -EINVAL;
 
+	/* The check is also done in dev_get_phys_port_id; this helps returning
+	 * early without hitting the trylock/restart below.
+	 */
+	if (!netdev->netdev_ops->ndo_get_phys_port_id)
+		return -EOPNOTSUPP;
+
 	if (!rtnl_trylock())
 		return restart_syscall();
 
@@ -500,6 +534,13 @@ static ssize_t phys_port_name_show(struct device *dev,
 	struct net_device *netdev = to_net_dev(dev);
 	ssize_t ret = -EINVAL;
 
+	/* The checks are also done in dev_get_phys_port_name; this helps
+	 * returning early without hitting the trylock/restart below.
+	 */
+	if (!netdev->netdev_ops->ndo_get_phys_port_name &&
+	    !netdev->netdev_ops->ndo_get_devlink_port)
+		return -EOPNOTSUPP;
+
 	if (!rtnl_trylock())
 		return restart_syscall();
 
@@ -522,6 +563,14 @@ static ssize_t phys_switch_id_show(struct device *dev,
 	struct net_device *netdev = to_net_dev(dev);
 	ssize_t ret = -EINVAL;
 
+	/* The checks are also done in dev_get_phys_port_name; this helps
+	 * returning early without hitting the trylock/restart below. This works
+	 * because recurse is false when calling dev_get_port_parent_id.
+	 */
+	if (!netdev->netdev_ops->ndo_get_port_parent_id &&
+	    !netdev->netdev_ops->ndo_get_devlink_port)
+		return -EOPNOTSUPP;
+
 	if (!rtnl_trylock())
 		return restart_syscall();
 
@@ -1226,6 +1275,12 @@ static ssize_t tx_maxrate_store(struct netdev_queue *queue,
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
+	/* The check is also done later; this helps returning early without
+	 * hitting the trylock/restart below.
+	 */
+	if (!dev->netdev_ops->ndo_set_tx_maxrate)
+		return -EOPNOTSUPP;
+
 	err = kstrtou32(buf, 10, &rate);
 	if (err < 0)
 		return err;
-- 
2.33.0



