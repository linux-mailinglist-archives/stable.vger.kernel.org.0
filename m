Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910E829BD57
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368884AbgJ0PmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:42:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800383AbgJ0Pfs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:35:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8515522264;
        Tue, 27 Oct 2020 15:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812948;
        bh=dK9uPsixADoZIJv8LAFNMSNsNU8YcN19ZoCvZFSjN2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pk7HHwCYsz37Tmv4nFBG285Nj5BdTRU8anttXVf9UU/iC4qKr9i8bMR8Z6tWoR/Px
         fVrpeo+MytW654u6wTe0WHSaG4VXz2A8hPFAClGijBWaSqOAUs/NCuiWtkjqo2V8mT
         Kf41yuJy7D+d1w7mEyB7jHcDtwdnVV5kyJewwFGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 386/757] bpf, sockmap: Remove skb_orphan and let normal skb_kfree do cleanup
Date:   Tue, 27 Oct 2020 14:50:36 +0100
Message-Id: <20201027135508.656296526@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 10d58d006356a075a7b056e0f6502db416d1a261 ]

Calling skb_orphan() is unnecessary in the strp rcv handler because the skb
is from a skb_clone() in __strp_recv. So it never has a destructor or a
sk assigned. Plus its confusing to read because it might hint to the reader
that the skb could have an sk assigned which is not true. Even if we did
have an sk assigned it would be cleaner to simply wait for the upcoming
kfree_skb().

Additionally, move the comment about strparser clone up so its closer to
the logic it is describing and add to it so that it is more complete.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/160226865548.5692.9098315689984599579.stgit@john-Precision-5820-Tower
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 649583158983a..30ddca6db6c6b 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -662,15 +662,16 @@ static int sk_psock_bpf_run(struct sk_psock *psock, struct bpf_prog *prog,
 {
 	int ret;
 
+	/* strparser clones the skb before handing it to a upper layer,
+	 * meaning we have the same data, but sk is NULL. We do want an
+	 * sk pointer though when we run the BPF program. So we set it
+	 * here and then NULL it to ensure we don't trigger a BUG_ON()
+	 * in skb/sk operations later if kfree_skb is called with a
+	 * valid skb->sk pointer and no destructor assigned.
+	 */
 	skb->sk = psock->sk;
 	bpf_compute_data_end_sk_skb(skb);
 	ret = bpf_prog_run_pin_on_cpu(prog, skb);
-	/* strparser clones the skb before handing it to a upper layer,
-	 * meaning skb_orphan has been called. We NULL sk on the way out
-	 * to ensure we don't trigger a BUG_ON() in skb/sk operations
-	 * later and because we are not charging the memory of this skb
-	 * to any socket yet.
-	 */
 	skb->sk = NULL;
 	return ret;
 }
@@ -794,7 +795,6 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 	}
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
-		skb_orphan(skb);
 		tcp_skb_bpf_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
 		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
-- 
2.25.1



