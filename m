Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B26246F26
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730829AbgHQQP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 12:15:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388805AbgHQQPM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:15:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0E29206FA;
        Mon, 17 Aug 2020 16:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680912;
        bh=LZEDUxir5qmJ/DDY6kHLkIl4v+t4VAJliT08wxgDnIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jF3SoQRI64o7GPschgDfIEzhHsVgJGbLUGk286l2EFh23A3aEiPxUAFsGfbO2xM8/
         W7J6fwYPQX8cn5Tl5Cp+Qeag9qRcSAMOlbCq9VBietYifiLTzwkl6biKyKVpk/uPUf
         bxhmvGwl23U7LYoz86IMEARqXx/Ow4fLFgrm+GKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 108/168] net: dsa: rtl8366: Fix VLAN set-up
Date:   Mon, 17 Aug 2020 17:17:19 +0200
Message-Id: <20200817143739.085827014@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
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
index 145f34de7b416..7e27c9aff9b72 100644
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



