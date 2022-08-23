Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A5859D3B0
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242096AbiHWIMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241997AbiHWIK1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:10:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522FF66A4C;
        Tue, 23 Aug 2022 01:06:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED5EBB81C20;
        Tue, 23 Aug 2022 08:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C48C433D6;
        Tue, 23 Aug 2022 08:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242012;
        bh=oVWkrboSkv9Bnu5R4qvw2tZvMFAhnopG10Deyehvyss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tGalO4DRbtG+fp27SwhzI5kz7QvXz6At3RvoOPAgvJvn4uysBWULP9SackP5nF0bT
         f+4qDKxPhjM54Uum7Lif1WAkOBIv7y+jubYS2/qGUPlfLVSkGufBNIR2I6/rb8dixK
         Dzy4rIBUZSEdx2QNMFeIpI8gHEinBvoGEXCyFur8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Domingo Dirutigliano <pwnzer0tt1@proton.me>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 006/101] netfilter: nf_queue: do not allow packet truncation below transport header offset
Date:   Tue, 23 Aug 2022 10:02:39 +0200
Message-Id: <20220823080034.838634482@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 66814a9d030c..80715b495d7c 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -807,11 +807,16 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
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



