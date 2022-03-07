Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFA94CF83E
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238508AbiCGJwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:52:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239309AbiCGJta (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:49:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC83F2C11D;
        Mon,  7 Mar 2022 01:42:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D773160C7D;
        Mon,  7 Mar 2022 09:42:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCF5C340E9;
        Mon,  7 Mar 2022 09:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646168;
        bh=CwRWz1iT0e8U+3QDeSULEs/jxlFAROz4A7uwq2PHYqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWfALnZ0rhIik1kIBpAQ0ZCMpol63qZ+Pe37e/YRl3RAJV5kDRRxkGAnnDp1Ya+T5
         TiuBln/ksIbyqi0rH7vjGI/96J1gAXD3Cg2srpTpPlkUWS9fWOcl68PZOGiakuny8T
         KxTddlXacK4HEBB5gA0Vk7sKnHPvX+xcSAiJ1Fu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 155/262] bpf, sockmap: Do not ignore orig_len parameter
Date:   Mon,  7 Mar 2022 10:18:19 +0100
Message-Id: <20220307091706.810903558@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 60ce37b03917e593d8e5d8bcc7ec820773daf81d upstream.

Currently, sk_psock_verdict_recv() returns skb->len

This is problematic because tcp_read_sock() might have
passed orig_len < skb->len, due to the presence of TCP urgent data.

This causes an infinite loop from tcp_read_sock()

Followup patch will make tcp_read_sock() more robust vs bad actors.

Fixes: ef5659280eb1 ("bpf, sockmap: Allow skipping sk_skb parser program")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Tested-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20220302161723.3910001-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skmsg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1153,7 +1153,7 @@ static int sk_psock_verdict_recv(read_de
 	struct sk_psock *psock;
 	struct bpf_prog *prog;
 	int ret = __SK_DROP;
-	int len = skb->len;
+	int len = orig_len;
 
 	/* clone here so sk_eat_skb() in tcp_read_sock does not drop our data */
 	skb = skb_clone(skb, GFP_ATOMIC);


