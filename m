Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90C4C148343
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390190AbgAXLem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:34:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:54582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404737AbgAXLej (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:34:39 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12BA62077C;
        Fri, 24 Jan 2020 11:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865678;
        bh=n5ZmNn9yr+VyTjdRfRECzyXjrN/8A92sOV9eRCm9MFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gn3i2xCeGVZ+DPBKSPYtYSbtOm5Ug2CBfCQf7JkzWvnnG5uv8nef0M9RtO+FBOsPZ
         wjOk5rDXckG29gFpwoueTAANY0U/g1965qWxNa3n9iCObWwZnE/km7ayP3ocPR0SOi
         V9E7mposCQKk0rA1VALoCCQ7psJ3F9XDYP366COI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 610/639] net: netem: correct the parents backlog when corrupted packet was dropped
Date:   Fri, 24 Jan 2020 10:33:00 +0100
Message-Id: <20200124093205.870688745@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit e0ad032e144731a5928f2d75e91c2064ba1a764c ]

If packet corruption failed we jump to finish_segs and return
NET_XMIT_SUCCESS. Seeing success will make the parent qdisc
increment its backlog, that's incorrect - we need to return
NET_XMIT_DROP.

Fixes: 6071bd1aa13e ("netem: Segment GSO packets on enqueue")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_netem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 7660aa5b80da8..014a28d8dd4fa 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -607,6 +607,8 @@ finish_segs:
 		}
 		/* Parent qdiscs accounted for 1 skb of size @prev_len */
 		qdisc_tree_reduce_backlog(sch, -(nb - 1), -(len - prev_len));
+	} else if (!skb) {
+		return NET_XMIT_DROP;
 	}
 	return NET_XMIT_SUCCESS;
 }
-- 
2.20.1



