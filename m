Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC6212207A
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfLQAzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:55:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35214 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726992AbfLQAvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:43 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0003Ml-IZ; Tue, 17 Dec 2019 00:51:34 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15I-0005ZX-Jk; Tue, 17 Dec 2019 00:51:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        "Simon Horman" <simon.horman@netronome.com>
Date:   Tue, 17 Dec 2019 00:46:55 +0000
Message-ID: <lsq.1576543535.451851386@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 081/136] net: netem: correct the parent's backlog
 when corrupted packet was dropped
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <jakub.kicinski@netronome.com>

commit e0ad032e144731a5928f2d75e91c2064ba1a764c upstream.

If packet corruption failed we jump to finish_segs and return
NET_XMIT_SUCCESS. Seeing success will make the parent qdisc
increment its backlog, that's incorrect - we need to return
NET_XMIT_DROP.

Fixes: 6071bd1aa13e ("netem: Segment GSO packets on enqueue")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sched/sch_netem.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -599,6 +599,8 @@ finish_segs:
 		}
 		/* Parent qdiscs accounted for 1 skb of size @prev_len */
 		qdisc_tree_reduce_backlog(sch, -(nb - 1), -(len - prev_len));
+	} else if (!skb) {
+		return NET_XMIT_DROP;
 	}
 	return NET_XMIT_SUCCESS;
 }

