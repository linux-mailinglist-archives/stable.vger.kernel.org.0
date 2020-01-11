Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF4E137E3F
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbgAKKGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:06:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728893AbgAKKGj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:06:39 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 032B3206DA;
        Sat, 11 Jan 2020 10:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737198;
        bh=oTyxjdiVlbNqEznx9mghwmfposZQKPRulhQo0d4mv5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KgZGM9Vfkk5wBeIp+ThBoJiwNHMBB1k1yGzWhmek1vND2jkmnhzD8emYVA5id/Va1
         fDPNCKSNKhEFD693Bay6wdwbNagFVNMbyvHu6H4Yr6+y17iqZBzs3iiSHU9oMDkqWG
         npDpJqmjaXY+U9WV6e9PVATv/UZ+gVssSzOSmhvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 88/91] net: sch_prio: When ungrafting, replace with FIFO
Date:   Sat, 11 Jan 2020 10:50:21 +0100
Message-Id: <20200111094913.183706298@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
References: <20200111094844.748507863@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

[ Upstream commit 240ce7f6428ff5188b9eedc066e1e4d645b8635f ]

When a child Qdisc is removed from one of the PRIO Qdisc's bands, it is
replaced unconditionally by a NOOP qdisc. As a result, any traffic hitting
that band gets dropped. That is incorrect--no Qdisc was explicitly added
when PRIO was created, and after removal, none should have to be added
either.

Fix PRIO by first attempting to create a default Qdisc and only falling
back to noop when that fails. This pattern of attempting to create an
invisible FIFO, using NOOP only as a fallback, is also seen in other
Qdiscs.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_prio.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -232,8 +232,14 @@ static int prio_graft(struct Qdisc *sch,
 	struct prio_sched_data *q = qdisc_priv(sch);
 	unsigned long band = arg - 1;
 
-	if (new == NULL)
-		new = &noop_qdisc;
+	if (!new) {
+		new = qdisc_create_dflt(sch->dev_queue, &pfifo_qdisc_ops,
+					TC_H_MAKE(sch->handle, arg));
+		if (!new)
+			new = &noop_qdisc;
+		else
+			qdisc_hash_add(new);
+	}
 
 	*old = qdisc_replace(sch, new, &q->queues[band]);
 	return 0;


