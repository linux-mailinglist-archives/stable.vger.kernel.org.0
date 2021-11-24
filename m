Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4181B45BA35
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242136AbhKXMIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:08:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:33756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242192AbhKXMHO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:07:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9586E60FDC;
        Wed, 24 Nov 2021 12:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755444;
        bh=KyW7crzrVrqvRmbhXQIgdKWJlDSao/SrdGLrlS6v1q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TgIp4hkqcdUQPMKDIDNYc2b63GH7ItIhzfAGNWM4wSazulu5SfmWPLM5feeGsA6fV
         xWibAdmlMnzGcHwYAvAgU1ENrdhlmUeakR/8ZxwKtZRgckYIYafqcCUMNXIX6s7/H3
         4FfjqW/L1GU6zmWxnRpDSV/S4Nfxt29HsOjnHlLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 099/162] netfilter: nfnetlink_queue: fix OOB when mac header was cleared
Date:   Wed, 24 Nov 2021 12:56:42 +0100
Message-Id: <20211124115701.523686982@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 5648b5e1169ff1d6d6a46c35c0b5fbebd2a5cbb2 ]

On 64bit platforms the MAC header is set to 0xffff on allocation and
also when a helper like skb_unset_mac_header() is called.

dev_parse_header may call skb_mac_header() which assumes valid mac offset:

 BUG: KASAN: use-after-free in eth_header_parse+0x75/0x90
 Read of size 6 at addr ffff8881075a5c05 by task nf-queue/1364
 Call Trace:
  memcpy+0x20/0x60
  eth_header_parse+0x75/0x90
  __nfqnl_enqueue_packet+0x1a61/0x3380
  __nf_queue+0x597/0x1300
  nf_queue+0xf/0x40
  nf_hook_slow+0xed/0x190
  nf_hook+0x184/0x440
  ip_output+0x1c0/0x2a0
  nf_reinject+0x26f/0x700
  nfqnl_recv_verdict+0xa16/0x18b0
  nfnetlink_rcv_msg+0x506/0xe70

The existing code only works if the skb has a mac header.

Fixes: 2c38de4c1f8da7 ("netfilter: fix looped (broad|multi)cast's MAC handling")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 54cde78c27183..ebce25080f7ff 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -486,7 +486,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 		goto nla_put_failure;
 
 	if (indev && entskb->dev &&
-	    entskb->mac_header != entskb->network_header) {
+	    skb_mac_header_was_set(entskb)) {
 		struct nfqnl_msg_packet_hw phw;
 		int len;
 
-- 
2.33.0



