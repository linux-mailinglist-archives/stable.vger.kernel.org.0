Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4CC360FE52
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236901AbiJ0REV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236906AbiJ0REU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:04:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372131974E4
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:04:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6A60B825F3
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACECC433C1;
        Thu, 27 Oct 2022 17:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890256;
        bh=NxCP5BEJq2MlcfDPOQlC1FC2jxFi5AFFMPnBTZqJkec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fxedvTo32HEtuRrIR265TY9qJykjCj0LF4JNxMjq5rJ3YkzePEA53tIyh1kmcW68I
         A66UQmWxwW27e4EQfUQCi9gLJOoVUSLyd6eDGOJef9LAPkhRXYmilMdKa5bu46yBaE
         XfF5J808P5yQYMFw0Vg7OGi7hlK7R0rBES4Dq0A8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 59/79] net: sched: sfb: fix null pointer access issue when sfb_init() fails
Date:   Thu, 27 Oct 2022 18:55:57 +0200
Message-Id: <20221027165056.880379973@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
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

[ Upstream commit 2a3fc78210b9f0e85372a2435368962009f480fc ]

When the default qdisc is sfb, if the qdisc of dev_queue fails to be
inited during mqprio_init(), sfb_reset() is invoked to clear resources.
In this case, the q->qdisc is NULL, and it will cause gpf issue.

The process is as follows:
qdisc_create_dflt()
	sfb_init()
		tcf_block_get()          --->failed, q->qdisc is NULL
	...
	qdisc_put()
		...
		sfb_reset()
			qdisc_reset(q->qdisc)    --->q->qdisc is NULL
				ops = qdisc->ops

The following is the Call Trace information:
general protection fault, probably for non-canonical address
0xdffffc0000000003: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
RIP: 0010:qdisc_reset+0x2b/0x6f0
Call Trace:
<TASK>
sfb_reset+0x37/0xd0
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
RIP: 0033:0x7f2164122d04
</TASK>

Fixes: e13e02a3c68d ("net_sched: SFB flow scheduler")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_sfb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 1be8d04d69dc..0490eb5b98de 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -455,7 +455,8 @@ static void sfb_reset(struct Qdisc *sch)
 {
 	struct sfb_sched_data *q = qdisc_priv(sch);
 
-	qdisc_reset(q->qdisc);
+	if (likely(q->qdisc))
+		qdisc_reset(q->qdisc);
 	q->slot = 0;
 	q->double_buffering = false;
 	sfb_zero_all_buckets(q);
-- 
2.35.1



