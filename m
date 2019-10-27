Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF8BE68F5
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730123AbfJ0VMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:12:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730118AbfJ0VMw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:12:52 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94575205C9;
        Sun, 27 Oct 2019 21:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210772;
        bh=2n/nNyHcFnf0Q7AXrJvx/JNNbVdkeXFi6BIcuQdJvrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TPmPbzIeOhlvgk4uqNsJTvyqcTf/i8UpAn9I70ijpfs9G+3ffiXGXOxdbINTteKoJ
         OSjeP92wQ7V8uB1POKgYr9V9aWsF2xXcPzuEif0srcEVcXbLSPv1/63ciQVJs9eX2C
         3vvUdflNCm+UGxpYJV0dvxpMbhUxkULZJSDeMrn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqing Pan <miaoqing@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/93] nl80211: fix null pointer dereference
Date:   Sun, 27 Oct 2019 22:00:24 +0100
Message-Id: <20191027203254.422065221@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqing Pan <miaoqing@codeaurora.org>

[ Upstream commit b501426cf86e70649c983c52f4c823b3c40d72a3 ]

If the interface is not in MESH mode, the command 'iw wlanx mpath del'
will cause kernel panic.

The root cause is null pointer access in mpp_flush_by_proxy(), as the
pointer 'sdata->u.mesh.mpp_paths' is NULL for non MESH interface.

Unable to handle kernel NULL pointer dereference at virtual address 00000068
[...]
PC is at _raw_spin_lock_bh+0x20/0x5c
LR is at mesh_path_del+0x1c/0x17c [mac80211]
[...]
Process iw (pid: 4537, stack limit = 0xd83e0238)
[...]
[<c021211c>] (_raw_spin_lock_bh) from [<bf8c7648>] (mesh_path_del+0x1c/0x17c [mac80211])
[<bf8c7648>] (mesh_path_del [mac80211]) from [<bf6cdb7c>] (extack_doit+0x20/0x68 [compat])
[<bf6cdb7c>] (extack_doit [compat]) from [<c05c309c>] (genl_rcv_msg+0x274/0x30c)
[<c05c309c>] (genl_rcv_msg) from [<c05c25d8>] (netlink_rcv_skb+0x58/0xac)
[<c05c25d8>] (netlink_rcv_skb) from [<c05c2e14>] (genl_rcv+0x20/0x34)
[<c05c2e14>] (genl_rcv) from [<c05c1f90>] (netlink_unicast+0x11c/0x204)
[<c05c1f90>] (netlink_unicast) from [<c05c2420>] (netlink_sendmsg+0x30c/0x370)
[<c05c2420>] (netlink_sendmsg) from [<c05886d0>] (sock_sendmsg+0x70/0x84)
[<c05886d0>] (sock_sendmsg) from [<c0589f4c>] (___sys_sendmsg.part.3+0x188/0x228)
[<c0589f4c>] (___sys_sendmsg.part.3) from [<c058add4>] (__sys_sendmsg+0x4c/0x70)
[<c058add4>] (__sys_sendmsg) from [<c0208c80>] (ret_fast_syscall+0x0/0x44)
Code: e2822c02 e2822001 e5832004 f590f000 (e1902f9f)
---[ end trace bbd717600f8f884d ]---

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
Link: https://lore.kernel.org/r/1569485810-761-1-git-send-email-miaoqing@codeaurora.org
[trim useless data from commit message]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 334e3181f1c52..a28d6456e93e2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5843,6 +5843,9 @@ static int nl80211_del_mpath(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->del_mpath)
 		return -EOPNOTSUPP;
 
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT)
+		return -EOPNOTSUPP;
+
 	return rdev_del_mpath(rdev, dev, dst);
 }
 
-- 
2.20.1



