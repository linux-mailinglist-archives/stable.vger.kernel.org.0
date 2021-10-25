Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4044A43A06B
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235055AbhJYTaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:30:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235814AbhJYT3O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:29:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 551A161165;
        Mon, 25 Oct 2021 19:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189964;
        bh=mW+CiayvMKYVbiYRfydmk3xas+6IQdHZy8snMM5xuVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t//4FnWGLCWr7DSwD1rXWZ+RmhnpsiKEbf6eM5jJL0tddM4cWLC8iBJOnzVI/7jR2
         BKeIQcNysDXWTaupeNqNU92EAKwS2i5f4byV+bIqlpJRMZxK166vYnF5U+qHnEj8PZ
         m6KzCMobFHU4jM7jcDd+/3EliYDHW93NtrVJzPXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Fabian=20Bl=C3=A4se?= <fabian@blaese.de>
Subject: [PATCH 5.4 02/58] net: switchdev: do not propagate bridge updates across bridges
Date:   Mon, 25 Oct 2021 21:14:19 +0200
Message-Id: <20211025190937.999537264@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190937.555108060@linuxfoundation.org>
References: <20211025190937.555108060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

commit 07c6f9805f12f1bb538ef165a092b300350384aa upstream.

When configuring a tree of independent bridges, propagating changes
from the upper bridge across a bridge master to the lower bridge
ports brings surprises.

For example, a lower bridge may have vlan filtering enabled.  It
may have a vlan interface attached to the bridge master, which may
then be incorporated into another bridge.  As soon as the lower
bridge vlan interface is attached to the upper bridge, the lower
bridge has vlan filtering disabled.

This occurs because switchdev recursively applies its changes to
all lower devices no matter what.

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Tested-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Fabian Bläse <fabian@blaese.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/switchdev/switchdev.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -476,6 +476,9 @@ static int __switchdev_handle_port_obj_a
 	 * necessary to go through this helper.
 	 */
 	netdev_for_each_lower_dev(dev, lower_dev, iter) {
+		if (netif_is_bridge_master(lower_dev))
+			continue;
+
 		err = __switchdev_handle_port_obj_add(lower_dev, port_obj_info,
 						      check_cb, add_cb);
 		if (err && err != -EOPNOTSUPP)
@@ -528,6 +531,9 @@ static int __switchdev_handle_port_obj_d
 	 * necessary to go through this helper.
 	 */
 	netdev_for_each_lower_dev(dev, lower_dev, iter) {
+		if (netif_is_bridge_master(lower_dev))
+			continue;
+
 		err = __switchdev_handle_port_obj_del(lower_dev, port_obj_info,
 						      check_cb, del_cb);
 		if (err && err != -EOPNOTSUPP)
@@ -579,6 +585,9 @@ static int __switchdev_handle_port_attr_
 	 * necessary to go through this helper.
 	 */
 	netdev_for_each_lower_dev(dev, lower_dev, iter) {
+		if (netif_is_bridge_master(lower_dev))
+			continue;
+
 		err = __switchdev_handle_port_attr_set(lower_dev, port_attr_info,
 						       check_cb, set_cb);
 		if (err && err != -EOPNOTSUPP)


