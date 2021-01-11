Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F752F15C1
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731454AbhAKNLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:11:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:58930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731451AbhAKNLp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:11:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB1C622795;
        Mon, 11 Jan 2021 13:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370665;
        bh=Gj/HyAUsIQo2G+cUZKMhSKG86mDRwD00QEa/a3fU9xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PguChEDhnGe7CwkAjxhoxZ2ER60yePUl/NrOYpjMQbZ02mLkXlxhOpHoOAxL+gW+Y
         aSMxa6fNjHhzv8m3DaR1E1qMsI4tzugKKUszcvwQw4kjiJ32zL8FFLoL7VAFw5AAyt
         lqgmCYWVRwpo4eKvfi2xaNPKAVXSiUGHJETNqZH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH 5.4 45/92] net/sched: sch_taprio: ensure to reset/destroy all child qdiscs
Date:   Mon, 11 Jan 2021 14:01:49 +0100
Message-Id: <20210111130041.315198350@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit 698285da79f5b0b099db15a37ac661ac408c80eb ]

taprio_graft() can insert a NULL element in the array of child qdiscs. As
a consquence, taprio_reset() might not reset child qdiscs completely, and
taprio_destroy() might leak resources. Fix it by ensuring that loops that
iterate over q->qdiscs[] don't end when they find the first NULL item.

Fixes: 44d4775ca518 ("net/sched: sch_taprio: reset child qdiscs before freeing them")
Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Link: https://lore.kernel.org/r/13edef6778fef03adc751582562fba4a13e06d6a.1608240532.git.dcaratti@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_taprio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1626,7 +1626,7 @@ static void taprio_destroy(struct Qdisc
 	taprio_disable_offload(dev, q, NULL);
 
 	if (q->qdiscs) {
-		for (i = 0; i < dev->num_tx_queues && q->qdiscs[i]; i++)
+		for (i = 0; i < dev->num_tx_queues; i++)
 			qdisc_put(q->qdiscs[i]);
 
 		kfree(q->qdiscs);


