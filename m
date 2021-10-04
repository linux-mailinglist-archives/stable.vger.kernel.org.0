Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923A0421004
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238300AbhJDNkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:40:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238389AbhJDNi2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:38:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A8766323F;
        Mon,  4 Oct 2021 13:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353443;
        bh=xxIpexGoEtjP6+UcUtuoU6QLYuAqZh52pa7yGVSSpWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lWJUx4r5qusfhSDZwKy5CV3dQ1gFuVr3znluOE1KmEgfBb3qLsNNeBzeamXfIyBpu
         Ol7DYWFdXDdqu2EK6W6dLBFjtrocAAQNw/vKG8k8gN58mYiCieKLhTRw29YN5IHfu8
         NJ7yXWutGX2dd9mYdn3bhjZsZuOpFrmLPZMEQ5Ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 097/172] mptcp: allow changing the backup bit when no sockets are open
Date:   Mon,  4 Oct 2021 14:52:27 +0200
Message-Id: <20211004125048.119815720@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit 3f4a08909e2c740f8045efc74c4cf82eeaae3e36 ]

current Linux refuses to change the 'backup' bit of MPTCP endpoints, i.e.
using MPTCP_PM_CMD_SET_FLAGS, unless it finds (at least) one subflow that
matches the endpoint address. There is no reason for that, so we can just
ignore the return value of mptcp_nl_addr_backup(). In this way, endpoints
can reconfigure their 'backup' flag even if no MPTCP sockets are open (or
more generally, in case the MP_PRIO message is not sent out).

Fixes: 0f9f696a502e ("mptcp: add set_flags command in PM netlink")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 89251cbe9f1a..81103b29c0af 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1558,9 +1558,7 @@ static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
 
 	list_for_each_entry(entry, &pernet->local_addr_list, list) {
 		if (addresses_equal(&entry->addr, &addr.addr, true)) {
-			ret = mptcp_nl_addr_backup(net, &entry->addr, bkup);
-			if (ret)
-				return ret;
+			mptcp_nl_addr_backup(net, &entry->addr, bkup);
 
 			if (bkup)
 				entry->flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
-- 
2.33.0



