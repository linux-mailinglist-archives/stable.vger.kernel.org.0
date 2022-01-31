Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE294A452D
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359024AbiAaLhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378481AbiAaLeU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:34:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CD7C02B8DA;
        Mon, 31 Jan 2022 03:22:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93B5861120;
        Mon, 31 Jan 2022 11:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBDAC340E8;
        Mon, 31 Jan 2022 11:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628143;
        bh=uCgyX+vVQ+WN6+QQjxI4uIQfHhW8Ybycw8rU5Uc4pKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nmQk0jXSHrqJcG3CPkwR8U1Dp22+dIPK4+rhOamuTiFJpb/en3ahFGw3SzvN4x8wa
         AwqBsEk70AwGAy9mSyCWW1FlOY/FXPBIHfdJEj81/RS2uwPYfanYOiGHAz7KG+TE7l
         L6DD4+ZyzRFM1pqjOGonXu1ihF4dqreX/804WeFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 139/200] mptcp: fix msk traversal in mptcp_nl_cmd_set_flags()
Date:   Mon, 31 Jan 2022 11:56:42 +0100
Message-Id: <20220131105238.229221476@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 8e9eacad7ec7a9cbf262649ebf1fa6e6f6cc7d82 ]

The MPTCP endpoint list is under RCU protection, guarded by the
pernet spinlock. mptcp_nl_cmd_set_flags() traverses the list
without acquiring the spin-lock nor under the RCU critical section.

This change addresses the issue performing the lookup and the endpoint
update under the pernet spinlock.

Fixes: 0f9f696a502e ("mptcp: add set_flags command in PM netlink")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index ad3dc9c6c5310..35abcce604b4d 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -469,6 +469,20 @@ __lookup_addr_by_id(struct pm_nl_pernet *pernet, unsigned int id)
 	return NULL;
 }
 
+static struct mptcp_pm_addr_entry *
+__lookup_addr(struct pm_nl_pernet *pernet, const struct mptcp_addr_info *info,
+	      bool lookup_by_id)
+{
+	struct mptcp_pm_addr_entry *entry;
+
+	list_for_each_entry(entry, &pernet->local_addr_list, list) {
+		if ((!lookup_by_id && addresses_equal(&entry->addr, info, true)) ||
+		    (lookup_by_id && entry->addr.id == info->id))
+			return entry;
+	}
+	return NULL;
+}
+
 static int
 lookup_id_by_addr(struct pm_nl_pernet *pernet, const struct mptcp_addr_info *addr)
 {
@@ -1753,18 +1767,21 @@ static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
 			return -EOPNOTSUPP;
 	}
 
-	list_for_each_entry(entry, &pernet->local_addr_list, list) {
-		if ((!lookup_by_id && addresses_equal(&entry->addr, &addr.addr, true)) ||
-		    (lookup_by_id && entry->addr.id == addr.addr.id)) {
-			mptcp_nl_addr_backup(net, &entry->addr, bkup);
-
-			if (bkup)
-				entry->flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
-			else
-				entry->flags &= ~MPTCP_PM_ADDR_FLAG_BACKUP;
-		}
+	spin_lock_bh(&pernet->lock);
+	entry = __lookup_addr(pernet, &addr.addr, lookup_by_id);
+	if (!entry) {
+		spin_unlock_bh(&pernet->lock);
+		return -EINVAL;
 	}
 
+	if (bkup)
+		entry->flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
+	else
+		entry->flags &= ~MPTCP_PM_ADDR_FLAG_BACKUP;
+	addr = *entry;
+	spin_unlock_bh(&pernet->lock);
+
+	mptcp_nl_addr_backup(net, &addr.addr, bkup);
 	return 0;
 }
 
-- 
2.34.1



