Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4877368130D
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235998AbjA3O2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237716AbjA3O1a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:27:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6423A8C
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:26:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB5C1B811C7
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0B2C4339C;
        Mon, 30 Jan 2023 14:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088757;
        bh=82A5NxYoMy8hQMGvIa69v28WpoMI5DX2qkgAXOKUwFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OOqi4blXHHfKYN4x80ek0etpfYFf+OZq/Gx0eJec0+Xkr8FniY3Tgq+kykHTxIk/t
         lqhXpWI6LKk/+JbZ9An7qGSZ3Rtoh2y+xUVIfOe9GuHwkE+LhdgONIfmzdtPGXswPP
         6csfetO3ZrKHMU2t4Y4A491AksWuU3ZcL4tUa0qs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Westphal <fw@strlen.de>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 126/143] netfilter: conntrack: fix bug in for_each_sctp_chunk
Date:   Mon, 30 Jan 2023 14:53:03 +0100
Message-Id: <20230130134312.038406099@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sriram Yagnaraman <sriram.yagnaraman@est.tech>

[ Upstream commit 98ee0077452527f971567db01386de3c3d97ce13 ]

skb_header_pointer() will return NULL if offset + sizeof(_sch) exceeds
skb->len, so this offset < skb->len test is redundant.

if sch->length == 0, this will end up in an infinite loop, add a check
for sch->length > 0

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_sctp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 72d0aa603cd6..c0264bbc8466 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -155,8 +155,8 @@ static void sctp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
 
 #define for_each_sctp_chunk(skb, sch, _sch, offset, dataoff, count)	\
 for ((offset) = (dataoff) + sizeof(struct sctphdr), (count) = 0;	\
-	(offset) < (skb)->len &&					\
-	((sch) = skb_header_pointer((skb), (offset), sizeof(_sch), &(_sch)));	\
+	((sch) = skb_header_pointer((skb), (offset), sizeof(_sch), &(_sch))) &&	\
+	(sch)->length;	\
 	(offset) += (ntohs((sch)->length) + 3) & ~3, (count)++)
 
 /* Some validity checks to make sure the chunks are fine */
-- 
2.39.0



