Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C1D34C767
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbhC2IPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:15:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232221AbhC2INx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:13:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7F006044F;
        Mon, 29 Mar 2021 08:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005625;
        bh=ApNTptpCeJSpR+IMFXy3Wpu+mjjEIBV97QnZCV8cffA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X0caFywDQZffwcyRsR7f/pkiQEO6witD/fq5RyURz+LKTs0/B3ZwJcfXc48GU/q0P
         eK7Q3JxYRTfFLk8aMgdqLf2A8UJZUp9fy6sXk+wlGUWaBk+jZwyLwlLf2Ijs+Tg8VE
         R6IFBolipeNPMHFP8TJ3ndJLUmglW6QOKQUQwG5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/111] net: sched: validate stab values
Date:   Mon, 29 Mar 2021 09:58:07 +0200
Message-Id: <20210329075617.171315425@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e323d865b36134e8c5c82c834df89109a5c60dab ]

iproute2 package is well behaved, but malicious user space can
provide illegal shift values and trigger UBSAN reports.

Add stab parameter to red_check_params() to validate user input.

syzbot reported:

UBSAN: shift-out-of-bounds in ./include/net/red.h:312:18
shift exponent 111 is too large for 64-bit type 'long unsigned int'
CPU: 1 PID: 14662 Comm: syz-executor.3 Not tainted 5.12.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:327
 red_calc_qavg_from_idle_time include/net/red.h:312 [inline]
 red_calc_qavg include/net/red.h:353 [inline]
 choke_enqueue.cold+0x18/0x3dd net/sched/sch_choke.c:221
 __dev_xmit_skb net/core/dev.c:3837 [inline]
 __dev_queue_xmit+0x1943/0x2e00 net/core/dev.c:4150
 neigh_hh_output include/net/neighbour.h:499 [inline]
 neigh_output include/net/neighbour.h:508 [inline]
 ip6_finish_output2+0x911/0x1700 net/ipv6/ip6_output.c:117
 __ip6_finish_output net/ipv6/ip6_output.c:182 [inline]
 __ip6_finish_output+0x4c1/0xe10 net/ipv6/ip6_output.c:161
 ip6_finish_output+0x35/0x200 net/ipv6/ip6_output.c:192
 NF_HOOK_COND include/linux/netfilter.h:290 [inline]
 ip6_output+0x1e4/0x530 net/ipv6/ip6_output.c:215
 dst_output include/net/dst.h:448 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 NF_HOOK include/linux/netfilter.h:295 [inline]
 ip6_xmit+0x127e/0x1eb0 net/ipv6/ip6_output.c:320
 inet6_csk_xmit+0x358/0x630 net/ipv6/inet6_connection_sock.c:135
 dccp_transmit_skb+0x973/0x12c0 net/dccp/output.c:138
 dccp_send_reset+0x21b/0x2b0 net/dccp/output.c:535
 dccp_finish_passive_close net/dccp/proto.c:123 [inline]
 dccp_finish_passive_close+0xed/0x140 net/dccp/proto.c:118
 dccp_terminate_connection net/dccp/proto.c:958 [inline]
 dccp_close+0xb3c/0xe60 net/dccp/proto.c:1028
 inet_release+0x12e/0x280 net/ipv4/af_inet.c:431
 inet6_release+0x4c/0x70 net/ipv6/af_inet6.c:478
 __sock_release+0xcd/0x280 net/socket.c:599
 sock_close+0x18/0x20 net/socket.c:1258
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:140
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]

Fixes: 8afa10cbe281 ("net_sched: red: Avoid illegal values")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/red.h     | 10 +++++++++-
 net/sched/sch_choke.c |  7 ++++---
 net/sched/sch_gred.c  |  2 +-
 net/sched/sch_red.c   |  7 +++++--
 net/sched/sch_sfq.c   |  2 +-
 5 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/include/net/red.h b/include/net/red.h
index e21e7fd4fe07..8fe55b8b2fb8 100644
--- a/include/net/red.h
+++ b/include/net/red.h
@@ -168,7 +168,8 @@ static inline void red_set_vars(struct red_vars *v)
 	v->qcount	= -1;
 }
 
