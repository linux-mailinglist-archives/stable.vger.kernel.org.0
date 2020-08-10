Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4A9240A25
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgHJPZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:25:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727897AbgHJPZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:25:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4D9A208A9;
        Mon, 10 Aug 2020 15:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073114;
        bh=Kar1TO+w8C9msoAYDYhGQr9h51j/i+i5CDeZxA15Dpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wT4kjo/+kSO19CkDq0+4dyn5mperyQv1YhTSMwxBONHl0L7ZzS/EDi2X58mjLiWDB
         oHueuisyp3NYEoEFXTX5EU7QpoAUTqRqRquboFgh9uCIfh/PUccI9wgTGnMY4w2VL3
         zFzDO7kmg6/0XXCWuggOQfH3+gL4kt2eNCCHYEvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, laurent brando <laurent.brando@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 41/79] net: mscc: ocelot: fix hardware timestamp dequeue logic
Date:   Mon, 10 Aug 2020 17:21:00 +0200
Message-Id: <20200810151814.300679197@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: laurent brando <laurent.brando@nxp.com>

[ Upstream commit 5fd82200d870a5dd3e509c98ef2041f580b2c0e1 ]

The next hw timestamp should be snapshoot to the read registers
only once the current timestamp has been read.
If none of the pending skbs matches the current HW timestamp
just gracefully flush the available timestamp by reading it.

Signed-off-by: laurent brando <laurent.brando@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index efb3965a3e42b..76dbf9ac8ad50 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -749,21 +749,21 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 
 		spin_unlock_irqrestore(&port->tx_skbs.lock, flags);
 
-		/* Next ts */
-		ocelot_write(ocelot, SYS_PTP_NXT_PTP_NXT, SYS_PTP_NXT);
+		/* Get the h/w timestamp */
+		ocelot_get_hwtimestamp(ocelot, &ts);
 
 		if (unlikely(!skb_match))
 			continue;
 
-		/* Get the h/w timestamp */
-		ocelot_get_hwtimestamp(ocelot, &ts);
-
 		/* Set the timestamp into the skb */
 		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
 		shhwtstamps.hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
 		skb_tstamp_tx(skb_match, &shhwtstamps);
 
 		dev_kfree_skb_any(skb_match);
+
+		/* Next ts */
+		ocelot_write(ocelot, SYS_PTP_NXT_PTP_NXT, SYS_PTP_NXT);
 	}
 }
 EXPORT_SYMBOL(ocelot_get_txtstamp);
-- 
2.25.1



