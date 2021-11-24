Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6CEB45BBFD
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245373AbhKXMZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:25:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:38292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242538AbhKXMWV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:22:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AB5A611CB;
        Wed, 24 Nov 2021 12:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756011;
        bh=eP+XAVhoBv+fgBOZ2IP1U7kHldAA1dksvXiLYs0Jna8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tr6IdL3xVoZoWRs3tdsSjbNNDSHju+V28teb3rV4i7hTm3ybJ1R94Fapv50M8QjwO
         twrHS4fM3KOuCZs63tmkt7j0zKG4Jh0SNYSWOeowkn+kW3ksUJME7cResgV64Cn4Xy
         Rzh0Uca0AzlQBTBKS3CDyu+6isoYF0Yq87mg9rO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 138/207] netfilter: nfnetlink_queue: fix OOB when mac header was cleared
Date:   Wed, 24 Nov 2021 12:56:49 +0100
Message-Id: <20211124115708.496021239@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
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
index 2a811b5634d46..a35510565d4d1 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -539,7 +539,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 		goto nla_put_failure;
 
 	if (indev && entskb->dev &&
-	    entskb->mac_header != entskb->network_header) {
+	    skb_mac_header_was_set(entskb)) {
 		struct nfqnl_msg_packet_hw phw;
 		int len;
 
-- 
2.33.0



