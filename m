Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF9705869B8
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbiHAMGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbiHAMFZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:05:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E4C5A3C6;
        Mon,  1 Aug 2022 04:54:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 40812CE1157;
        Mon,  1 Aug 2022 11:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B51C433C1;
        Mon,  1 Aug 2022 11:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354888;
        bh=COGnvKI3TA8NxmZ6PUaCgjEEP6RaalfNvTdWi+lFvrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k1a/wB85YDuEC123SWDy94T1LyFTFSiJMwgbKJnxCbdjW/wWMu0GfCIY9joljF5QL
         T3SWLsFaspnYL5c7BqpD8BOjsU/k+hkBIi2X5KSvD6q8e6h424gALJbzApEGNukpWD
         mDKSzr3SM/p2Gx4PeBTW98ZsFBM9ZmjUuZy795Hs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Domingo Dirutigliano <pwnzer0tt1@proton.me>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 57/69] netfilter: nf_queue: do not allow packet truncation below transport header offset
Date:   Mon,  1 Aug 2022 13:47:21 +0200
Message-Id: <20220801114136.780889603@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
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
index 8787d0613ad8..5329ebf19a18 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -836,11 +836,16 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
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



