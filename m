Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A3230062C
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbhAVOyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:54:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:39306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728362AbhAVOXp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:23:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 470D123BA7;
        Fri, 22 Jan 2021 14:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325091;
        bh=K6QMxmbf5P4UjZK0d/rqUv5vhavfHqu/4/tEK3AlVQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ioNICJWWUK5FreUjjdIhsy7H0lEUkw5iq4EM39WkEIjma3Tq3OWJ2zEgXTVywAeOc
         YO9+HIj2g0tdr+KB0ojzB6c/mwYUsryASmmHLWo8KXo5mIn6mbanp6eJspxnlb660O
         hknGQKapX/iPEsl2MwDPz9GFC8FqdQsB42IwstGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongseok Yi <dseok.yi@samsung.com>,
        Willem de Bruijn <willemb@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 12/43] net: fix use-after-free when UDP GRO with shared fraglist
Date:   Fri, 22 Jan 2021 15:12:28 +0100
Message-Id: <20210122135736.141811031@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongseok Yi <dseok.yi@samsung.com>

[ Upstream commit 53475c5dd856212e91538a9501162e821cc1f791 ]

skbs in fraglist could be shared by a BPF filter loaded at TC. If TC
writes, it will call skb_ensure_writable -> pskb_expand_head to create
a private linear section for the head_skb. And then call
skb_clone_fraglist -> skb_get on each skb in the fraglist.

skb_segment_list overwrites part of the skb linear section of each
fragment itself. Even after skb_clone, the frag_skbs share their
linear section with their clone in PF_PACKET.

Both sk_receive_queue of PF_PACKET and PF_INET (or PF_INET6) can have
a link for the same frag_skbs chain. If a new skb (not frags) is
queued to one of the sk_receive_queue, multiple ptypes can see and
release this. It causes use-after-free.

[ 4443.426215] ------------[ cut here ]------------
[ 4443.426222] refcount_t: underflow; use-after-free.
[ 4443.426291] WARNING: CPU: 7 PID: 28161 at lib/refcount.c:190
refcount_dec_and_test_checked+0xa4/0xc8
[ 4443.426726] pstate: 60400005 (nZCv daif +PAN -UAO)
[ 4443.426732] pc : refcount_dec_and_test_checked+0xa4/0xc8
[ 4443.426737] lr : refcount_dec_and_test_checked+0xa0/0xc8
[ 4443.426808] Call trace:
[ 4443.426813]  refcount_dec_and_test_checked+0xa4/0xc8
[ 4443.426823]  skb_release_data+0x144/0x264
[ 4443.426828]  kfree_skb+0x58/0xc4
[ 4443.426832]  skb_queue_purge+0x64/0x9c
[ 4443.426844]  packet_set_ring+0x5f0/0x820
[ 4443.426849]  packet_setsockopt+0x5a4/0xcd0
[ 4443.426853]  __sys_setsockopt+0x188/0x278
[ 4443.426858]  __arm64_sys_setsockopt+0x28/0x38
[ 4443.426869]  el0_svc_common+0xf0/0x1d0
[ 4443.426873]  el0_svc_handler+0x74/0x98
[ 4443.426880]  el0_svc+0x8/0xc

Fixes: 3a1296a38d0c (net: Support GRO/GSO fraglist chaining.)
Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/1610072918-174177-1-git-send-email-dseok.yi@samsung.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3648,7 +3648,8 @@ struct sk_buff *skb_segment_list(struct
 	unsigned int delta_truesize = 0;
 	unsigned int delta_len = 0;
 	struct sk_buff *tail = NULL;
-	struct sk_buff *nskb;
+	struct sk_buff *nskb, *tmp;
+	int err;
 
 	skb_push(skb, -skb_network_offset(skb) + offset);
 
@@ -3658,11 +3659,28 @@ struct sk_buff *skb_segment_list(struct
 		nskb = list_skb;
 		list_skb = list_skb->next;
 
+		err = 0;
+		if (skb_shared(nskb)) {
+			tmp = skb_clone(nskb, GFP_ATOMIC);
+			if (tmp) {
+				consume_skb(nskb);
+				nskb = tmp;
+				err = skb_unclone(nskb, GFP_ATOMIC);
+			} else {
+				err = -ENOMEM;
+			}
+		}
+
 		if (!tail)
 			skb->next = nskb;
 		else
 			tail->next = nskb;
 
+		if (unlikely(err)) {
+			nskb->next = list_skb;
+			goto err_linearize;
+		}
+
 		tail = nskb;
 
 		delta_len += nskb->len;


