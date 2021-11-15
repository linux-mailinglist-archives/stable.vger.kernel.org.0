Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E050C4520C5
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245281AbhKPA42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:56:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:44638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343572AbhKOTVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06E0D63358;
        Mon, 15 Nov 2021 18:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001739;
        bh=AGQ3LuNKO9fnXEDecJc4U1g/iWDyEv+vkYlwx4qWrw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FUKKPdCtoKQzd9ofnzPD6+dqhB3IW8LCMJuZueOUq7NJZ+uDYQtVex7AYxUbAXmdq
         6KugJYQIgJFSNMyZRGKXy0RVBnH6cW1SQVkaezoJnyPV6dR16e0rztex3tJM2ICeZg
         EotIetWgGa7wUYeHqSybscsXFZnIGsy9UUJXx4zw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 301/917] net: dsa: flush switchdev workqueue when leaving the bridge
Date:   Mon, 15 Nov 2021 17:56:36 +0100
Message-Id: <20211115165438.966642608@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit d7d0d423dbaa73fd0506e25971dfdab6bf185d00 ]

DSA is preparing to offer switch drivers an API through which they can
associate each FDB entry with a struct net_device *bridge_dev. This can
be used to perform FDB isolation (the FDB lookup performed on the
ingress of a standalone, or bridged port, should not find an FDB entry
that is present in the FDB of another bridge).

In preparation of that work, DSA needs to ensure that by the time we
call the switch .port_fdb_add and .port_fdb_del methods, the
dp->bridge_dev pointer is still valid, i.e. the port is still a bridge
port.

This is not guaranteed because the SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE API
requires drivers that must have sleepable context to handle those events
to schedule the deferred work themselves. DSA does this through the
dsa_owq.

It can happen that a port leaves a bridge, del_nbp() flushes the FDB on
that port, SWITCHDEV_FDB_DEL_TO_DEVICE is notified in atomic context,
DSA schedules its deferred work, but del_nbp() finishes unlinking the
bridge as a master from the port before DSA's deferred work is run.

Fundamentally, the port must not be unlinked from the bridge until all
FDB deletion deferred work items have been flushed. The bridge must wait
for the completion of these hardware accesses.

An attempt has been made to address this issue centrally in switchdev by
making SWITCHDEV_FDB_DEL_TO_DEVICE deferred (=> blocking) at the switchdev
level, which would offer implicit synchronization with del_nbp:

https://patchwork.kernel.org/project/netdevbpf/cover/20210820115746.3701811-1-vladimir.oltean@nxp.com/

but it seems that any attempt to modify switchdev's behavior and make
the events blocking there would introduce undesirable side effects in
other switchdev consumers.

The most undesirable behavior seems to be that
switchdev_deferred_process_work() takes the rtnl_mutex itself, which
would be worse off than having the rtnl_mutex taken individually from
drivers which is what we have now (except DSA which has removed that
lock since commit 0faf890fc519 ("net: dsa: drop rtnl_lock from
dsa_slave_switchdev_event_work")).

So to offer the needed guarantee to DSA switch drivers, I have come up
with a compromise solution that does not require switchdev rework:
we already have a hook at the last moment in time when the bridge is
still an upper of ours: the NETDEV_PRECHANGEUPPER handler. We can flush
the dsa_owq manually from there, which makes all FDB deletions
synchronous.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/port.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 616330a16d319..3947537ed46ba 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -380,6 +380,8 @@ void dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	switchdev_bridge_port_unoffload(brport_dev, dp,
 					&dsa_slave_switchdev_notifier,
 					&dsa_slave_switchdev_blocking_notifier);
+
+	dsa_flush_workqueue();
 }
 
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
-- 
2.33.0



