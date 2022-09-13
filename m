Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFD855B70BC
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbiIMO0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbiIMO0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:26:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2593666119;
        Tue, 13 Sep 2022 07:16:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7726A614C1;
        Tue, 13 Sep 2022 14:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793C0C433C1;
        Tue, 13 Sep 2022 14:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078516;
        bh=u+CvDUsNpVz+9oYCk/2VKdoyai1LQT9d8/3maTue2ZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yv3vmXGCEnLeM/ybCWdj2Jh3vY0VUGPoDHTSuEiQkUV2++8A0eokmtR3f+rWpYkzL
         qk9a+1y9xcp4b1HdfjATL9BV7I3y7+4nqRtLmGE5Fefi+vuBY1NZSd5icDSICw9qAA
         /jxMYY9sx2D4GcGozSxvmFnrWAcIAk9ESAh3JS0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: [PATCH 5.19 171/192] time64.h: consolidate uses of PSEC_PER_NSEC
Date:   Tue, 13 Sep 2022 16:04:37 +0200
Message-Id: <20220913140418.552441455@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 837ced3a1a5d8bb1a637dd584711f31ae6b54d93 ]

Time-sensitive networking code needs to work with PTP times expressed in
nanoseconds, and with packet transmission times expressed in
picoseconds, since those would be fractional at higher than gigabit
speed when expressed in nanoseconds.

Convert the existing uses in tc-taprio and the ocelot/felix DSA driver
to a PSEC_PER_NSEC macro. This macro is placed in include/linux/time64.h
as opposed to its relatives (PSEC_PER_SEC etc) from include/vdso/time64.h
because the vDSO library does not (yet) need/use it.

Cc: Andy Lutomirski <luto@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com> # for the vDSO parts
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 11afdc6526de ("net: dsa: felix: tc-taprio intervals smaller than MTU should send at least one packet")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 5 +++--
 include/linux/time64.h                 | 3 +++
 net/sched/sch_taprio.c                 | 5 +++--
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index f1767a6b9271c..4cce71243080e 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -16,6 +16,7 @@
 #include <linux/iopoll.h>
 #include <linux/mdio.h>
 #include <linux/pci.h>
+#include <linux/time.h>
 #include "felix.h"
 
 #define VSC9959_NUM_PORTS		6
@@ -1592,7 +1593,7 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 		u32 max_sdu;
 
 		if (min_gate_len[tc] == U64_MAX /* Gate always open */ ||
-		    min_gate_len[tc] * 1000 > needed_bit_time_ps) {
+		    min_gate_len[tc] * PSEC_PER_NSEC > needed_bit_time_ps) {
 			/* Setting QMAXSDU_CFG to 0 disables oversized frame
 			 * dropping.
 			 */
@@ -1606,7 +1607,7 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 			 * frame, make sure to enable oversize frame dropping
 			 * for frames larger than the smallest that would fit.
 			 */
-			max_sdu = div_u64(min_gate_len[tc] * 1000,
+			max_sdu = div_u64(min_gate_len[tc] * PSEC_PER_NSEC,
 					  picos_per_byte);
 			/* A TC gate may be completely closed, which is a
 			 * special case where all packets are oversized.
diff --git a/include/linux/time64.h b/include/linux/time64.h
index 81b9686a20799..2fb8232cff1d5 100644
--- a/include/linux/time64.h
+++ b/include/linux/time64.h
@@ -20,6 +20,9 @@ struct itimerspec64 {
 	struct timespec64 it_value;
 };
 
+/* Parameters used to convert the timespec values: */
+#define PSEC_PER_NSEC			1000L
+
 /* Located here for timespec[64]_valid_strict */
 #define TIME64_MAX			((s64)~((u64)1 << 63))
 #define TIME64_MIN			(-TIME64_MAX - 1)
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index b9c71a304d399..0b941dd63d268 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
+#include <linux/time.h>
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
@@ -176,7 +177,7 @@ static ktime_t get_interval_end_time(struct sched_gate_list *sched,
 
 static int length_to_duration(struct taprio_sched *q, int len)
 {
-	return div_u64(len * atomic64_read(&q->picos_per_byte), 1000);
+	return div_u64(len * atomic64_read(&q->picos_per_byte), PSEC_PER_NSEC);
 }
 
 /* Returns the entry corresponding to next available interval. If
@@ -551,7 +552,7 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
 static void taprio_set_budget(struct taprio_sched *q, struct sched_entry *entry)
 {
 	atomic_set(&entry->budget,
-		   div64_u64((u64)entry->interval * 1000,
+		   div64_u64((u64)entry->interval * PSEC_PER_NSEC,
 			     atomic64_read(&q->picos_per_byte)));
 }
 
-- 
2.35.1