-static inline bool red_check_params(u32 qth_min, u32 qth_max, u8 Wlog, u8 Scell_log)
+static inline bool red_check_params(u32 qth_min, u32 qth_max, u8 Wlog,
+				    u8 Scell_log, u8 *stab)
 {
 	if (fls(qth_min) + Wlog > 32)
 		return false;
@@ -178,6 +179,13 @@ static inline bool red_check_params(u32 qth_min, u32 qth_max, u8 Wlog, u8 Scell_
 		return false;
 	if (qth_max < qth_min)
 		return false;
+	if (stab) {
+		int i;
+
+		for (i = 0; i < RED_STAB_SIZE; i++)
+			if (stab[i] >= 32)
+				return false;
+	}
 	return true;
 }
 
diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
index d856b395ee8e..e54f6eabfa0c 100644
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -351,6 +351,7 @@ static int choke_change(struct Qdisc *sch, struct nlattr *opt,
 	struct sk_buff **old = NULL;
 	unsigned int mask;
 	u32 max_P;
+	u8 *stab;
 
 	if (opt == NULL)
 		return -EINVAL;
@@ -367,8 +368,8 @@ static int choke_change(struct Qdisc *sch, struct nlattr *opt,
 	max_P = tb[TCA_CHOKE_MAX_P] ? nla_get_u32(tb[TCA_CHOKE_MAX_P]) : 0;
 
 	ctl = nla_data(tb[TCA_CHOKE_PARMS]);
-
-	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog, ctl->Scell_log))
+	stab = nla_data(tb[TCA_CHOKE_STAB]);
+	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog, ctl->Scell_log, stab))
 		return -EINVAL;
 
 	if (ctl->limit > CHOKE_MAX_QUEUE)
@@ -418,7 +419,7 @@ static int choke_change(struct Qdisc *sch, struct nlattr *opt,
 
 	red_set_parms(&q->parms, ctl->qth_min, ctl->qth_max, ctl->Wlog,
 		      ctl->Plog, ctl->Scell_log,
-		      nla_data(tb[TCA_CHOKE_STAB]),
+		      stab,
 		      max_P);
 	red_set_vars(&q->vars);
 
diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index e0bc77533acc..f4132dc25ac0 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -480,7 +480,7 @@ static inline int gred_change_vq(struct Qdisc *sch, int dp,
 	struct gred_sched *table = qdisc_priv(sch);
 	struct gred_sched_data *q = table->tab[dp];
 
-	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog, ctl->Scell_log)) {
+	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog, ctl->Scell_log, stab)) {
 		NL_SET_ERR_MSG_MOD(extack, "invalid RED parameters");
 		return -EINVAL;
 	}
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 71e167e91a48..7741f102be4a 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -197,6 +197,7 @@ static int red_change(struct Qdisc *sch, struct nlattr *opt,
 	struct tc_red_qopt *ctl;
 	int err;
 	u32 max_P;
+	u8 *stab;
 
 	if (opt == NULL)
 		return -EINVAL;
@@ -213,7 +214,9 @@ static int red_change(struct Qdisc *sch, struct nlattr *opt,
 	max_P = tb[TCA_RED_MAX_P] ? nla_get_u32(tb[TCA_RED_MAX_P]) : 0;
 
 	ctl = nla_data(tb[TCA_RED_PARMS]);
-	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog, ctl->Scell_log))
+	stab = nla_data(tb[TCA_RED_STAB]);
+	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog,
+			      ctl->Scell_log, stab))
 		return -EINVAL;
 
 	if (ctl->limit > 0) {
@@ -238,7 +241,7 @@ static int red_change(struct Qdisc *sch, struct nlattr *opt,
 	red_set_parms(&q->parms,
 		      ctl->qth_min, ctl->qth_max, ctl->Wlog,
 		      ctl->Plog, ctl->Scell_log,
-		      nla_data(tb[TCA_RED_STAB]),
+		      stab,
 		      max_P);
 	red_set_vars(&q->vars);
 
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index 6e13e137883c..b92bafaf83f3 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -647,7 +647,7 @@ static int sfq_change(struct Qdisc *sch, struct nlattr *opt)
 	}
 
 	if (ctl_v1 && !red_check_params(ctl_v1->qth_min, ctl_v1->qth_max,
-					ctl_v1->Wlog, ctl_v1->Scell_log))
+					ctl_v1->Wlog, ctl_v1->Scell_log, NULL))
 		return -EINVAL;
 	if (ctl_v1 && ctl_v1->qth_min) {
 		p = kmalloc(sizeof(*p), GFP_KERNEL);
-- 
2.30.1



