Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939D142DCDB
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbhJNPC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:02:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233006AbhJNPBC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:01:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D21A9610F8;
        Thu, 14 Oct 2021 14:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223515;
        bh=bDXQNlbAoGWxAmbvsQuCfXICV80f2GxWExa41GXwmzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBxlcRSCtpfqzuHZuHBYgoqHIy9BdVKdBkyYAN+VAsHGNE0rRJBo7U1IY16r4p1Zf
         98yWD6gOkJvq+vv+ovU9WQF0A+r+GeANNmtx06In/rr6OFQvdh4B1FFPx0aL09i1qI
         50cn3wzDreV7P/bk/C3I90rX/7z8OvdpuDhyC4+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci <abaci@linux.alibaba.com>,
        Michael Wang <yun.wang@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/12] net: prevent user from passing illegal stab size
Date:   Thu, 14 Oct 2021 16:54:06 +0200
Message-Id: <20211014145206.764884910@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145206.566123760@linuxfoundation.org>
References: <20211014145206.566123760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: 王贇 <yun.wang@linux.alibaba.com>

[ Upstream commit b193e15ac69d56f35e1d8e2b5d16cbd47764d053 ]

We observed below report when playing with netlink sock:

  UBSAN: shift-out-of-bounds in net/sched/sch_api.c:580:10
  shift exponent 249 is too large for 32-bit type
  CPU: 0 PID: 685 Comm: a.out Not tainted
  Call Trace:
   dump_stack_lvl+0x8d/0xcf
   ubsan_epilogue+0xa/0x4e
   __ubsan_handle_shift_out_of_bounds+0x161/0x182
   __qdisc_calculate_pkt_len+0xf0/0x190
   __dev_queue_xmit+0x2ed/0x15b0

it seems like kernel won't check the stab log value passing from
user, and will use the insane value later to calculate pkt_len.

This patch just add a check on the size/cell_log to avoid insane
calculation.

Reported-by: Abaci <abaci@linux.alibaba.com>
Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/pkt_sched.h | 1 +
 net/sched/sch_api.c     | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 5e99771a5dcc..edca90ef3bdc 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -11,6 +11,7 @@
 #include <uapi/linux/pkt_sched.h>
 
 #define DEFAULT_TX_QUEUE_LEN	1000
+#define STAB_SIZE_LOG_MAX	30
 
 struct qdisc_walker {
 	int	stop;
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 1f12be9f0207..0bb4f7a94a3c 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -498,6 +498,12 @@ static struct qdisc_size_table *qdisc_get_stab(struct nlattr *opt,
 		return stab;
 	}
 
+	if (s->size_log > STAB_SIZE_LOG_MAX ||
+	    s->cell_log > STAB_SIZE_LOG_MAX) {
+		NL_SET_ERR_MSG(extack, "Invalid logarithmic size of size table");
+		return ERR_PTR(-EINVAL);
+	}
+
 	stab = kmalloc(sizeof(*stab) + tsize * sizeof(u16), GFP_KERNEL);
 	if (!stab)
 		return ERR_PTR(-ENOMEM);
-- 
2.33.0



