Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FFC431ECA
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbhJROFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:05:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234952AbhJRODg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:03:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7AFC6126A;
        Mon, 18 Oct 2021 13:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564622;
        bh=Fi64Q8ZsCDKutGISlLyTFeer8JG6+hIhUUf8Llc5CRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2FffR0JxmwnCkGoNsuaHjnMnIEJBV6KYdpjwOzqOUlNZJTqBurDWil6QXDVHK5kKS
         PajUcnbwjtlC7aPDf8qvUJZKFZqf/9tNjVw+Zi12umptiFKFaKWwtTuFX3K6nPbWfW
         UAg4hnt/Cpd6MTozCxkQC4PeQM7W4yJKbEAjEkL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.14 147/151] net: mscc: ocelot: warn when a PTP IRQ is raised for an unknown skb
Date:   Mon, 18 Oct 2021 15:25:26 +0200
Message-Id: <20211018132345.438962735@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
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
@@ -714,12 +714,12 @@ void ocelot_get_txtstamp(struct ocelot *
 
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


