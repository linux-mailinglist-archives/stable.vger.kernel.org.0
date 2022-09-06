Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E765AEA38
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbiIFNmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233571AbiIFNko (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:40:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4877CA89;
        Tue,  6 Sep 2022 06:37:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC8AC60F89;
        Tue,  6 Sep 2022 13:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F082AC433C1;
        Tue,  6 Sep 2022 13:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471420;
        bh=uqNIxHrwutlr3pd4DT90QxQagsz7gIukUrnAjPuXn/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQyYNUHneKBn71j4HVBqjvSwbwyg9CSv+ZEU887w3x8ovUrLDa7U+WgUmW7f84gTS
         gVL8H2sMOt07Q1bPJn32vxq71PbMWcDPDP8CZ5fHFXyfYg5i4sBMf7JkEN41gn3FXr
         uZiH7dCorF3/xUOawGEiVB5sHAzwHjtmhpZW73RA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/107] net: dsa: xrs700x: Use irqsave variant for u64 stats update
Date:   Tue,  6 Sep 2022 15:30:01 +0200
Message-Id: <20220906132822.607437320@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 3f8ae9fe0409698799e173f698b714f34570b64b ]

xrs700x_read_port_counters() updates the stats from a worker using the
u64_stats_update_begin() version. This is okay on 32-UP since on the
reader side preemption is disabled.
On 32bit-SMP the writer can be preempted by the reader at which point
the reader will spin on the seqcount until writer continues and
completes the update.

Assigning the mib_mutex mutex to the underlying seqcount would ensure
proper synchronisation. The API for that on the u64_stats_init() side
isn't available. Since it is the only user, just use disable interrupts
during the update.

Use u64_stats_update_begin_irqsave() on the writer side to ensure an
uninterrupted update.

Fixes: ee00b24f32eb8 ("net: dsa: add Arrow SpeedChips XRS700x driver")
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: George McCollister <george.mccollister@gmail.com>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: George McCollister <george.mccollister@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/xrs700x/xrs700x.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index 469420941054e..cf363d5a30020 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -108,6 +108,7 @@ static void xrs700x_read_port_counters(struct xrs700x *priv, int port)
 {
 	struct xrs700x_port *p = &priv->ports[port];
 	struct rtnl_link_stats64 stats;
+	unsigned long flags;
 	int i;
 
 	memset(&stats, 0, sizeof(stats));
@@ -137,9 +138,9 @@ static void xrs700x_read_port_counters(struct xrs700x *priv, int port)
 	 */
 	stats.rx_packets += stats.multicast;
 
-	u64_stats_update_begin(&p->syncp);
+	flags = u64_stats_update_begin_irqsave(&p->syncp);
 	p->stats64 = stats;
-	u64_stats_update_end(&p->syncp);
+	u64_stats_update_end_irqrestore(&p->syncp, flags);
 
 	mutex_unlock(&p->mib_mutex);
 }
-- 
2.35.1



