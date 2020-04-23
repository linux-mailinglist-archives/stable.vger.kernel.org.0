Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87701B6879
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgDWXPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:15:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49682 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728416AbgDWXGr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:47 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvU-0004hK-98; Fri, 24 Apr 2020 00:06:36 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvR-00E6q2-P9; Fri, 24 Apr 2020 00:06:33 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        syzbot+f68108fed972453a0ad4@syzkaller.appspotmail.com,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        "Florian Westphal" <fw@strlen.de>
Date:   Fri, 24 Apr 2020 00:06:04 +0100
Message-ID: <lsq.1587683028.484204835@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 137/245] netfilter: ebtables: compat: reject all
 padding in matches/watchers
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

commit e608f631f0ba5f1fc5ee2e260a3a35d13107cbfe upstream.

syzbot reported following splat:

BUG: KASAN: vmalloc-out-of-bounds in size_entry_mwt net/bridge/netfilter/ebtables.c:2063 [inline]
BUG: KASAN: vmalloc-out-of-bounds in compat_copy_entries+0x128b/0x1380 net/bridge/netfilter/ebtables.c:2155
Read of size 4 at addr ffffc900004461f4 by task syz-executor267/7937

CPU: 1 PID: 7937 Comm: syz-executor267 Not tainted 5.5.0-rc1-syzkaller #0
 size_entry_mwt net/bridge/netfilter/ebtables.c:2063 [inline]
 compat_copy_entries+0x128b/0x1380 net/bridge/netfilter/ebtables.c:2155
 compat_do_replace+0x344/0x720 net/bridge/netfilter/ebtables.c:2249
 compat_do_ebt_set_ctl+0x22f/0x27e net/bridge/netfilter/ebtables.c:2333
 [..]

Because padding isn't considered during computation of ->buf_user_offset,
"total" is decremented by fewer bytes than it should.

Therefore, the first part of

if (*total < sizeof(*entry) || entry->next_offset < sizeof(*entry))

will pass, -- it should not have.  This causes oob access:
entry->next_offset is past the vmalloced size.

Reject padding and check that computed user offset (sum of ebt_entry
structure plus all individual matches/watchers/targets) is same
value that userspace gave us as the offset of the next entry.

Reported-by: syzbot+f68108fed972453a0ad4@syzkaller.appspotmail.com
Fixes: 81e675c227ec ("netfilter: ebtables: add CONFIG_COMPAT support")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bridge/netfilter/ebtables.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1855,7 +1855,7 @@ static int ebt_buf_count(struct ebt_entr
 }
 
 static int ebt_buf_add(struct ebt_entries_buf_state *state,
-		       void *data, unsigned int sz)
+		       const void *data, unsigned int sz)
 {
 	if (state->buf_kern_start == NULL)
 		goto count_only;
@@ -1889,7 +1889,7 @@ enum compat_mwt {
 	EBT_COMPAT_TARGET,
 };
 
-static int compat_mtw_from_user(struct compat_ebt_entry_mwt *mwt,
+static int compat_mtw_from_user(const struct compat_ebt_entry_mwt *mwt,
 				enum compat_mwt compat_mwt,
 				struct ebt_entries_buf_state *state,
 				const unsigned char *base)
@@ -1966,22 +1966,23 @@ static int compat_mtw_from_user(struct c
  * return size of all matches, watchers or target, including necessary
  * alignment and padding.
  */
-static int ebt_size_mwt(struct compat_ebt_entry_mwt *match32,
+static int ebt_size_mwt(const struct compat_ebt_entry_mwt *match32,
 			unsigned int size_left, enum compat_mwt type,
 			struct ebt_entries_buf_state *state, const void *base)
 {
+	const char *buf = (const char *)match32;
 	int growth = 0;
-	char *buf;
 
 	if (size_left == 0)
 		return 0;
 
-	buf = (char *) match32;
-
-	while (size_left >= sizeof(*match32)) {
+	do {
 		struct ebt_entry_match *match_kern;
 		int ret;
 
+		if (size_left < sizeof(*match32))
+			return -EINVAL;
+
 		match_kern = (struct ebt_entry_match *) state->buf_kern_start;
 		if (match_kern) {
 			char *tmp;
@@ -2018,22 +2019,18 @@ static int ebt_size_mwt(struct compat_eb
 		if (match_kern)
 			match_kern->match_size = ret;
 
-		/* rule should have no remaining data after target */
-		if (type == EBT_COMPAT_TARGET && size_left)
-			return -EINVAL;
-
 		match32 = (struct compat_ebt_entry_mwt *) buf;
-	}
+	} while (size_left);
 
 	return growth;
 }
 
 /* called for all ebt_entry structures. */
-static int size_entry_mwt(struct ebt_entry *entry, const unsigned char *base,
+static int size_entry_mwt(const struct ebt_entry *entry, const unsigned char *base,
 			  unsigned int *total,
 			  struct ebt_entries_buf_state *state)
 {
-	unsigned int i, j, startoff, new_offset = 0;
+	unsigned int i, j, startoff, next_expected_off, new_offset = 0;
 	/* stores match/watchers/targets & offset of next struct ebt_entry: */
 	unsigned int offsets[4];
 	unsigned int *offsets_update = NULL;
@@ -2121,11 +2118,13 @@ static int size_entry_mwt(struct ebt_ent
 			return ret;
 	}
 
-	startoff = state->buf_user_offset - startoff;
+	next_expected_off = state->buf_user_offset - startoff;
+	if (next_expected_off != entry->next_offset)
+		return -EINVAL;
 
-	if (WARN_ON(*total < startoff))
+	if (*total < entry->next_offset)
 		return -EINVAL;
-	*total -= startoff;
+	*total -= entry->next_offset;
 	return 0;
 }
 

