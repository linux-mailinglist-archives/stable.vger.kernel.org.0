Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6783899AE3
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391248AbfHVRQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:16:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390367AbfHVRIc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:32 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E668723405;
        Thu, 22 Aug 2019 17:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493711;
        bh=Pi5oWISMQ3clPukYbzRDrIssXpOIiF0xTx9td2Nxsno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2swMwEt7laZSW6sYMxAgbtS9As+rzJVCVE64+F0AMJluIlEXp/wT3E8HuMomzfu6
         XGlHsBvjUxb8WVHrZDY+8HA/pt44M2QFjURd6blxX7NAiKNtmRNmUFo/ObwEGunwrb
         McicPEoyZELVL9PB+aXlom7Bot/rGw+ViC0BMxhE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        syzbot+276ddebab3382bbf72db@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 031/135] netfilter: ebtables: also count base chain policies
Date:   Thu, 22 Aug 2019 13:06:27 -0400
Message-Id: <20190822170811.13303-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 3b48300d5cc7c7bed63fddb006c4046549ed4aec upstream.

ebtables doesn't include the base chain policies in the rule count,
so we need to add them manually when we call into the x_tables core
to allocate space for the comapt offset table.

This lead syzbot to trigger:
WARNING: CPU: 1 PID: 9012 at net/netfilter/x_tables.c:649
xt_compat_add_offset.cold+0x11/0x36 net/netfilter/x_tables.c:649

Reported-by: syzbot+276ddebab3382bbf72db@syzkaller.appspotmail.com
Fixes: 2035f3ff8eaa ("netfilter: ebtables: compat: un-break 32bit setsockopt when no rules are present")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/netfilter/ebtables.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 963dfdc148272..1fa9ac483173d 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1770,20 +1770,28 @@ static int compat_calc_entry(const struct ebt_entry *e,
 	return 0;
 }
 
+static int ebt_compat_init_offsets(unsigned int number)
+{
+	if (number > INT_MAX)
+		return -EINVAL;
+
+	/* also count the base chain policies */
+	number += NF_BR_NUMHOOKS;
+
+	return xt_compat_init_offsets(NFPROTO_BRIDGE, number);
+}
 
 static int compat_table_info(const struct ebt_table_info *info,
 			     struct compat_ebt_replace *newinfo)
 {
 	unsigned int size = info->entries_size;
 	const void *entries = info->entries;
+	int ret;
 
 	newinfo->entries_size = size;
-	if (info->nentries) {
-		int ret = xt_compat_init_offsets(NFPROTO_BRIDGE,
-						 info->nentries);
-		if (ret)
-			return ret;
-	}
+	ret = ebt_compat_init_offsets(info->nentries);
+	if (ret)
+		return ret;
 
 	return EBT_ENTRY_ITERATE(entries, size, compat_calc_entry, info,
 							entries, newinfo);
@@ -2234,11 +2242,9 @@ static int compat_do_replace(struct net *net, void __user *user,
 
 	xt_compat_lock(NFPROTO_BRIDGE);
 
-	if (tmp.nentries) {
-		ret = xt_compat_init_offsets(NFPROTO_BRIDGE, tmp.nentries);
-		if (ret < 0)
-			goto out_unlock;
-	}
+	ret = ebt_compat_init_offsets(tmp.nentries);
+	if (ret < 0)
+		goto out_unlock;
 
 	ret = compat_copy_entries(entries_tmp, tmp.entries_size, &state);
 	if (ret < 0)
-- 
2.20.1

