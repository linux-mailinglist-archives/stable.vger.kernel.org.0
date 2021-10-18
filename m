Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC6543177A
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 13:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhJRLhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 07:37:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229491AbhJRLhY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 07:37:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A37C60E76;
        Mon, 18 Oct 2021 11:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634556914;
        bh=BBzSnBWwZR15TS1mnVqemhiKL41ql91Ik+iuJlZmFA8=;
        h=Subject:To:Cc:From:Date:From;
        b=I48W7VvBsq4Ig2yo9zqFGTWKpO+sKdg/SwP5WcyWuC2D6Toy3mKDfjPifXOzvPZAw
         69NnCBPiZ6VL2RWr86T2OiAWQa/3L2qcHKJfe2ZYF6hy0iVsQLQFZoL1HdHi3Du89F
         UpwaSxpfIFYSyZzsAsc3WRhgt37Efui+luFAxDE8=
Subject: FAILED: patch "[PATCH] net: mscc: ocelot: warn when a PTP IRQ is raised for an" failed to apply to 5.4-stable tree
To:     vladimir.oltean@nxp.com, f.fainelli@gmail.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 13:35:11 +0200
Message-ID: <1634556911165195@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9fde506e0c53b8309f69b18b4b8144c544b4b3b1 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 12 Oct 2021 14:40:37 +0300
Subject: [PATCH] net: mscc: ocelot: warn when a PTP IRQ is raised for an
 unknown skb

When skb_match is NULL, it means we received a PTP IRQ for a timestamp
ID that the kernel has no idea about, since there is no skb in the
timestamping queue with that timestamp ID.

This is a grave error and not something to just "continue" over.
So print a big warning in case this happens.

Also, move the check above ocelot_get_hwtimestamp(), there is no point
in reading the full 64-bit current PTP time if we're not going to do
anything with it anyway for this skb.

Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 9c62f1d13adc..687c07c338cd 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -747,12 +747,12 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 
 		spin_unlock_irqrestore(&port->tx_skbs.lock, flags);
 
+		if (WARN_ON(!skb_match))
+			continue;
+
 		/* Get the h/w timestamp */
 		ocelot_get_hwtimestamp(ocelot, &ts);
 
-		if (unlikely(!skb_match))
-			continue;
-
 		/* Set the timestamp into the skb */
 		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
 		shhwtstamps.hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);

