Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C732E42F5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407150AbgL1Nwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:52:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:54562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407145AbgL1Nwi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:52:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 048D322B45;
        Mon, 28 Dec 2020 13:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163517;
        bh=PMqsHKAoq0iT55G2tvZrvS+C7JQ3NJ2UIXWTLjRc8yI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aozkWLxfRt5Oo8htq8xYARU9ltmP4GwjZy5qcL4KiG4GVSMlvriomXeVeo4jVZe5v
         myfDY+udS7f5LN5eI3FXFpUs/77PjzRzF3JGONQADXyuv0DES473K3rzs38Itm4kuV
         uL0P9sO4AlK+Y6lY4AHpYUsOsfRqS2lHyGWJ6LSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 314/453] lwt: Disable BH too in run_lwt_bpf()
Date:   Mon, 28 Dec 2020 13:49:10 +0100
Message-Id: <20201228124952.318239146@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongdong Wang <wangdongdong.6@bytedance.com>

[ Upstream commit d9054a1ff585ba01029584ab730efc794603d68f ]

The per-cpu bpf_redirect_info is shared among all skb_do_redirect()
and BPF redirect helpers. Callers on RX path are all in BH context,
disabling preemption is not sufficient to prevent BH interruption.

In production, we observed strange packet drops because of the race
condition between LWT xmit and TC ingress, and we verified this issue
is fixed after we disable BH.

Although this bug was technically introduced from the beginning, that
is commit 3a0af8fd61f9 ("bpf: BPF for lightweight tunnel infrastructure"),
at that time call_rcu() had to be call_rcu_bh() to match the RCU context.
So this patch may not work well before RCU flavor consolidation has been
completed around v5.0.

Update the comments above the code too, as call_rcu() is now BH friendly.

Signed-off-by: Dongdong Wang <wangdongdong.6@bytedance.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Link: https://lore.kernel.org/bpf/20201205075946.497763-1-xiyou.wangcong@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/lwt_bpf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index 99a6de52b21da..a5502c5aa44e7 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -39,12 +39,11 @@ static int run_lwt_bpf(struct sk_buff *skb, struct bpf_lwt_prog *lwt,
 {
 	int ret;
 
-	/* Preempt disable is needed to protect per-cpu redirect_info between
-	 * BPF prog and skb_do_redirect(). The call_rcu in bpf_prog_put() and
-	 * access to maps strictly require a rcu_read_lock() for protection,
-	 * mixing with BH RCU lock doesn't work.
+	/* Preempt disable and BH disable are needed to protect per-cpu
+	 * redirect_info between BPF prog and skb_do_redirect().
 	 */
 	preempt_disable();
+	local_bh_disable();
 	bpf_compute_data_pointers(skb);
 	ret = bpf_prog_run_save_cb(lwt->prog, skb);
 
@@ -78,6 +77,7 @@ static int run_lwt_bpf(struct sk_buff *skb, struct bpf_lwt_prog *lwt,
 		break;
 	}
 
+	local_bh_enable();
 	preempt_enable();
 
 	return ret;
-- 
2.27.0



