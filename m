Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72C547AE29
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238341AbhLTO6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239584AbhLTO4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:56:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C1CC08ECB4;
        Mon, 20 Dec 2021 06:49:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77BBE611A4;
        Mon, 20 Dec 2021 14:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59697C36AE7;
        Mon, 20 Dec 2021 14:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011741;
        bh=mJYwEo/a4YVK9lIvfX4OW9gonCo1Tyc4xQ/f9y/5oZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ysUSwJT4NTi0491wYlZLafPO/lObAZ450S676wuixeUeylF0IkX2mGpMIIRJAgzIx
         jPgMVS5NEylRknd1qX3wVb8Kvmwa68g0iwD5GoNZNauqiz/hCT89nZmBEC/gZ0P664
         5A8lKlgYPbbRhOiHha4nSRkjS3Q2xHfG40xp+1qY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 58/99] net: Fix double 0x prefix print in SKB dump
Date:   Mon, 20 Dec 2021 15:34:31 +0100
Message-Id: <20211220143031.340092116@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 8a03ef676ade55182f9b05115763aeda6dc08159 ]

When printing netdev features %pNF already takes care of the 0x prefix,
remove the explicit one.

Fixes: 6413139dfc64 ("skbuff: increase verbosity when dumping skb data")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 825e6b9880030..0215ae898e836 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -769,7 +769,7 @@ void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt)
 	       ntohs(skb->protocol), skb->pkt_type, skb->skb_iif);
 
 	if (dev)
-		printk("%sdev name=%s feat=0x%pNF\n",
+		printk("%sdev name=%s feat=%pNF\n",
 		       level, dev->name, &dev->features);
 	if (sk)
 		printk("%ssk family=%hu type=%u proto=%u\n",
-- 
2.33.0



