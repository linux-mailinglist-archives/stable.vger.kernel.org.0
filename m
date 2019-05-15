Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 653951F0DA
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbfEOLsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:48:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731765AbfEOLYK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:24:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68F29206BF;
        Wed, 15 May 2019 11:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919448;
        bh=CH0+JtbkQNQLC85ldheuVY08kzo49DZ/3EggvHzvjv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hEDdYn8bEqRqRjshNy93z4ZYe4qPt3knqM3PuD5R9HfqmHKrkr1w5rU34udQ701ZS
         R8OQWk0OpcOEVrz8A7Squ2lsNmxrdspI/CXAYYzQl5TUmDtxdg2yEFC8g9OgT2qg3Z
         34AsIDLZtpZuryUOvz37UtJiaMcCaDf+vTwSGC88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.19 078/113] net: strparser: partially revert "strparser: Call skb_unclone conditionally"
Date:   Wed, 15 May 2019 12:56:09 +0200
Message-Id: <20190515090659.530462851@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4a9c2e3746e6151fd5d077259d79ce9ca86d47d7 ]

This reverts the first part of commit 4e485d06bb8c ("strparser: Call
skb_unclone conditionally").  To build a message with multiple
fragments we need our own root of frag_list.  We can't simply
use the frag_list of orig_skb, because it will lead to linking
all orig_skbs together creating very long frag chains, and causing
stack overflow on kfree_skb() (which is called recursively on
the frag_lists).

BUG: stack guard page was hit at 00000000d40fad41 (stack is 0000000029dde9f4..000000008cce03d5)
kernel stack overflow (double-fault): 0000 [#1] PREEMPT SMP
RIP: 0010:free_one_page+0x2b/0x490

Call Trace:
  __free_pages_ok+0x143/0x2c0
  skb_release_data+0x8e/0x140
  ? skb_release_data+0xad/0x140
  kfree_skb+0x32/0xb0

  [...]

  skb_release_data+0xad/0x140
  ? skb_release_data+0xad/0x140
  kfree_skb+0x32/0xb0
  skb_release_data+0xad/0x140
  ? skb_release_data+0xad/0x140
  kfree_skb+0x32/0xb0
  skb_release_data+0xad/0x140
  ? skb_release_data+0xad/0x140
  kfree_skb+0x32/0xb0
  skb_release_data+0xad/0x140
  ? skb_release_data+0xad/0x140
  kfree_skb+0x32/0xb0
  skb_release_data+0xad/0x140
  __kfree_skb+0xe/0x20
  tcp_disconnect+0xd6/0x4d0
  tcp_close+0xf4/0x430
  ? tcp_check_oom+0xf0/0xf0
  tls_sk_proto_close+0xe4/0x1e0 [tls]
  inet_release+0x36/0x60
  __sock_release+0x37/0xa0
  sock_close+0x11/0x20
  __fput+0xa2/0x1d0
  task_work_run+0x89/0xb0
  exit_to_usermode_loop+0x9a/0xa0
  do_syscall_64+0xc0/0xf0
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Let's leave the second unclone conditional, as I'm not entirely
sure what is its purpose :)

Fixes: 4e485d06bb8c ("strparser: Call skb_unclone conditionally")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 net/strparser/strparser.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/strparser/strparser.c b/net/strparser/strparser.c
index da1a676860cad..0f4e427928781 100644
--- a/net/strparser/strparser.c
+++ b/net/strparser/strparser.c
@@ -140,13 +140,11 @@ static int __strp_recv(read_descriptor_t *desc, struct sk_buff *orig_skb,
 			/* We are going to append to the frags_list of head.
 			 * Need to unshare the frag_list.
 			 */
-			if (skb_has_frag_list(head)) {
-				err = skb_unclone(head, GFP_ATOMIC);
-				if (err) {
-					STRP_STATS_INCR(strp->stats.mem_fail);
-					desc->error = err;
-					return 0;
-				}
+			err = skb_unclone(head, GFP_ATOMIC);
+			if (err) {
+				STRP_STATS_INCR(strp->stats.mem_fail);
+				desc->error = err;
+				return 0;
 			}
 
 			if (unlikely(skb_shinfo(head)->frag_list)) {
-- 
2.20.1



