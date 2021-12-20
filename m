Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B3647AC9E
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235848AbhLTOpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:45:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52574 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236517AbhLTOow (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:44:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89617B80EDE;
        Mon, 20 Dec 2021 14:44:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D556BC36AE7;
        Mon, 20 Dec 2021 14:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011490;
        bh=QOFSm/1oHATQPo5VBap0ryhBp/IKrq3+YYrtAMS22bU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AOGK04StP9lnrHlRAumyRPizVHnWnUuDVrC+r/AiTWPJViqljq1X6Rdol3pVobInr
         w4ccNHlNeb+RQ5Wf9RsQS7jr9Oup6CzYP6ckMyyOppVu9C7H0+Sa617uiSFLCV4mw2
         YRE8+RrLp4TM62/u1GFb4zrJKIhzApbF3ucqYNcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 40/71] net: Fix double 0x prefix print in SKB dump
Date:   Mon, 20 Dec 2021 15:34:29 +0100
Message-Id: <20211220143027.022549355@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
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
index 7dba091bc8617..ac083685214e0 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -768,7 +768,7 @@ void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt)
 	       ntohs(skb->protocol), skb->pkt_type, skb->skb_iif);
 
 	if (dev)
-		printk("%sdev name=%s feat=0x%pNF\n",
+		printk("%sdev name=%s feat=%pNF\n",
 		       level, dev->name, &dev->features);
 	if (sk)
 		printk("%ssk family=%hu type=%u proto=%u\n",
-- 
2.33.0



