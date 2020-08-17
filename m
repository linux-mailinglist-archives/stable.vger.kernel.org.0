Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408AC2475C2
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731963AbgHQT2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:28:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730337AbgHQPc4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:32:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E48212311A;
        Mon, 17 Aug 2020 15:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678375;
        bh=QA7MIVp4ltQuVqhOplQfMzK4I4rRnM8iHhKZ0h1fVZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DzZLt4MTWywNP4aPXajDuLSW9MTEH52V1OE4L+1F1YXAW9cY/YNWWi+igWzSld1h6
         OY6b+aUilcgVM18oo9nfPsiDp2DTCgyDUzMmHe0hPJ1aGqMZrGbLFMi/QwEWAhDjjn
         41LRBEUelOBTtmipXD+D01XgDZy0SWU+XlZT/xxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 312/464] net: dsa: rtl8366: Fix VLAN set-up
Date:   Mon, 17 Aug 2020 17:14:25 +0200
Message-Id: <20200817143848.742084268@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 788abc6d9d278ed6fa1fa94db2098481a04152b7 ]

Alter the rtl8366_vlan_add() to call rtl8366_set_vlan()
inside the loop that goes over all VIDs since we now
properly support calling that function more than once.
Augment the loop to postincrement as this is more
intuitive.

The loop moved past the last VID but called
rtl8366_set_vlan() with the port number instead of
the VID, assuming a 1-to-1 correspondence between
ports and VIDs. This was also a bug.

Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/rtl8366.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index a75dcd6698b8a..1368816abaed1 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -397,7 +397,7 @@ void rtl8366_vlan_add(struct dsa_switch *ds, int port,
 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
 		dev_err(smi->dev, "port is DSA or CPU port\n");
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
 		int pvid_val = 0;
 
 		dev_info(smi->dev, "add VLAN %04x\n", vid);
@@ -420,13 +420,13 @@ void rtl8366_vlan_add(struct dsa_switch *ds, int port,
 			if (ret < 0)
 				return;
 		}
-	}
 
-	ret = rtl8366_set_vlan(smi, port, member, untag, 0);
-	if (ret)
-		dev_err(smi->dev,
-			"failed to set up VLAN %04x",
-			vid);
+		ret = rtl8366_set_vlan(smi, vid, member, untag, 0);
+		if (ret)
+			dev_err(smi->dev,
+				"failed to set up VLAN %04x",
+				vid);
+	}
 }
 EXPORT_SYMBOL_GPL(rtl8366_vlan_add);
 
-- 
2.25.1



