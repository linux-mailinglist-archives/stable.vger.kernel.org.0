Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC004395D83
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhEaNrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:47:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232715AbhEaNo7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:44:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96AF3613AE;
        Mon, 31 May 2021 13:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467774;
        bh=cAYGS2+nupkvSTCpDBDqDlbN5o4DvTY6MTgqxIw3/4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CgpWVF0ga+h4LpiPINaWMMfJ0NRhhe8zzFrBu+fTi3RvF9uE7oNYIQQw04H6HYCu1
         /l9V2550RjHUkEkTPb+AKCazsHniGmyOPvYjGwjIsG4L0KTUAg0JH1iDs6kzXbxvKO
         QC2QvnHDflarswcdGVSRZSND5GyMA8q9QS2szsk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 74/79] sch_dsmark: fix a NULL deref in qdisc_reset()
Date:   Mon, 31 May 2021 15:14:59 +0200
Message-Id: <20210531130638.362287296@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.002722319@linuxfoundation.org>
References: <20210531130636.002722319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 9b76eade16423ef06829cccfe3e100cfce31afcd ]

If Qdisc_ops->init() is failed, Qdisc_ops->reset() would be called.
When dsmark_init(Qdisc_ops->init()) is failed, it possibly doesn't
initialize dsmark_qdisc_data->q. But dsmark_reset(Qdisc_ops->reset())
uses dsmark_qdisc_data->q pointer wihtout any null checking.
So, panic would occur.

Test commands:
    sysctl net.core.default_qdisc=dsmark -w
    ip link add dummy0 type dummy
    ip link add vw0 link dummy0 type virt_wifi
    ip link set vw0 up

Splat looks like:
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 3 PID: 684 Comm: ip Not tainted 5.12.0+ #910
RIP: 0010:qdisc_reset+0x2b/0x680
Code: 1f 44 00 00 48 b8 00 00 00 00 00 fc ff df 41 57 41 56 41 55 41 54
55 48 89 fd 48 83 c7 18 53 48 89 fa 48 c1 ea 03 48 83 ec 20 <80> 3c 02
00 0f 85 09 06 00 00 4c 8b 65 18 0f 1f 44 00 00 65 8b 1d
RSP: 0018:ffff88800fda6bf8 EFLAGS: 00010282
RAX: dffffc0000000000 RBX: ffff8880050ed800 RCX: 0000000000000000
RDX: 0000000000000003 RSI: ffffffff99e34100 RDI: 0000000000000018
RBP: 0000000000000000 R08: fffffbfff346b553 R09: fffffbfff346b553
R10: 0000000000000001 R11: fffffbfff346b552 R12: ffffffffc0824940
R13: ffff888109e83800 R14: 00000000ffffffff R15: ffffffffc08249e0
FS:  00007f5042287680(0000) GS:ffff888119800000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055ae1f4dbd90 CR3: 0000000006760002 CR4: 00000000003706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ? rcu_read_lock_bh_held+0xa0/0xa0
 dsmark_reset+0x3d/0xf0 [sch_dsmark]
 qdisc_reset+0xa9/0x680
 qdisc_destroy+0x84/0x370
 qdisc_create_dflt+0x1fe/0x380
 attach_one_default_qdisc.constprop.41+0xa4/0x180
 dev_activate+0x4d5/0x8c0
 ? __dev_open+0x268/0x390
 __dev_open+0x270/0x390

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_dsmark.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_dsmark.c b/net/sched/sch_dsmark.c
index b507a72d5813..b972d50828ca 100644
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -397,7 +397,8 @@ static void dsmark_reset(struct Qdisc *sch)
 	struct dsmark_qdisc_data *p = qdisc_priv(sch);
 
 	pr_debug("%s(sch %p,[qdisc %p])\n", __func__, sch, p);
-	qdisc_reset(p->q);
+	if (p->q)
+		qdisc_reset(p->q);
 	sch->qstats.backlog = 0;
 	sch->q.qlen = 0;
 }
-- 
2.30.2



