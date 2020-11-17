Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3C32B61BE
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730849AbgKQNV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:21:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:56120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730338AbgKQNV5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:21:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA3882463D;
        Tue, 17 Nov 2020 13:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619317;
        bh=MppfnIu6oV37wXieOEWrtlR/WYQgAZRPL/Kija+SLb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AA7CMD4wKg/hRGyZ/za+zYsc0aDcSbZGxLsGB5yIqXSpNZlVpLARnBbpAPJXy78g6
         PEtfa/4w7xQ2H7f4NaGX0+iqBxzQqxU9LY41D6RriKvl7yy0cGHGccd7Ka2HOSXDGx
         sSVdK9S9smWJzZq7nYiDIHuf4v3a1iIiCV5/4G48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 4.19 100/101] net: sch_generic: fix the missing new qdisc assignment bug
Date:   Tue, 17 Nov 2020 14:06:07 +0100
Message-Id: <20201117122118.001756699@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


When commit 2fb541c862c9 ("net: sch_generic: aviod concurrent reset and
enqueue op for lockless qdisc") is backported to stable kernel, one
assignment is missing, which causes two problems reported by Joakim and
Vishwanath, see [1] and [2].

So add the assignment back to fix it.

1. https://www.spinics.net/lists/netdev/msg693916.html
2. https://www.spinics.net/lists/netdev/msg695131.html

Fixes: 749cc0b0c7f3 ("net: sch_generic: aviod concurrent reset and enqueue op for lockless qdisc")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Tested-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_generic.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1116,10 +1116,13 @@ static void dev_deactivate_queue(struct
 				 void *_qdisc_default)
 {
 	struct Qdisc *qdisc = rtnl_dereference(dev_queue->qdisc);
+	struct Qdisc *qdisc_default = _qdisc_default;
 
 	if (qdisc) {
 		if (!(qdisc->flags & TCQ_F_BUILTIN))
 			set_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state);
+
+		rcu_assign_pointer(dev_queue->qdisc, qdisc_default);
 	}
 }
 


