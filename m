Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7B7431D40
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbhJRNt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:49:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232955AbhJRNrs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:47:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FDAA613DA;
        Mon, 18 Oct 2021 13:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564196;
        bh=Mj4jA815dGR6rKyRp/7j4895fyQwbPLCFgLkvi9cuqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LAspsFv8HtOsAvUQxKlVrqFoYuiZkJXprI3ry0m7MX9quxIKmI9V2wo/gX8Izx1t3
         0ijSVEG3akrdWgge2VaiOikPlb71ZjGP1O6wrQhbMVgU5tMDzD8BSMGoKq5wFNi7bD
         db5BL2N/j4F68+lY+xJdva0S0CWPw+rbIuzExcKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 101/103] net: mscc: ocelot: warn when a PTP IRQ is raised for an unknown skb
Date:   Mon, 18 Oct 2021 15:25:17 +0200
Message-Id: <20211018132338.133898729@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 9fde506e0c53b8309f69b18b4b8144c544b4b3b1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mscc/ocelot.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -594,12 +594,12 @@ void ocelot_get_txtstamp(struct ocelot *
 
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


