Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED29D45C394
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348336AbhKXNkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:40:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:51750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348855AbhKXNiF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:38:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 568D263210;
        Wed, 24 Nov 2021 12:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758572;
        bh=QSqCYEMAf62OEoYS4OdQuGkXlIQKQh6bwBJcxa1BN2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mLUJL48Dj/akb9oZLjJaOVNKISyGkmsyJFUkTZLAD+ioivtsCleAqzsroZ7mKe1iT
         kPtw6E6QzMLkVEF+ZsHQKO3ZyxHyX/sTsMKee/P8XZxO/PawuEP0ClJdR4D0VCWGKI
         x87wC+z+VyiZ18R6KoHttxxUvqZ3DpYphxCcXuCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arjun Roy <arjunroy@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/154] net-zerocopy: Refactor skb frag fast-forward op.
Date:   Wed, 24 Nov 2021 12:57:46 +0100
Message-Id: <20211124115704.584102373@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

[ Upstream commit 7fba5309efe24e4f0284ef4b8663cdf401035e72 ]

Refactor skb frag fast-forwarding for tcp receive zerocopy. This is
part of a patch set that introduces short-circuited hybrid copies
for small receive operations, which results in roughly 33% fewer
syscalls for small RPC scenarios.

skb_advance_to_frag(), given a skb and an offset into the skb,
iterates from the first frag for the skb until we're at the frag
specified by the offset. Assuming the offset provided refers to how
many bytes in the skb are already read, the returned frag points to
the next frag we may read from, while offset_frag is set to the number
of bytes from this frag that we have already read.

If frag is not null and offset_frag is equal to 0, then we may be able
to map this frag's page into the process address space with
vm_insert_page(). However, if offset_frag is not equal to 0, then we
cannot do so.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ba6e4c6db3b0a..b3721cff45023 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1746,6 +1746,28 @@ int tcp_mmap(struct file *file, struct socket *sock,
 }
 EXPORT_SYMBOL(tcp_mmap);
 
+static skb_frag_t *skb_advance_to_frag(struct sk_buff *skb, u32 offset_skb,
+				       u32 *offset_frag)
+{
+	skb_frag_t *frag;
+
+	offset_skb -= skb_headlen(skb);
+	if ((int)offset_skb < 0 || skb_has_frag_list(skb))
+		return NULL;
+
+	frag = skb_shinfo(skb)->frags;
+	while (offset_skb) {
+		if (skb_frag_size(frag) > offset_skb) {
+			*offset_frag = offset_skb;
+			return frag;
+		}
+		offset_skb -= skb_frag_size(frag);
+		++frag;
+	}
+	*offset_frag = 0;
+	return frag;
+}
+
 static int tcp_copy_straggler_data(struct tcp_zerocopy_receive *zc,
 				   struct sk_buff *skb, u32 copylen,
 				   u32 *offset, u32 *seq)
@@ -1872,6 +1894,8 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	curr_addr = address;
 	while (length + PAGE_SIZE <= zc->length) {
 		if (zc->recv_skip_hint < PAGE_SIZE) {
+			u32 offset_frag;
+
 			/* If we're here, finish the current batch. */
 			if (pg_idx) {
 				ret = tcp_zerocopy_vm_insert_batch(vma, pages,
@@ -1892,16 +1916,9 @@ static int tcp_zerocopy_receive(struct sock *sk,
 				skb = tcp_recv_skb(sk, seq, &offset);
 			}
 			zc->recv_skip_hint = skb->len - offset;
-			offset -= skb_headlen(skb);
-			if ((int)offset < 0 || skb_has_frag_list(skb))
+			frags = skb_advance_to_frag(skb, offset, &offset_frag);
+			if (!frags || offset_frag)
 				break;
-			frags = skb_shinfo(skb)->frags;
-			while (offset) {
-				if (skb_frag_size(frags) > offset)
-					goto out;
-				offset -= skb_frag_size(frags);
-				frags++;
-			}
 		}
 		if (skb_frag_size(frags) != PAGE_SIZE || skb_frag_off(frags)) {
 			int remaining = zc->recv_skip_hint;
-- 
2.33.0



