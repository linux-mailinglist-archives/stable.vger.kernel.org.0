Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0B25EA59C
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235342AbiIZMJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235281AbiIZMIH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:08:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AD47F27C;
        Mon, 26 Sep 2022 03:56:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC813B8091E;
        Mon, 26 Sep 2022 10:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5108AC433C1;
        Mon, 26 Sep 2022 10:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189300;
        bh=K/J5kmBBdxyWkb12VWV3kp/bZF5jclV6AW4g+Hsj/jY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nwMEdhd14B8lGPHR1LK3a69DG5yCc0XqHJjXCHgEl0z3hyVqN7ZuHKM3upn3Sepya
         THQIXu414XlBjmapueZBrIdBdGCw5pFz0FLxMT/lpH6ZsxX27F2uqswaufLAKv4xwo
         LTx3ZWfCY++fTVW3cZfL5ZjJ2XvEndLPrn8GQxT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 133/207] net/sched: taprio: avoid disabling offload when it was never enabled
Date:   Mon, 26 Sep 2022 12:12:02 +0200
Message-Id: <20220926100812.477600795@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit db46e3a88a09c5cf7e505664d01da7238cd56c92 ]

In an incredibly strange API design decision, qdisc->destroy() gets
called even if qdisc->init() never succeeded, not exclusively since
commit 87b60cfacf9f ("net_sched: fix error recovery at qdisc creation"),
but apparently also earlier (in the case of qdisc_create_dflt()).

The taprio qdisc does not fully acknowledge this when it attempts full
offload, because it starts off with q->flags = TAPRIO_FLAGS_INVALID in
taprio_init(), then it replaces q->flags with TCA_TAPRIO_ATTR_FLAGS
parsed from netlink (in taprio_change(), tail called from taprio_init()).

But in taprio_destroy(), we call taprio_disable_offload(), and this
determines what to do based on FULL_OFFLOAD_IS_ENABLED(q->flags).

But looking at the implementation of FULL_OFFLOAD_IS_ENABLED()
(a bitwise check of bit 1 in q->flags), it is invalid to call this macro
on q->flags when it contains TAPRIO_FLAGS_INVALID, because that is set
to U32_MAX, and therefore FULL_OFFLOAD_IS_ENABLED() will return true on
an invalid set of flags.

As a result, it is possible to crash the kernel if user space forces an
error between setting q->flags = TAPRIO_FLAGS_INVALID, and the calling
of taprio_enable_offload(). This is because drivers do not expect the
offload to be disabled when it was never enabled.

The error that we force here is to attach taprio as a non-root qdisc,
but instead as child of an mqprio root qdisc:

$ tc qdisc add dev swp0 root handle 1: \
	mqprio num_tc 8 map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 0
$ tc qdisc replace dev swp0 parent 1:1 \
	taprio num_tc 8 map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 base-time 0 \
	sched-entry S 0x7f 990000 sched-entry S 0x80 100000 \
	flags 0x0 clockid CLOCK_TAI
Unable to handle kernel paging request at virtual address fffffffffffffff8
[fffffffffffffff8] pgd=0000000000000000, p4d=0000000000000000
Internal error: Oops: 96000004 [#1] PREEMPT SMP
Call trace:
 taprio_dump+0x27c/0x310
 vsc9959_port_setup_tc+0x1f4/0x460
 felix_port_setup_tc+0x24/0x3c
 dsa_slave_setup_tc+0x54/0x27c
 taprio_disable_offload.isra.0+0x58/0xe0
 taprio_destroy+0x80/0x104
 qdisc_create+0x240/0x470
 tc_modify_qdisc+0x1fc/0x6b0
 rtnetlink_rcv_msg+0x12c/0x390
 netlink_rcv_skb+0x5c/0x130
 rtnetlink_rcv+0x1c/0x2c

Fix this by keeping track of the operations we made, and undo the
offload only if we actually did it.

I've added "bool offloaded" inside a 4 byte hole between "int clockid"
and "atomic64_t picos_per_byte". Now the first cache line looks like
below:

$ pahole -C taprio_sched net/sched/sch_taprio.o
struct taprio_sched {
        struct Qdisc * *           qdiscs;               /*     0     8 */
        struct Qdisc *             root;                 /*     8     8 */
        u32                        flags;                /*    16     4 */
        enum tk_offsets            tk_offset;            /*    20     4 */
        int                        clockid;              /*    24     4 */
        bool                       offloaded;            /*    28     1 */

        /* XXX 3 bytes hole, try to pack */

        atomic64_t                 picos_per_byte;       /*    32     0 */

        /* XXX 8 bytes hole, try to pack */

        spinlock_t                 current_entry_lock;   /*    40     0 */

        /* XXX 8 bytes hole, try to pack */

        struct sched_entry *       current_entry;        /*    48     8 */
        struct sched_gate_list *   oper_sched;           /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */

Fixes: 9c66d1564676 ("taprio: Add support for hardware offloading")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 0b941dd63d26..9bec73019f94 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -67,6 +67,7 @@ struct taprio_sched {
 	u32 flags;
 	enum tk_offsets tk_offset;
 	int clockid;
+	bool offloaded;
 	atomic64_t picos_per_byte; /* Using picoseconds because for 10Gbps+
 				    * speeds it's sub-nanoseconds per byte
 				    */
@@ -1279,6 +1280,8 @@ static int taprio_enable_offload(struct net_device *dev,
 		goto done;
 	}
 
+	q->offloaded = true;
+
 done:
 	taprio_offload_free(offload);
 
@@ -1293,12 +1296,9 @@ static int taprio_disable_offload(struct net_device *dev,
 	struct tc_taprio_qopt_offload *offload;
 	int err;
 
-	if (!FULL_OFFLOAD_IS_ENABLED(q->flags))
+	if (!q->offloaded)
 		return 0;
 
-	if (!ops->ndo_setup_tc)
-		return -EOPNOTSUPP;
-
 	offload = taprio_offload_alloc(0);
 	if (!offload) {
 		NL_SET_ERR_MSG(extack,
@@ -1314,6 +1314,8 @@ static int taprio_disable_offload(struct net_device *dev,
 		goto out;
 	}
 
+	q->offloaded = false;
+
 out:
 	taprio_offload_free(offload);
 
-- 
2.35.1



