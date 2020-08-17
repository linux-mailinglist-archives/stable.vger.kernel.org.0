Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34FE246EF7
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731385AbgHQRji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:39:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730860AbgHQQQk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:16:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ACC922D2B;
        Mon, 17 Aug 2020 16:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680986;
        bh=NfUegQHp701VI/9vB3DTU9av/uxtI0FjP/hSjjOVqIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hJc2MIDdH9GWP/5y91RI6fM3zDZExvPXkPQDnTxo9NlwuEVxj5oeuj9ESnKtdK0Op
         0MvTneK/wNEF7z4lSPX6OfVV67rDS7mNlxWHZOSY5MEqPZowo8LuLu6BV3mArqcnTq
         qzEd6Eh07XH3+o8YOCmPcvKIgvBS9L6JoFGN4VJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 107/168] net: dsa: rtl8366: Fix VLAN semantics
Date:   Mon, 17 Aug 2020 17:17:18 +0200
Message-Id: <20200817143739.041697692@linuxfoundation.org>
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

[ Upstream commit 15ab7906cc9290afb006df1bb1074907fbcc7061 ]

The RTL8366 would not handle adding new members (ports) to
a VLAN: the code assumed that ->port_vlan_add() was only
called once for a single port. When intializing the
switch with .configure_vlan_while_not_filtering set to
true, the function is called numerous times for adding
all ports to VLAN1, which was something the code could
not handle.

Alter rtl8366_set_vlan() to just |= new members and
untagged flags to 4k and MC VLAN table entries alike.
This makes it possible to just add new ports to a
VLAN.

Put in some helpful debug code that can be used to find
any further bugs here.

Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/rtl8366.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index c281c488a306f..145f34de7b416 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -43,18 +43,26 @@ int rtl8366_set_vlan(struct realtek_smi *smi, int vid, u32 member,
 	int ret;
 	int i;
 
+	dev_dbg(smi->dev,
+		"setting VLAN%d 4k members: 0x%02x, untagged: 0x%02x\n",
+		vid, member, untag);
+
 	/* Update the 4K table */
 	ret = smi->ops->get_vlan_4k(smi, vid, &vlan4k);
 	if (ret)
 		return ret;
 
-	vlan4k.member = member;
-	vlan4k.untag = untag;
+	vlan4k.member |= member;
+	vlan4k.untag |= untag;
 	vlan4k.fid = fid;
 	ret = smi->ops->set_vlan_4k(smi, &vlan4k);
 	if (ret)
 		return ret;
 
+	dev_dbg(smi->dev,
+		"resulting VLAN%d 4k members: 0x%02x, untagged: 0x%02x\n",
+		vid, vlan4k.member, vlan4k.untag);
+
 	/* Try to find an existing MC entry for this VID */
 	for (i = 0; i < smi->num_vlan_mc; i++) {
 		struct rtl8366_vlan_mc vlanmc;
@@ -65,11 +73,16 @@ int rtl8366_set_vlan(struct realtek_smi *smi, int vid, u32 member,
 
 		if (vid == vlanmc.vid) {
 			/* update the MC entry */
-			vlanmc.member = member;
-			vlanmc.untag = untag;
+			vlanmc.member |= member;
+			vlanmc.untag |= untag;
 			vlanmc.fid = fid;
 
 			ret = smi->ops->set_vlan_mc(smi, i, &vlanmc);
+
+			dev_dbg(smi->dev,
+				"resulting VLAN%d MC members: 0x%02x, untagged: 0x%02x\n",
+				vid, vlanmc.member, vlanmc.untag);
+
 			break;
 		}
 	}
-- 
2.25.1



