Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB72A2E6546
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393374AbgL1P7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:59:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:33210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387872AbgL1NdR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:33:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF9BB20719;
        Mon, 28 Dec 2020 13:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162381;
        bh=UMXkwslyLVfcryHjAFU9fO2o4UZAqlRGery9h4JDerM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uqmM6aTkuj+NH3n5qPeEEzgpK2omYdRbYJQtj84udJJ3r6uK7CK9w8hqdcqEi5j2I
         frDFMLHYX9y7Z7sFtUb8dXtCp+/je6a6ajK4eQBIelQxcsJqsosf8CGdyuUFukd04k
         riP8wcFmJfxmj6l7xW4hil0yQth6WXd25xWB2X0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 255/346] lwt: Disable BH too in run_lwt_bpf()
Date:   Mon, 28 Dec 2020 13:49:34 +0100
Message-Id: <20201228124932.111669638@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index a648568c5e8fe..4a5f4fbffd836 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -44,12 +44,11 @@ static int run_lwt_bpf(struct sk_buff *skb, struct bpf_lwt_prog *lwt,
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
 
@@ -82,6 +81,7 @@ static int run_lwt_bpf(struct sk_buff *skb, struct bpf_lwt_prog *lwt,
 		break;
 	}
 
+	local_bh_enable();
 	preempt_enable();
 
 	return ret;
-- 
2.27.0



