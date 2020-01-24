Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC38C1482BD
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391638AbgAXLaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:30:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:48060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388035AbgAXLaY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:30:24 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 081B020838;
        Fri, 24 Jan 2020 11:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865423;
        bh=/pZQvLA4/iPOMhTij+JCylWOs2bxqGFEckmRrKqVCL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFti8loGprFwJTifOxYelIubIfxkU+ak6s3nc86j80qT55cSnUg3Hnou7tnlGSPYI
         YF3psqdlJAXbm52JauzG6ryiPYy5bQO6MgAzmYwSbbWzPS+GIQ5q/fEDcMH5OhOEYJ
         qnnSNeT+cIKQ0y7GYXJuOMyMr9tcA5ADfNIu/xRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Leandro Dorileo <leandro.maciel.dorileo@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 529/639] net/sched: cbs: Set default link speed to 10 Mbps in cbs_set_port_rate
Date:   Fri, 24 Jan 2020 10:31:39 +0100
Message-Id: <20200124093155.069832836@linuxfoundation.org>
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

From: Vladimir Oltean <olteanv@gmail.com>

[ Upstream commit 1c6c09a0ae62fa3ea8f8ead2ac3920e6fff2de64 ]

The discussion to be made is absolutely the same as in the case of
previous patch ("taprio: Set default link speed to 10 Mbps in
taprio_set_picos_per_byte"). Nothing is lost when setting a default.

Cc: Leandro Dorileo <leandro.maciel.dorileo@intel.com>
Fixes: e0a7683d30e9 ("net/sched: cbs: fix port_rate miscalculation")
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cbs.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
index b3c8d04929df2..289f66b9238d3 100644
--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -185,11 +185,6 @@ static struct sk_buff *cbs_dequeue_soft(struct Qdisc *sch)
 	s64 credits;
 	int len;
 
-	if (atomic64_read(&q->port_rate) == -1) {
-		WARN_ONCE(1, "cbs: dequeue() called with unknown port rate.");
-		return NULL;
-	}
-
 	if (q->credits < 0) {
 		credits = timediff_to_credits(now - q->last, q->idleslope);
 
@@ -307,11 +302,19 @@ static int cbs_enable_offload(struct net_device *dev, struct cbs_sched_data *q,
 static void cbs_set_port_rate(struct net_device *dev, struct cbs_sched_data *q)
 {
 	struct ethtool_link_ksettings ecmd;
+	int speed = SPEED_10;
 	int port_rate = -1;
+	int err;
+
+	err = __ethtool_get_link_ksettings(dev, &ecmd);
+	if (err < 0)
+		goto skip;
+
+	if (ecmd.base.speed != SPEED_UNKNOWN)
+		speed = ecmd.base.speed;
 
-	if (!__ethtool_get_link_ksettings(dev, &ecmd) &&
-	    ecmd.base.speed != SPEED_UNKNOWN)
-		port_rate = ecmd.base.speed * 1000 * BYTES_PER_KBIT;
+skip:
+	port_rate = speed * 1000 * BYTES_PER_KBIT;
 
 	atomic64_set(&q->port_rate, port_rate);
 	netdev_dbg(dev, "cbs: set %s's port_rate to: %lld, linkspeed: %d\n",
-- 
2.20.1



