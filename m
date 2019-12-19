Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6EFC126BE3
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbfLSSwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:52:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:47286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730270AbfLSSwj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:52:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9E58222C2;
        Thu, 19 Dec 2019 18:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781559;
        bh=Oye+xFFwRaxXK6gVfuSxJKioNDCxjbFbXImXCOWqsj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VcQbVcXZAjo0OkWHoTOAEpL24aBwPgjwAXX8LROboq8+UBhE+sFQHsVZ2YtDGO+FP
         YeB6y6FmjDLuiY8X3Q2UdxgxHqUNztxfbXnpU2Uh70+/z9F1797+DAij7/eItD5/WN
         cvguDHUhBP3wmlVIJLI04PjTURPbxd+XlS8KfQ7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 06/47] net: sched: fix dump qlen for sch_mq/sch_mqprio with NOLOCK subqueues
Date:   Thu, 19 Dec 2019 19:34:20 +0100
Message-Id: <20191219182901.671560193@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219182857.659088743@linuxfoundation.org>
References: <20191219182857.659088743@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dust Li <dust.li@linux.alibaba.com>

[ Upstream commit 2f23cd42e19c22c24ff0e221089b7b6123b117c5 ]

sch->q.len hasn't been set if the subqueue is a NOLOCK qdisc
 in mq_dump() and mqprio_dump().

Fixes: ce679e8df7ed ("net: sched: add support for TCQ_F_NOLOCK subqueues to sch_mqprio")
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_mq.c     |    1 +
 net/sched/sch_mqprio.c |    1 +
 2 files changed, 2 insertions(+)

--- a/net/sched/sch_mq.c
+++ b/net/sched/sch_mq.c
@@ -158,6 +158,7 @@ static int mq_dump(struct Qdisc *sch, st
 			__gnet_stats_copy_queue(&sch->qstats,
 						qdisc->cpu_qstats,
 						&qdisc->qstats, qlen);
+			sch->q.qlen		+= qlen;
 		} else {
 			sch->q.qlen		+= qdisc->q.qlen;
 			sch->bstats.bytes	+= qdisc->bstats.bytes;
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -413,6 +413,7 @@ static int mqprio_dump(struct Qdisc *sch
 			__gnet_stats_copy_queue(&sch->qstats,
 						qdisc->cpu_qstats,
 						&qdisc->qstats, qlen);
+			sch->q.qlen		+= qlen;
 		} else {
 			sch->q.qlen		+= qdisc->q.qlen;
 			sch->bstats.bytes	+= qdisc->bstats.bytes;


