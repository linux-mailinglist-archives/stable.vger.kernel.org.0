Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 364497991B
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387396AbfG2TaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:30:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388072AbfG2TaH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:30:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18A0F2070B;
        Mon, 29 Jul 2019 19:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428606;
        bh=QRFJk2Cs9CtvaTS/cAOmN4Jgy3mHSXjz53+tvakQ11c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QlNQrfJo/pjyoU6X1qBX/Yn/bcm62dBh1abpJ/jmDYAbne/bP9n4Czf/df9jTtKHn
         929ygVapHhTxSU2qnnjJgDcmu9zNKvHGv5W0hTyOiKICz1vgcy6ZjIEQDoDWlqZCct
         sObAB+kI6L6nFB4TlJ4exS5vuYfSFfGtes90Fp94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 102/293] gtp: fix Illegal context switch in RCU read-side critical section.
Date:   Mon, 29 Jul 2019 21:19:53 +0200
Message-Id: <20190729190832.456484955@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3f167e1921865b379a9becf03828e7202c7b4917 ]

ipv4_pdp_add() is called in RCU read-side critical section.
So GFP_KERNEL should not be used in the function.
This patch make ipv4_pdp_add() to use GFP_ATOMIC instead of GFP_KERNEL.

Test commands:
gtp-link add gtp1 &
gtp-tunnel add gtp1 v1 100 200 1.1.1.1 2.2.2.2

Splat looks like:
[  130.618881] =============================
[  130.626382] WARNING: suspicious RCU usage
[  130.626994] 5.2.0-rc6+ #50 Not tainted
[  130.627622] -----------------------------
[  130.628223] ./include/linux/rcupdate.h:266 Illegal context switch in RCU read-side critical section!
[  130.629684]
[  130.629684] other info that might help us debug this:
[  130.629684]
[  130.631022]
[  130.631022] rcu_scheduler_active = 2, debug_locks = 1
[  130.632136] 4 locks held by gtp-tunnel/1025:
[  130.632925]  #0: 000000002b93c8b7 (cb_lock){++++}, at: genl_rcv+0x15/0x40
[  130.634159]  #1: 00000000f17bc999 (genl_mutex){+.+.}, at: genl_rcv_msg+0xfb/0x130
[  130.635487]  #2: 00000000c644ed8e (rtnl_mutex){+.+.}, at: gtp_genl_new_pdp+0x18c/0x1150 [gtp]
[  130.636936]  #3: 0000000007a1cde7 (rcu_read_lock){....}, at: gtp_genl_new_pdp+0x187/0x1150 [gtp]
[  130.638348]
[  130.638348] stack backtrace:
[  130.639062] CPU: 1 PID: 1025 Comm: gtp-tunnel Not tainted 5.2.0-rc6+ #50
[  130.641318] Call Trace:
[  130.641707]  dump_stack+0x7c/0xbb
[  130.642252]  ___might_sleep+0x2c0/0x3b0
[  130.642862]  kmem_cache_alloc_trace+0x1cd/0x2b0
[  130.643591]  gtp_genl_new_pdp+0x6c5/0x1150 [gtp]
[  130.644371]  genl_family_rcv_msg+0x63a/0x1030
[  130.645074]  ? mutex_lock_io_nested+0x1090/0x1090
[  130.645845]  ? genl_unregister_family+0x630/0x630
[  130.646592]  ? debug_show_all_locks+0x2d0/0x2d0
[  130.647293]  ? check_flags.part.40+0x440/0x440
[  130.648099]  genl_rcv_msg+0xa3/0x130
[ ... ]

Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 2756edd84abc..c751f87c935e 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -956,7 +956,7 @@ static int ipv4_pdp_add(struct gtp_dev *gtp, struct sock *sk,
 
 	}
 
-	pctx = kmalloc(sizeof(struct pdp_ctx), GFP_KERNEL);
+	pctx = kmalloc(sizeof(*pctx), GFP_ATOMIC);
 	if (pctx == NULL)
 		return -ENOMEM;
 
-- 
2.20.1



