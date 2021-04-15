Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0612E360D69
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbhDOPCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:02:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234752AbhDOO7f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:59:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D58C61400;
        Thu, 15 Apr 2021 14:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498543;
        bh=Zlzr6/2W0FMvgSiVRcS5cBfjwkkOo+nYlv7TcrxfX/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBPfllAhBG1f/DVNw4C4S1hhHMqLfSw0+sEF4vcARSvGrUK6gpvtvVlh0majV5LGK
         RxxTNyCnk7qrgFNuI6G0Ad/AtVqayPHKEpo/vFzHiJx+6594VIA+gYsBU1Tlk4ig4Q
         iOyec6ptrwvCH1INJtAi7sEV1aTB9/5CWaJfT1YA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+cfc0247ac173f597aaaa@syzkaller.appspotmail.com,
        Andy Nguyen <theflow@google.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 10/13] netfilter: x_tables: fix compat match/target pad out-of-bound write
Date:   Thu, 15 Apr 2021 16:47:59 +0200
Message-Id: <20210415144411.938926747@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144411.596695196@linuxfoundation.org>
References: <20210415144411.596695196@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit b29c457a6511435960115c0f548c4360d5f4801d upstream.

xt_compat_match/target_from_user doesn't check that zeroing the area
to start of next rule won't write past end of allocated ruleset blob.

Remove this code and zero the entire blob beforehand.

Reported-by: syzbot+cfc0247ac173f597aaaa@syzkaller.appspotmail.com
Reported-by: Andy Nguyen <theflow@google.com>
Fixes: 9fa492cdc160c ("[NETFILTER]: x_tables: simplify compat API")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/netfilter/arp_tables.c |    2 ++
 net/ipv4/netfilter/ip_tables.c  |    2 ++
 net/ipv6/netfilter/ip6_tables.c |    2 ++
 net/netfilter/x_tables.c        |   10 ++--------
 4 files changed, 8 insertions(+), 8 deletions(-)

--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1195,6 +1195,8 @@ static int translate_compat_table(struct
 	if (!newinfo)
 		goto out_unlock;
 
+	memset(newinfo->entries, 0, size);
+
 	newinfo->number = compatr->num_entries;
 	for (i = 0; i < NF_ARP_NUMHOOKS; i++) {
 		newinfo->hook_entry[i] = compatr->hook_entry[i];
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1433,6 +1433,8 @@ translate_compat_table(struct net *net,
 	if (!newinfo)
 		goto out_unlock;
 
+	memset(newinfo->entries, 0, size);
+
 	newinfo->number = compatr->num_entries;
 	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
 		newinfo->hook_entry[i] = compatr->hook_entry[i];
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1448,6 +1448,8 @@ translate_compat_table(struct net *net,
 	if (!newinfo)
 		goto out_unlock;
 
+	memset(newinfo->entries, 0, size);
+
 	newinfo->number = compatr->num_entries;
 	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
 		newinfo->hook_entry[i] = compatr->hook_entry[i];
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -738,7 +738,7 @@ void xt_compat_match_from_user(struct xt
 {
 	const struct xt_match *match = m->u.kernel.match;
 	struct compat_xt_entry_match *cm = (struct compat_xt_entry_match *)m;
-	int pad, off = xt_compat_match_offset(match);
+	int off = xt_compat_match_offset(match);
 	u_int16_t msize = cm->u.user.match_size;
 	char name[sizeof(m->u.user.name)];
 
@@ -748,9 +748,6 @@ void xt_compat_match_from_user(struct xt
 		match->compat_from_user(m->data, cm->data);
 	else
 		memcpy(m->data, cm->data, msize - sizeof(*cm));
-	pad = XT_ALIGN(match->matchsize) - match->matchsize;
-	if (pad > 0)
-		memset(m->data + match->matchsize, 0, pad);
 
 	msize += off;
 	m->u.user.match_size = msize;
@@ -1121,7 +1118,7 @@ void xt_compat_target_from_user(struct x
 {
 	const struct xt_target *target = t->u.kernel.target;
 	struct compat_xt_entry_target *ct = (struct compat_xt_entry_target *)t;
-	int pad, off = xt_compat_target_offset(target);
+	int off = xt_compat_target_offset(target);
 	u_int16_t tsize = ct->u.user.target_size;
 	char name[sizeof(t->u.user.name)];
 
@@ -1131,9 +1128,6 @@ void xt_compat_target_from_user(struct x
 		target->compat_from_user(t->data, ct->data);
 	else
 		memcpy(t->data, ct->data, tsize - sizeof(*ct));
-	pad = XT_ALIGN(target->targetsize) - target->targetsize;
-	if (pad > 0)
-		memset(t->data + target->targetsize, 0, pad);
 
 	tsize += off;
 	t->u.user.target_size = tsize;


