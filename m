Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBAE43A23E
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbhJYTrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:47:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236658AbhJYTpA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:45:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65D0960FE8;
        Mon, 25 Oct 2021 19:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190735;
        bh=rOKT46R8nlrWPIv3/unPX30Wj7vV5fuFnqLtSGKAk3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iizsq3K4hz53sUazOFg9Utx1sckYtgalQs4kIlk3uz6uzaeV5dKwEIt/riz4MLYk+
         Kxx7qfUl87nvoapljfjLv06MGsxxQVXN3NIxbkixFW2AS0Mb8r9Tn5yMFCRY5m1BfH
         c1wbJdUZoZJOHd3eEo0s7728fMfdcrSn7hOJtCwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 040/169] net/sched: act_ct: Fix byte count on fragmented packets
Date:   Mon, 25 Oct 2021 21:13:41 +0200
Message-Id: <20211025191022.912740631@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

[ Upstream commit 2dc4e9e88cfcc38454d52b01ed3422238c134003 ]

First fragmented packets (frag offset = 0) byte len is zeroed
when stolen by ip_defrag(). And since act_ct update the stats
only afterwards (at end of execute), bytes aren't correctly
accounted for such packets.

To fix this, move stats update to start of action execute.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 1b4b3514c94f..07f4dce7b535 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -960,6 +960,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	tmpl = p->tmpl;
 
 	tcf_lastuse_update(&c->tcf_tm);
+	tcf_action_update_bstats(&c->common, skb);
 
 	if (clear) {
 		qdisc_skb_cb(skb)->post_ct = false;
@@ -1049,7 +1050,6 @@ out_push:
 
 	qdisc_skb_cb(skb)->post_ct = true;
 out_clear:
-	tcf_action_update_bstats(&c->common, skb);
 	if (defrag)
 		qdisc_skb_cb(skb)->pkt_len = skb->len;
 	return retval;
-- 
2.33.0



