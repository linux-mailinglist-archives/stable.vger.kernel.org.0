Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE0E39611D
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232979AbhEaOfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:35:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233000AbhEaOd2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:33:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB5C661C36;
        Mon, 31 May 2021 13:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469000;
        bh=ZriBpfqZx+VdzBDKFmZ5z/xlbGXCH2QH075GN56+CV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oWKH+o4s07OftUjmKVEI1VIPYv3vTrXSF69Z5Q/iyT2QD/cVW93912KNeH7umGcDF
         ePA1k2EVHcjaFEekZ3tDYpTlBJz2XstaGphbx8HGPgGj6oBIUZY+cJKgj4x/pT0Nw5
         /bWryvVxPm4/eVwutJEBODnvMSIDqkAIIFx8fyMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 032/296] net/sched: fq_pie: re-factor fix for fq_pie endless loop
Date:   Mon, 31 May 2021 15:11:27 +0200
Message-Id: <20210531130704.886323455@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

commit 3a62fed2fd7b6fea96d720e779cafc30dfb3a22e upstream.

the patch that fixed an endless loop in_fq_pie_init() was not considering
that 65535 is a valid class id. The correct bugfix for this infinite loop
is to change 'idx' to become an u32, like Colin proposed in the past [1].

Fix this as follows:
 - restore 65536 as maximum possible values of 'flows_cnt'
 - use u32 'idx' when iterating on 'q->flows'
 - fix the TDC selftest

This reverts commit bb2f930d6dd708469a587dc9ed1efe1ef969c0bf.

[1] https://lore.kernel.org/netdev/20210407163808.499027-1-colin.king@canonical.com/

CC: Colin Ian King <colin.king@canonical.com>
CC: stable@vger.kernel.org
Fixes: bb2f930d6dd7 ("net/sched: fix infinite loop in sch_fq_pie")
Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_fq_pie.c                                         |   10 +++++-----
 tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_pie.json |    8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -297,9 +297,9 @@ static int fq_pie_change(struct Qdisc *s
 			goto flow_error;
 		}
 		q->flows_cnt = nla_get_u32(tb[TCA_FQ_PIE_FLOWS]);
-		if (!q->flows_cnt || q->flows_cnt >= 65536) {
+		if (!q->flows_cnt || q->flows_cnt > 65536) {
 			NL_SET_ERR_MSG_MOD(extack,
-					   "Number of flows must range in [1..65535]");
+					   "Number of flows must range in [1..65536]");
 			goto flow_error;
 		}
 	}
@@ -367,7 +367,7 @@ static void fq_pie_timer(struct timer_li
 	struct fq_pie_sched_data *q = from_timer(q, t, adapt_timer);
 	struct Qdisc *sch = q->sch;
 	spinlock_t *root_lock; /* to lock qdisc for probability calculations */
-	u16 idx;
+	u32 idx;
 
 	root_lock = qdisc_lock(qdisc_root_sleeping(sch));
 	spin_lock(root_lock);
@@ -388,7 +388,7 @@ static int fq_pie_init(struct Qdisc *sch
 {
 	struct fq_pie_sched_data *q = qdisc_priv(sch);
 	int err;
-	u16 idx;
+	u32 idx;
 
 	pie_params_init(&q->p_params);
 	sch->limit = 10 * 1024;
@@ -500,7 +500,7 @@ static int fq_pie_dump_stats(struct Qdis
 static void fq_pie_reset(struct Qdisc *sch)
 {
 	struct fq_pie_sched_data *q = qdisc_priv(sch);
-	u16 idx;
+	u32 idx;
 
 	INIT_LIST_HEAD(&q->new_flows);
 	INIT_LIST_HEAD(&q->old_flows);
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_pie.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_pie.json
@@ -9,11 +9,11 @@
         "setup": [
             "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DUMMY root fq_pie flows 65536",
-        "expExitCode": "2",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_pie flows 65536",
+        "expExitCode": "0",
         "verifyCmd": "$TC qdisc show dev $DUMMY",
-        "matchPattern": "qdisc",
-        "matchCount": "0",
+        "matchPattern": "qdisc fq_pie 1: root refcnt 2 limit 10240p flows 65536",
+        "matchCount": "1",
         "teardown": [
             "$IP link del dev $DUMMY"
         ]


