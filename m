Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490AC4A4416
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359626AbiAaL0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:26:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41794 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378339AbiAaLYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:24:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A0BFB82A69;
        Mon, 31 Jan 2022 11:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67685C340EE;
        Mon, 31 Jan 2022 11:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628240;
        bh=5KWzA4AfI8HVUxyFlZgUqfeJSf59g4119hh9HmUO5uQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=brulv/rzTDO/UvAvDVB1IyeBq/QYsjZ7ePh6NdU8ppJ36G48biRehA+qRu0CBN+gp
         styOTxheshfHYyAH0BU+qXItnR5Cclt/AgyQ/oZ0JvKleBiOPY4ULBcWyA2KriRrHH
         Ab7r7WT0cUZaYkRp7BIft414MMuk3aWXDBe182/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 136/200] mptcp: allow changing the "backup" bit by endpoint id
Date:   Mon, 31 Jan 2022 11:56:39 +0100
Message-Id: <20220131105238.136417203@linuxfoundation.org>
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

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit 602837e8479d20d49559b4b97b79d34c0efe7ecb ]

a non-zero 'id' is sufficient to identify MPTCP endpoints: allow changing
the value of 'backup' bit by simply specifying the endpoint id.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/158
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 65764c8171b37..d18b13e3e74c6 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1711,22 +1711,28 @@ next:
 
 static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
 {
+	struct mptcp_pm_addr_entry addr = { .addr = { .family = AF_UNSPEC }, }, *entry;
 	struct nlattr *attr = info->attrs[MPTCP_PM_ATTR_ADDR];
 	struct pm_nl_pernet *pernet = genl_info_pm_nl(info);
-	struct mptcp_pm_addr_entry addr, *entry;
 	struct net *net = sock_net(skb->sk);
-	u8 bkup = 0;
+	u8 bkup = 0, lookup_by_id = 0;
 	int ret;
 
-	ret = mptcp_pm_parse_addr(attr, info, true, &addr);
+	ret = mptcp_pm_parse_addr(attr, info, false, &addr);
 	if (ret < 0)
 		return ret;
 
 	if (addr.flags & MPTCP_PM_ADDR_FLAG_BACKUP)
 		bkup = 1;
+	if (addr.addr.family == AF_UNSPEC) {
+		lookup_by_id = 1;
+		if (!addr.addr.id)
+			return -EOPNOTSUPP;
+	}
 
 	list_for_each_entry(entry, &pernet->local_addr_list, list) {
-		if (addresses_equal(&entry->addr, &addr.addr, true)) {
+		if ((!lookup_by_id && addresses_equal(&entry->addr, &addr.addr, true)) ||
+		    (lookup_by_id && entry->addr.id == addr.addr.id)) {
 			mptcp_nl_addr_backup(net, &entry->addr, bkup);
 
 			if (bkup)
-- 
2.34.1



