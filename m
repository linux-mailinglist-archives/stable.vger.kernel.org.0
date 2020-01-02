Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5DB12ED4F
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729671AbgABW0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:26:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:54734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729680AbgABW0z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:26:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E3DD21835;
        Thu,  2 Jan 2020 22:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004014;
        bh=1NEu7Yh/AB2e8ihR5dZl/HrmOElxNkdZTdVug8DSseU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oemDwsdVhOR/QsQi7bNBFIlp0iiFNseDMEDTioy5aS5plardBuVnYc8tFiLXAmbXd
         RJW1Gr1INQgn66EkBU61rfYMNE2n9PrvD232xNjSjeLyu4tKaOG9PFjzgsUEcdTw6/
         KF/T6cMGT+IxZO+oPjs2n+yqY7i13rEDKiINcIDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 4.14 86/91] gtp: do not allow adding duplicate tid and ms_addr pdp context
Date:   Thu,  2 Jan 2020 23:08:08 +0100
Message-Id: <20200102220451.840898460@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220356.856162165@linuxfoundation.org>
References: <20200102220356.856162165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 6b01b1d9b2d38dc84ac398bfe9f00baff06a31e5 ]

GTP RX packet path lookups pdp context with TID. If duplicate TID pdp
contexts are existing in the list, it couldn't select correct pdp context.
So, TID value  should be unique.
GTP TX packet path lookups pdp context with ms_addr. If duplicate ms_addr pdp
contexts are existing in the list, it couldn't select correct pdp context.
So, ms_addr value should be unique.

Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/gtp.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -929,24 +929,31 @@ static void ipv4_pdp_fill(struct pdp_ctx
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
@@ -954,6 +961,11 @@ static int ipv4_pdp_add(struct gtp_dev *
 		if (info->nlhdr->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
+		if (pctx && pctx_tid)
+			return -EEXIST;
+		if (!pctx)
+			pctx = pctx_tid;
+
 		ipv4_pdp_fill(pctx, info);
 
 		if (pctx->gtp_version == GTP_V0)
@@ -1077,7 +1089,7 @@ static int gtp_genl_new_pdp(struct sk_bu
 		goto out_unlock;
 	}
 
-	err = ipv4_pdp_add(gtp, sk, info);
+	err = gtp_pdp_add(gtp, sk, info);
 
 out_unlock:
 	rcu_read_unlock();


