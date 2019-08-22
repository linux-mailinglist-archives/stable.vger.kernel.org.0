Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDE8A99CD9
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388627AbfHVRYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:24:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404254AbfHVRYg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:24:36 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBE422341A;
        Thu, 22 Aug 2019 17:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494676;
        bh=c/dyECxWAgWxwsyMz9BzdMR/CNkJHimGDLvGM5AJOGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MNrL+l/zlvi3pWha3bp0ZVzQe9Imk2LJJVoLXp774gBXaXbjPzqm9PnI/XVSrSK5v
         ff7Hu3SRPvLcFnY88y94ZgtGSWflGxyVcSnAXXhd3ZBWCcuHMtpDDn3mQx0feXLQ6z
         Gk2bhKNkswpWzIeXeC7DTw3m06evKi9vvEOPRwNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+276ddebab3382bbf72db@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.14 20/71] netfilter: ebtables: also count base chain policies
Date:   Thu, 22 Aug 2019 10:18:55 -0700
Message-Id: <20190822171728.463455924@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171726.131957995@linuxfoundation.org>
References: <20190822171726.131957995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 net/bridge/netfilter/ebtables.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1779,20 +1779,28 @@ static int compat_calc_entry(const struc
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
@@ -2240,11 +2248,9 @@ static int compat_do_replace(struct net
 
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


