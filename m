Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF3E760FEEB
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237032AbiJ0RJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237101AbiJ0RJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:09:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F307626CB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:09:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91EA9623EE
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2269C433D7;
        Thu, 27 Oct 2022 17:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890582;
        bh=5yXhmI7VAaQGT5P9GY/SwufidOaLgBOvYDrhwUzw1PE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zvnmb6oiW3bvSYod91FdJNn/LBr+ZpBsE1Ls36L+Q6TeK43+5LfH4M47Z5KaA6uDy
         oRCyqc63+401mu9lX3pw33bJm+ETh2j0UcoFtWOE8Ot1dI8AuaCDG5ny+uszBNx2U1
         wxXgAcJ8a0Z5BOx4v+5+4bmZsHMPvwr+gvvkYtZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 45/53] net: sched: cake: fix null pointer access issue when cake_init() fails
Date:   Thu, 27 Oct 2022 18:56:33 +0200
Message-Id: <20221027165051.551273288@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
References: <20221027165049.817124510@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 51f9a8921ceacd7bf0d3f47fa867a64988ba1dcb ]

When the default qdisc is cake, if the qdisc of dev_queue fails to be
inited during mqprio_init(), cake_reset() is invoked to clear
resources. In this case, the tins is NULL, and it will cause gpf issue.

The process is as follows:
qdisc_create_dflt()
	cake_init()
		q->tins = kvcalloc(...)        --->failed, q->tins is NULL
	...
	qdisc_put()
		...
		cake_reset()
			...
			cake_dequeue_one()
				b = &q->tins[...]   --->q->tins is NULL

The following is the Call Trace information:
general protection fault, probably for non-canonical address
0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
RIP: 0010:cake_dequeue_one+0xc9/0x3c0
Call Trace:
<TASK>
cake_reset+0xb1/0x140
qdisc_reset+0xed/0x6f0
qdisc_destroy+0x82/0x4c0
qdisc_put+0x9e/0xb0
qdisc_create_dflt+0x2c3/0x4a0
mqprio_init+0xa71/0x1760
qdisc_create+0x3eb/0x1000
tc_modify_qdisc+0x408/0x1720
rtnetlink_rcv_msg+0x38e/0xac0
netlink_rcv_skb+0x12d/0x3a0
netlink_unicast+0x4a2/0x740
netlink_sendmsg+0x826/0xcc0
sock_sendmsg+0xc5/0x100
____sys_sendmsg+0x583/0x690
___sys_sendmsg+0xe8/0x160
__sys_sendmsg+0xbf/0x160
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f89e5122d04
</TASK>

Fixes: 046f6fd5daef ("sched: Add Common Applications Kept Enhanced (cake) qdisc")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cake.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 0eb4d4a568f7..9e5e7fda0f4a 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -2190,8 +2190,12 @@ static struct sk_buff *cake_dequeue(struct Qdisc *sch)
 
 static void cake_reset(struct Qdisc *sch)
 {
+	struct cake_sched_data *q = qdisc_priv(sch);
 	u32 c;
 
+	if (!q->tins)
+		return;
+
 	for (c = 0; c < CAKE_MAX_TINS; c++)
 		cake_clear_tin(sch, c);
 }
-- 
2.35.1



