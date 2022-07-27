Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B139582B8D
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236141AbiG0QfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238156AbiG0Qd4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:33:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A68054AF3;
        Wed, 27 Jul 2022 09:26:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FAB861662;
        Wed, 27 Jul 2022 16:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E13C433C1;
        Wed, 27 Jul 2022 16:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939164;
        bh=njurI18qD1t1r66D78QE8tvSsJDqwpTLVeo3OeAw6N4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e4Jx2vK0Ob8Ej1WoskjpKbtZII8y02zMxMwkOwPssFi59qdIhBgzW+iWQuVFgKNSb
         xA3+pqPFyhLXu9pT8FjqtXiv17WyqDa4DmU5lrYPpjx87m1typC2dFPJtB9axSDIFM
         IYBcSSGa1cidEjHRz+cIPnbOQGJdWLCh1p7X9FTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 4.19 35/62] bpf: Make sure mac_header was set before using it
Date:   Wed, 27 Jul 2022 18:10:44 +0200
Message-Id: <20220727161005.574695141@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161004.175638564@linuxfoundation.org>
References: <20220727161004.175638564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 0326195f523a549e0a9d7fd44c70b26fd7265090 upstream.

Classic BPF has a way to load bytes starting from the mac header.

Some skbs do not have a mac header, and skb_mac_header()
in this case is returning a pointer that 65535 bytes after
skb->head.

Existing range check in bpf_internal_load_pointer_neg_helper()
was properly kicking and no illegal access was happening.

New sanity check in skb_mac_header() is firing, so we need
to avoid it.

WARNING: CPU: 1 PID: 28990 at include/linux/skbuff.h:2785 skb_mac_header include/linux/skbuff.h:2785 [inline]
WARNING: CPU: 1 PID: 28990 at include/linux/skbuff.h:2785 bpf_internal_load_pointer_neg_helper+0x1b1/0x1c0 kernel/bpf/core.c:74
Modules linked in:
CPU: 1 PID: 28990 Comm: syz-executor.0 Not tainted 5.19.0-rc4-syzkaller-00865-g4874fb9484be #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
RIP: 0010:skb_mac_header include/linux/skbuff.h:2785 [inline]
RIP: 0010:bpf_internal_load_pointer_neg_helper+0x1b1/0x1c0 kernel/bpf/core.c:74
Code: ff ff 45 31 f6 e9 5a ff ff ff e8 aa 27 40 00 e9 3b ff ff ff e8 90 27 40 00 e9 df fe ff ff e8 86 27 40 00 eb 9e e8 2f 2c f3 ff <0f> 0b eb b1 e8 96 27 40 00 e9 79 fe ff ff 90 41 57 41 56 41 55 41
RSP: 0018:ffffc9000309f668 EFLAGS: 00010216
RAX: 0000000000000118 RBX: ffffffffffeff00c RCX: ffffc9000e417000
RDX: 0000000000040000 RSI: ffffffff81873f21 RDI: 0000000000000003
RBP: ffff8880842878c0 R08: 0000000000000003 R09: 000000000000ffff
R10: 000000000000ffff R11: 0000000000000001 R12: 0000000000000004
R13: ffff88803ac56c00 R14: 000000000000ffff R15: dffffc0000000000
FS: 00007f5c88a16700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdaa9f6c058 CR3: 000000003a82c000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
____bpf_skb_load_helper_32 net/core/filter.c:276 [inline]
bpf_skb_load_helper_32+0x191/0x220 net/core/filter.c:264

Fixes: f9aefd6b2aa3 ("net: warn if mac header was not set")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220707123900.945305-1-edumazet@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/core.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -66,11 +66,13 @@ void *bpf_internal_load_pointer_neg_help
 {
 	u8 *ptr = NULL;
 
-	if (k >= SKF_NET_OFF)
+	if (k >= SKF_NET_OFF) {
 		ptr = skb_network_header(skb) + k - SKF_NET_OFF;
-	else if (k >= SKF_LL_OFF)
+	} else if (k >= SKF_LL_OFF) {
+		if (unlikely(!skb_mac_header_was_set(skb)))
+			return NULL;
 		ptr = skb_mac_header(skb) + k - SKF_LL_OFF;
-
+	}
 	if (ptr >= skb->head && ptr + size <= skb_tail_pointer(skb))
 		return ptr;
 


