Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3732044F10
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 00:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbfFMW0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 18:26:07 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40388 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfFMW0H (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 18:26:07 -0400
Received: by mail-lj1-f194.google.com with SMTP id a21so315158ljh.7
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 15:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rks0Y0tF/0uIFUiwoag1iJEl5awYzobXVEIXdeNluJI=;
        b=MK/Zd796Vs4QS13x0pfCu9Imp3xKpR1nhntOF84QSXr5Uw9zbZHWH4zQ3UrICyMJz+
         Nj+vHEJo7iSReHyon88G3i1+v3jb7Fn+6DeQJOf8TEu1p2ZS3iQXzklujD6tgZ2BXvQt
         rqUR2Dl43wU8an7C2F/hf/MBLM9bO+ip6eJpn2Lciswn0M955MnHLZE8Ob/cT1URg3PD
         7h4wifMCfcXKuL/eyufIjUHXhR9/5FeEDROxd4tTR0pw17HBwY3HFOHcDK0VyvwX1Meq
         h8e/2sn36L/gqXkwaWdUoYer4jsFPoMXOFi8tM8K73TFF2n1d0lZy/BFaqYehZkTJwOc
         OGqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rks0Y0tF/0uIFUiwoag1iJEl5awYzobXVEIXdeNluJI=;
        b=V3NM20jO2C3RXZuTg3EZKL/2QzrG33c3BlbRGFH+CYLZsBYUMTZFvvJ74iaYKYGNFJ
         8PSStD6WKFUg5nvw31ohWyIjfsY0QTiZrzNk9PWAgCQYrW4yIsx0YNuQuLmix/r16X+T
         qbaDJjeuMtx3zv4qO4zOTcHjFI1aH+RWMzU3Kb390y4fVVo0ThIuq59CYERAHlJr4x7U
         h6NPPj+xQtdeqGTcjnKIMxDfK5WFv5n8sRTLaEf4/cLILZZbZVZTwvfnMk4d3NZ+IP5U
         r40Y7QPULzIOrL036oPC/4uEq0L/4pU2dWht3sBkg1lCzTAhCB/UxY5xcXB7x6GXg2zv
         cgzQ==
X-Gm-Message-State: APjAAAVtgiS6jz+BwFN64foeArJhpclDe4r4X0VdfAYFuWKt5Cm7SdUg
        1/zgjch2RA1jneeelCP40smq1A==
X-Google-Smtp-Source: APXvYqyJJUWkAVC1m+mNjBXOAnLM9kHysFWdmgkivnUSsar+kIF/OEeAk40uIGO3g1ibTAIhyYiL7A==
X-Received: by 2002:a2e:2c04:: with SMTP id s4mr23657051ljs.61.1560464765716;
        Thu, 13 Jun 2019 15:26:05 -0700 (PDT)
Received: from linux.local (c-d2cd225c.014-348-6c756e10.bbcust.telenor.se. [92.34.205.210])
        by smtp.gmail.com with ESMTPSA id b62sm213433ljb.71.2019.06.13.15.26.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 15:26:04 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] net: dsa: rtl8366: Fix up VLAN filtering
Date:   Fri, 14 Jun 2019 00:25:20 +0200
Message-Id: <20190613222520.19182-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We get this regression when using RTL8366RB as part of a bridge
with OpenWrt:

WARNING: CPU: 0 PID: 1347 at net/switchdev/switchdev.c:291
	 switchdev_port_attr_set_now+0x80/0xa4
lan0: Commit of attribute (id=7) failed.
(...)
realtek-smi switch lan0: failed to initialize vlan filtering on this port

This is because it is trying to disable VLAN filtering
on VLAN0, as we have forgot to add 1 to the port number
to get the right VLAN in rtl8366_vlan_filtering(): when
we initialize the VLAN we associate VLAN1 with port 0,
VLAN2 with port 1 etc, so we need to add 1 to the port
offset.

Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/dsa/rtl8366.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 6dedd43442cc..35b767baf21f 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -307,7 +307,8 @@ int rtl8366_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
 	struct rtl8366_vlan_4k vlan4k;
 	int ret;
 
-	if (!smi->ops->is_vlan_valid(smi, port))
+	/* Use VLAN nr port + 1 since VLAN0 is not valid */
+	if (!smi->ops->is_vlan_valid(smi, port + 1))
 		return -EINVAL;
 
 	dev_info(smi->dev, "%s filtering on port %d\n",
@@ -318,12 +319,12 @@ int rtl8366_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
 	 * The hardware support filter ID (FID) 0..7, I have no clue how to
 	 * support this in the driver when the callback only says on/off.
 	 */
-	ret = smi->ops->get_vlan_4k(smi, port, &vlan4k);
+	ret = smi->ops->get_vlan_4k(smi, port + 1, &vlan4k);
 	if (ret)
 		return ret;
 
 	/* Just set the filter to FID 1 for now then */
-	ret = rtl8366_set_vlan(smi, port,
+	ret = rtl8366_set_vlan(smi, port + 1,
 			       vlan4k.member,
 			       vlan4k.untag,
 			       1);
-- 
2.21.0

