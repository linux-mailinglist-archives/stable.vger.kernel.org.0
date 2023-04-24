Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F516ECE63
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbjDXNcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232526AbjDXNbn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:31:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC106EAC
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:31:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E74FA62321
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E9AC4339E;
        Mon, 24 Apr 2023 13:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343072;
        bh=W/GVl5ywtT7PzvOuOmCcsQ4llQ1ejoLlnD559adwA3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/ntMC6MW900RgAFtZh+ef/qAPS81D+6b+YSJoFOgXeuw+x4xGg/YSx2HtUptryzn
         ci6RN+eMfRWK9iUonCyB6vQBY6HRn3eSPrxZl4I/82nIj84V5OXUpNBKUzVhJIuhGS
         IjWAu1UdkujOfRNrieStlFyNasWoLZDcQ4vQ0FPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 037/110] net: bridge: switchdev: dont notify FDB entries with "master dynamic"
Date:   Mon, 24 Apr 2023 15:16:59 +0200
Message-Id: <20230424131137.540297189@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 927cdea5d2095287ddd5246e5aa68eb5d68db2be ]

There is a structural problem in switchdev, where the flag bits in
struct switchdev_notifier_fdb_info (added_by_user, is_local etc) only
represent a simplified / denatured view of what's in struct
net_bridge_fdb_entry :: flags (BR_FDB_ADDED_BY_USER, BR_FDB_LOCAL etc).
Each time we want to pass more information about struct
net_bridge_fdb_entry :: flags to struct switchdev_notifier_fdb_info
(here, BR_FDB_STATIC), we find that FDB entries were already notified to
switchdev with no regard to this flag, and thus, switchdev drivers had
no indication whether the notified entries were static or not.

For example, this command:

ip link add br0 type bridge && ip link set swp0 master br0
bridge fdb add dev swp0 00:01:02:03:04:05 master dynamic

has never worked as intended with switchdev. It causes a struct
net_bridge_fdb_entry to be passed to br_switchdev_fdb_notify() which has
a single flag set: BR_FDB_ADDED_BY_USER.

This is further passed to the switchdev notifier chain, where interested
drivers have no choice but to assume this is a static (does not age) and
sticky (does not migrate) FDB entry. So currently, all drivers offload
it to hardware as such, as can be seen below ("offload" is set).

bridge fdb get 00:01:02:03:04:05 dev swp0 master
00:01:02:03:04:05 dev swp0 offload master br0

The software FDB entry expires $ageing_time centiseconds after the
kernel last sees a packet with this MAC SA, and the bridge notifies its
deletion as well, so it eventually disappears from hardware too.

This is a problem, because it is actually desirable to start offloading
"master dynamic" FDB entries correctly - they should expire $ageing_time
centiseconds after the *hardware* port last sees a packet with this
MAC SA - and this is how the current incorrect behavior was discovered.
With an offloaded data plane, it can be expected that software only sees
exception path packets, so an otherwise active dynamic FDB entry would
be aged out by software sooner than it should.

With the change in place, these FDB entries are no longer offloaded:

bridge fdb get 00:01:02:03:04:05 dev swp0 master
00:01:02:03:04:05 dev swp0 master br0

and this also constitutes a better way (assuming a backport to stable
kernels) for user space to determine whether the kernel has the
capability of doing something sane with these or not.

As opposed to "master dynamic" FDB entries, on the current behavior of
which no one currently depends on (which can be deduced from the lack of
kselftests), Ido Schimmel explains that entries with the "extern_learn"
flag (BR_FDB_ADDED_BY_EXT_LEARN) should still be notified to switchdev,
since the spectrum driver listens to them (and this is kind of okay,
because although they are treated identically to "static", they are
expected to not age, and to roam).

Fixes: 6b26b51b1d13 ("net: bridge: Add support for notifying devices about FDB add/del")
Link: https://lore.kernel.org/netdev/20230327115206.jk5q5l753aoelwus@skbuf/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/r/20230418155902.898627-1-vladimir.oltean@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_switchdev.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 7eb6fd5bb917a..0b5f8e1a7325d 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -150,6 +150,17 @@ br_switchdev_fdb_notify(struct net_bridge *br,
 	if (test_bit(BR_FDB_LOCKED, &fdb->flags))
 		return;
 
+	/* Entries with these flags were created using ndm_state == NUD_REACHABLE,
+	 * ndm_flags == NTF_MASTER( | NTF_STICKY), ext_flags == 0 by something
+	 * equivalent to 'bridge fdb add ... master dynamic (sticky)'.
+	 * Drivers don't know how to deal with these, so don't notify them to
+	 * avoid confusing them.
+	 */
+	if (test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags) &&
+	    !test_bit(BR_FDB_STATIC, &fdb->flags) &&
+	    !test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags))
+		return;
+
 	br_switchdev_fdb_populate(br, &item, fdb, NULL);
 
 	switch (type) {
-- 
2.39.2



