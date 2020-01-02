Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1383012ECCB
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729062AbgABWVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:21:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:41630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728611AbgABWVw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:21:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AED1E21D7D;
        Thu,  2 Jan 2020 22:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003711;
        bh=zZsaeynMCpwoa3ybK+tlz92a77OWMbnxZCQX6T/LXss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kmI/oxtWkROBJy0amHfcgNUB8MX1YNIFsUepopUui5q6BPi6kuiEAjx4/JgB8fmKF
         0EwzuV/AxpWGsaAHwEgPWAzgWUdnHflHO0AhudQ2JbHvc+YMZjmD3np51MogLTbQ3n
         vuQHHXIYDwDPibKVLpZIZS7/sZ2VpfJxwwjTRNqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f68108fed972453a0ad4@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 083/114] netfilter: ebtables: compat: reject all padding in matches/watchers
Date:   Thu,  2 Jan 2020 23:07:35 +0100
Message-Id: <20200102220037.546181771@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
References: <20200102220029.183913184@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bridge/netfilter/ebtables.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1876,7 +1876,7 @@ static int ebt_buf_count(struct ebt_entr
 }
 
 static int ebt_buf_add(struct ebt_entries_buf_state *state,
-		       void *data, unsigned int sz)
+		       const void *data, unsigned int sz)
 {
 	if (state->buf_kern_start == NULL)
 		goto count_only;
@@ -1910,7 +1910,7 @@ enum compat_mwt {
 	EBT_COMPAT_TARGET,
 };
 
-static int compat_mtw_from_user(struct compat_ebt_entry_mwt *mwt,
+static int compat_mtw_from_user(const struct compat_ebt_entry_mwt *mwt,
 				enum compat_mwt compat_mwt,
 				struct ebt_entries_buf_state *state,
 				const unsigned char *base)
@@ -1988,22 +1988,23 @@ static int compat_mtw_from_user(struct c
 /* return size of all matches, watchers or target, including necessary
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
@@ -2040,22 +2041,18 @@ static int ebt_size_mwt(struct compat_eb
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
@@ -2141,11 +2138,13 @@ static int size_entry_mwt(struct ebt_ent
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
 


