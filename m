Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750AD60FDDD
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236728AbiJ0Q7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236733AbiJ0Q7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:59:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D318240A1
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:59:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4C78B82714
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49727C433D6;
        Thu, 27 Oct 2022 16:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889985;
        bh=MrgFugIZrCgeHHpAwNEX8zHL6Klgp2fCY4TSYfDCAdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bwELJW8O0BS+F1DoPWCuO3I3dVGhO2/TapT6Wst8191JP9m73wyheZuYwnl46TtdZ
         LiPZiAAMKA0RC9IS+nYqawYVyx81pyNZYvcUHExEK4Kzf/VSZ476R0nAL0bDfdcxLA
         Wg/98u8Bb7ZeVP2ul/GeDvcs/F/MSThPSbeDDLWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 74/94] net: sched: cake: fix null pointer access issue when cake_init() fails
Date:   Thu, 27 Oct 2022 18:55:16 +0200
Message-Id: <20221027165100.188613839@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
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
index a43a58a73d09..9530d65e6002 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -2224,8 +2224,12 @@ static struct sk_buff *cake_dequeue(struct Qdisc *sch)
 
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



