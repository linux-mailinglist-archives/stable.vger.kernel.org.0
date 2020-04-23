Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239BF1B680C
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgDWXMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:12:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50160 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728531AbgDWXGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:51 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvX-0004lg-Nm; Fri, 24 Apr 2020 00:06:39 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvT-00E6tc-Ou; Fri, 24 Apr 2020 00:06:35 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Eric Dumazet" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Kenneth Klette Jonassen" <kennetkl@ifi.uio.no>
Date:   Fri, 24 Apr 2020 00:06:29 +0100
Message-ID: <lsq.1587683028.804407755@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 162/245] pkt_sched: fq: avoid hang when quantum 0
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kenneth Klette Jonassen <kennetkl@ifi.uio.no>

commit 3725a269815ba6dbb415feddc47da5af7d1fac58 upstream.

Configuring fq with quantum 0 hangs the system, presumably because of a
non-interruptible infinite loop. Either way quantum 0 does not make sense.

Reproduce with:
sudo tc qdisc add dev lo root fq quantum 0 initial_quantum 0
ping 127.0.0.1

Signed-off-by: Kenneth Klette Jonassen <kennetkl@ifi.uio.no>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sched/sch_fq.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -687,8 +687,14 @@ static int fq_change(struct Qdisc *sch,
 	if (tb[TCA_FQ_FLOW_PLIMIT])
 		q->flow_plimit = nla_get_u32(tb[TCA_FQ_FLOW_PLIMIT]);
 
-	if (tb[TCA_FQ_QUANTUM])
-		q->quantum = nla_get_u32(tb[TCA_FQ_QUANTUM]);
+	if (tb[TCA_FQ_QUANTUM]) {
+		u32 quantum = nla_get_u32(tb[TCA_FQ_QUANTUM]);
+
+		if (quantum > 0)
+			q->quantum = quantum;
+		else
+			err = -EINVAL;
+	}
 
 	if (tb[TCA_FQ_INITIAL_QUANTUM])
 		q->initial_quantum = nla_get_u32(tb[TCA_FQ_INITIAL_QUANTUM]);

