Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE9034C905
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbhC2I0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:26:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232904AbhC2IYX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:24:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED00E619C2;
        Mon, 29 Mar 2021 08:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006260;
        bh=9IfONxfl7zOM+uNS+hW2gVz03E0r6Wo4qXb85vEd4j4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gn5YU7EWaoR4KqLjv1OcjQ7w1TWj7S5XqHKnv/XNuzve1/VanT9+52FLiUh6T8pkU
         9/JAL3sGdfsxoaBjoFL+yZrfv1s3w/tkGgwZscI/7OulJAtdOKVFPio9xzcpIWbekM
         v7k/9KhW88W1UxmPZzJHFlzm4y+u94VlBTSbKPz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/221] net: bridge: dont notify switchdev for local FDB addresses
Date:   Mon, 29 Mar 2021 09:58:26 +0200
Message-Id: <20210329075634.986056008@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 6ab4c3117aec4e08007d9e971fa4133e1de1082d ]

As explained in this discussion:
https://lore.kernel.org/netdev/20210117193009.io3nungdwuzmo5f7@skbuf/

the switchdev notifiers for FDB entries managed to have a zero-day bug.
The bridge would not say that this entry is local:

ip link add br0 type bridge
ip link set swp0 master br0
bridge fdb add dev swp0 00:01:02:03:04:05 master local

and the switchdev driver would be more than happy to offload it as a
normal static FDB entry. This is despite the fact that 'local' and
non-'local' entries have completely opposite directions: a local entry
is locally terminated and not forwarded, whereas a static entry is
forwarded and not locally terminated. So, for example, DSA would install
this entry on swp0 instead of installing it on the CPU port as it should.

There is an even sadder part, which is that the 'local' flag is implicit
if 'static' is not specified, meaning that this command produces the
same result of adding a 'local' entry:

bridge fdb add dev swp0 00:01:02:03:04:05 master

I've updated the man pages for 'bridge', and after reading it now, it
should be pretty clear to any user that the commands above were broken
and should have never resulted in the 00:01:02:03:04:05 address being
forwarded (this behavior is coherent with non-switchdev interfaces):
https://patchwork.kernel.org/project/netdevbpf/cover/20210211104502.2081443-1-olteanv@gmail.com/
If you're a user reading this and this is what you want, just use:

bridge fdb add dev swp0 00:01:02:03:04:05 master static

Because switchdev should have given drivers the means from day one to
classify FDB entries as local/non-local, but didn't, it means that all
drivers are currently broken. So we can just as well omit the switchdev
notifications for local FDB entries, which is exactly what this patch
does to close the bug in stable trees. For further development work
where drivers might want to trap the local FDB entries to the host, we
can add a 'bool is_local' to br_switchdev_fdb_call_notifiers(), and
selectively make drivers act upon that bit, while all the others ignore
those entries if the 'is_local' bit is set.

Fixes: 6b26b51b1d13 ("net: bridge: Add support for notifying devices about FDB add/del")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_switchdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 015209bf44aa..3c42095fa75f 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -123,6 +123,8 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
 {
 	if (!fdb->dst)
 		return;
+	if (test_bit(BR_FDB_LOCAL, &fdb->flags))
+		return;
 
 	switch (type) {
 	case RTM_DELNEIGH:
-- 
2.30.1



