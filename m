Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8664586A67
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbiHAMQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234475AbiHAMP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:15:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298873E77E;
        Mon,  1 Aug 2022 04:58:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A257C601BD;
        Mon,  1 Aug 2022 11:58:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AABDDC433C1;
        Mon,  1 Aug 2022 11:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355116;
        bh=BQthgXHp2KBr8hYl964q2/BtVKsb92ooOktuAdYPSsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lcC2vh6FM95hZRTO6mrwpNp2T1g504ZR1VZUPWYlr6UHOZk5tVKtyB/sY3Fqy9TIz
         xsQaKUche6W1u9+ceoQxL/zj58ZEgSeQEQmHjfe6QqF/o78cj7A29iS6LTr47D5iGE
         5GJN86ywk2vQvP4SapSEERrnkuiEzBq8pdKJZGuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Domingo Dirutigliano <pwnzer0tt1@proton.me>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 69/88] netfilter: nf_queue: do not allow packet truncation below transport header offset
Date:   Mon,  1 Aug 2022 13:47:23 +0200
Message-Id: <20220801114141.198676600@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 99a63d36cb3ed5ca3aa6fcb64cffbeaf3b0fb164 ]

Domingo Dirutigliano and Nicola Guerrera report kernel panic when
sending nf_queue verdict with 1-byte nfta_payload attribute.

The IP/IPv6 stack pulls the IP(v6) header from the packet after the
input hook.

If user truncates the packet below the header size, this skb_pull() will
result in a malformed skb (skb->len < 0).

Fixes: 7af4cc3fa158 ("[NETFILTER]: Add "nfnetlink_queue" netfilter queue handler over nfnetlink")
Reported-by: Domingo Dirutigliano <pwnzer0tt1@proton.me>
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_queue.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index a364f8e5e698..87a9009d5234 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -843,11 +843,16 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 }
 
 static int
-nfqnl_mangle(void *data, int data_len, struct nf_queue_entry *e, int diff)
+nfqnl_mangle(void *data, unsigned int data_len, struct nf_queue_entry *e, int diff)
 {
 	struct sk_buff *nskb;
 
 	if (diff < 0) {
+		unsigned int min_len = skb_transport_offset(e->skb);
+
+		if (data_len < min_len)
+			return -EINVAL;
+
 		if (pskb_trim(e->skb, data_len))
 			return -ENOMEM;
 	} else if (diff > 0) {
-- 
2.35.1



