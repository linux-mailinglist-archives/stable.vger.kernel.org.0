Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 875B642DD59
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbhJNPGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:06:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233709AbhJNPEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:04:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1FCB611C1;
        Thu, 14 Oct 2021 15:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223659;
        bh=OTrccWwKPffRiq3S6lIt8TgRqj+9/RN0ax0h0LgFrls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EgVgNH3QHXz2gooycYsGA+Agq+86CRCwMpQhGP3bKF8gmAOryIip1kE1qdj6w17y1
         xXf5JiV4UCBAEn1391nUE3Ppj6CVRGjK3o5bqP8+JgFo1XQOR3hXQenBIkJ/QC6XY4
         4CngSQoSsSL3iXU77YuOq2r5jbVoWNaxg7owvClc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci <abaci@linux.alibaba.com>,
        Michael Wang <yun.wang@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 18/30] net: prevent user from passing illegal stab size
Date:   Thu, 14 Oct 2021 16:54:23 +0200
Message-Id: <20211014145210.126140061@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145209.520017940@linuxfoundation.org>
References: <20211014145209.520017940@linuxfoundation.org>
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
index 6d7b12cba015..bf79f3a890af 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -11,6 +11,7 @@
 #include <uapi/linux/pkt_sched.h>
 
 #define DEFAULT_TX_QUEUE_LEN	1000
+#define STAB_SIZE_LOG_MAX	30
 
 struct qdisc_walker {
 	int	stop;
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index f87d07736a14..148edd0e71e3 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -513,6 +513,12 @@ static struct qdisc_size_table *qdisc_get_stab(struct nlattr *opt,
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



