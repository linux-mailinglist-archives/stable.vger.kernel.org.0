Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6679A1B688F
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgDWXQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:16:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49560 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728391AbgDWXGq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:46 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvU-0004hN-8v; Fri, 24 Apr 2020 00:06:36 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvR-00E6px-OO; Fri, 24 Apr 2020 00:06:33 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        "Florian Westphal" <fw@strlen.de>
Date:   Fri, 24 Apr 2020 00:06:03 +0100
Message-ID: <lsq.1587683028.493962966@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 136/245] netfilter: ebtables: convert BUG_ONs to WARN_ONs
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit fc6a5d0601c5ac1d02f283a46f60b87b2033e5ca upstream.

All of these conditions are not fatal and should have
been WARN_ONs from the get-go.

Convert them to WARN_ONs and bail out.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bridge/netfilter/ebtables.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1603,7 +1603,8 @@ static int compat_match_to_user(struct e
 	int off = ebt_compat_match_offset(match, m->match_size);
 	compat_uint_t msize = m->match_size - off;
 
-	BUG_ON(off >= m->match_size);
+	if (WARN_ON(off >= m->match_size))
+		return -EINVAL;
 
 	if (copy_to_user(cm->u.name, match->name,
 	    strlen(match->name) + 1) || put_user(msize, &cm->match_size))
@@ -1630,7 +1631,8 @@ static int compat_target_to_user(struct
 	int off = xt_compat_target_offset(target);
 	compat_uint_t tsize = t->target_size - off;
 
-	BUG_ON(off >= t->target_size);
+	if (WARN_ON(off >= t->target_size))
+		return -EINVAL;
 
 	if (copy_to_user(cm->u.name, target->name,
 	    strlen(target->name) + 1) || put_user(tsize, &cm->match_size))
@@ -1858,7 +1860,8 @@ static int ebt_buf_add(struct ebt_entrie
 	if (state->buf_kern_start == NULL)
 		goto count_only;
 
-	BUG_ON(state->buf_kern_offset + sz > state->buf_kern_len);
+	if (WARN_ON(state->buf_kern_offset + sz > state->buf_kern_len))
+		return -EINVAL;
 
 	memcpy(state->buf_kern_start + state->buf_kern_offset, data, sz);
 
@@ -1871,7 +1874,8 @@ static int ebt_buf_add_pad(struct ebt_en
 {
 	char *b = state->buf_kern_start;
 
-	BUG_ON(b && state->buf_kern_offset > state->buf_kern_len);
+	if (WARN_ON(b && state->buf_kern_offset > state->buf_kern_len))
+		return -EINVAL;
 
 	if (b != NULL && sz > 0)
 		memset(b + state->buf_kern_offset, 0, sz);
@@ -1949,8 +1953,10 @@ static int compat_mtw_from_user(struct c
 	pad = XT_ALIGN(size_kern) - size_kern;
 
 	if (pad > 0 && dst) {
-		BUG_ON(state->buf_kern_len <= pad);
-		BUG_ON(state->buf_kern_offset - (match_size + off) + size_kern > state->buf_kern_len - pad);
+		if (WARN_ON(state->buf_kern_len <= pad))
+			return -EINVAL;
+		if (WARN_ON(state->buf_kern_offset - (match_size + off) + size_kern > state->buf_kern_len - pad))
+			return -EINVAL;
 		memset(dst + size_kern, 0, pad);
 	}
 	return off + match_size;
@@ -2001,7 +2007,8 @@ static int ebt_size_mwt(struct compat_eb
 		if (ret < 0)
 			return ret;
 
-		BUG_ON(ret < match32->match_size);
+		if (WARN_ON(ret < match32->match_size))
+			return -EINVAL;
 		growth += ret - match32->match_size;
 		growth += ebt_compat_entry_padsize();
 
@@ -2116,7 +2123,8 @@ static int size_entry_mwt(struct ebt_ent
 
 	startoff = state->buf_user_offset - startoff;
 
-	BUG_ON(*total < startoff);
+	if (WARN_ON(*total < startoff))
+		return -EINVAL;
 	*total -= startoff;
 	return 0;
 }
@@ -2246,7 +2254,8 @@ static int compat_do_replace(struct net
 	state.buf_kern_len = size64;
 
 	ret = compat_copy_entries(entries_tmp, tmp.entries_size, &state);
-	BUG_ON(ret < 0);	/* parses same data again */
+	if (WARN_ON(ret < 0))
+		goto out_unlock;
 
 	vfree(entries_tmp);
 	tmp.entries_size = size64;

