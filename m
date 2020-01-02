Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C264B12E583
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 12:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbgABLHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 06:07:14 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41535 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728111AbgABLHO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 06:07:14 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E432C21AEF;
        Thu,  2 Jan 2020 06:07:13 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 02 Jan 2020 06:07:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=i8OC0/
        dL3q4Adn2nCTHjt0W7YsxaltseynH0DtwPUiI=; b=QajMOmQ7fbkpZWrJngwdHa
        IHklIfrlAX2rg5r5pXFr6HOP3njIDVUj2YnmGohy9gvOUYWY+yAHxqQEsdbrD3Sy
        nCodEXYWWFxI/jckUNcIR4rHWDD8EeXF2TiwZlnRcDSQkatyyirHizSoulSOVxIw
        kI4WTnWieKX6hvzxzsnM7NeuG4sJb+u22Q4DVNo+faVwAvKwHkCxFZP3Q4gD3Mv8
        Ymgzat4eR/VFzteyQX2K7F7kbUzQG9FKhrPjvlNOJ+ex4XmNdqJ86ynuh0SBPYKE
        VafwtEltbZKvu39DX4BJSPQ06mJ3eYOriWjB9C1+rHnEjPsXIFch5KzZIVJjYeDQ
        ==
X-ME-Sender: <xms:4c4NXmm_gzOE_Pu3PIzvtDtlRE6SLax7Tjmt0zEoVYwWH1ptty631g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeguddgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:4c4NXgs4aL4FRShyjgX-_pkCg3mgvYUogF3fSHfQJVf4aam9OMou_g>
    <xmx:4c4NXldeUcroPt-udFX_Vhewx9e9GPjvqqNl9VvZxBbPS1cdXzs3GQ>
    <xmx:4c4NXsYqWNsmKcbrRiP90BhohNXB-8ZjbMy5TbnmWzLFEZwe7h4DDw>
    <xmx:4c4NXkmeGt8RXskUWV3IX1PPbhY7NmQFQ8g7--vnopXUifWnV7LPMg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4282780061;
        Thu,  2 Jan 2020 06:07:13 -0500 (EST)
Subject: FAILED: patch "[PATCH] gtp: do not allow adding duplicate tid and ms_addr pdp" failed to apply to 4.9-stable tree
To:     ap420073@gmail.com, jakub.kicinski@netronome.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 02 Jan 2020 12:07:11 +0100
Message-ID: <1577963231117144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6b01b1d9b2d38dc84ac398bfe9f00baff06a31e5 Mon Sep 17 00:00:00 2001
From: Taehee Yoo <ap420073@gmail.com>
Date: Wed, 11 Dec 2019 08:23:00 +0000
Subject: [PATCH] gtp: do not allow adding duplicate tid and ms_addr pdp
 context

GTP RX packet path lookups pdp context with TID. If duplicate TID pdp
contexts are existing in the list, it couldn't select correct pdp context.
So, TID value  should be unique.
GTP TX packet path lookups pdp context with ms_addr. If duplicate ms_addr pdp
contexts are existing in the list, it couldn't select correct pdp context.
So, ms_addr value should be unique.

Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index ecfe26215935..8b742edf793d 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -926,24 +926,31 @@ static void ipv4_pdp_fill(struct pdp_ctx *pctx, struct genl_info *info)
 	}
 }
 
-static int ipv4_pdp_add(struct gtp_dev *gtp, struct sock *sk,
-			struct genl_info *info)
+static int gtp_pdp_add(struct gtp_dev *gtp, struct sock *sk,
+		       struct genl_info *info)
 {
+	struct pdp_ctx *pctx, *pctx_tid = NULL;
 	struct net_device *dev = gtp->dev;
 	u32 hash_ms, hash_tid = 0;
-	struct pdp_ctx *pctx;
+	unsigned int version;
 	bool found = false;
 	__be32 ms_addr;
 
 	ms_addr = nla_get_be32(info->attrs[GTPA_MS_ADDRESS]);
 	hash_ms = ipv4_hashfn(ms_addr) % gtp->hash_size;
+	version = nla_get_u32(info->attrs[GTPA_VERSION]);
 
-	hlist_for_each_entry_rcu(pctx, &gtp->addr_hash[hash_ms], hlist_addr) {
-		if (pctx->ms_addr_ip4.s_addr == ms_addr) {
-			found = true;
-			break;
-		}
-	}
+	pctx = ipv4_pdp_find(gtp, ms_addr);
+	if (pctx)
+		found = true;
+	if (version == GTP_V0)
+		pctx_tid = gtp0_pdp_find(gtp,
+					 nla_get_u64(info->attrs[GTPA_TID]));
+	else if (version == GTP_V1)
+		pctx_tid = gtp1_pdp_find(gtp,
+					 nla_get_u32(info->attrs[GTPA_I_TEI]));
+	if (pctx_tid)
+		found = true;
 
 	if (found) {
 		if (info->nlhdr->nlmsg_flags & NLM_F_EXCL)
@@ -951,6 +958,11 @@ static int ipv4_pdp_add(struct gtp_dev *gtp, struct sock *sk,
 		if (info->nlhdr->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
+		if (pctx && pctx_tid)
+			return -EEXIST;
+		if (!pctx)
+			pctx = pctx_tid;
+
 		ipv4_pdp_fill(pctx, info);
 
 		if (pctx->gtp_version == GTP_V0)
@@ -1074,7 +1086,7 @@ static int gtp_genl_new_pdp(struct sk_buff *skb, struct genl_info *info)
 		goto out_unlock;
 	}
 
-	err = ipv4_pdp_add(gtp, sk, info);
+	err = gtp_pdp_add(gtp, sk, info);
 
 out_unlock:
 	rcu_read_unlock();

