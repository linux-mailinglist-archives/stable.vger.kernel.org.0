Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BC833B965
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbhCOOCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232937AbhCOOAM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7E9764EEE;
        Mon, 15 Mar 2021 13:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816800;
        bh=DLoX+Xgb55NQV1cGPzEsQ5WFk/evGIURthxR/iPGl6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RLRGrGbkQm9d8QpGKmZuOd2o1uCL78ejwhj4vxZjcYR1yKCI90HGt3rQoDJN3igio
         UJwrBScIAOtZa8xtUzmh/FntanpUVRrT1XJf3cj98lhCxGojh1gk1Vcd/5z3JYV4Pq
         Du/iEFB9Lfm8+c6V4u7MrcWiEHr+fU+F7O7fYee4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/290] net: dsa: tag_brcm: let DSA core deal with TX reallocation
Date:   Mon, 15 Mar 2021 14:53:34 +0100
Message-Id: <20210315135546.009631211@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 2f0d030c5ffec6660f79a32b4f522155f75a9d71 ]

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_brcm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index ad72dff8d524..e934dace3922 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -66,9 +66,6 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
 	u16 queue = skb_get_queue_mapping(skb);
 	u8 *brcm_tag;
 
-	if (skb_cow_head(skb, BRCM_TAG_LEN) < 0)
-		return NULL;
-
 	/* The Ethernet switch we are interfaced with needs packets to be at
 	 * least 64 bytes (including FCS) otherwise they will be discarded when
 	 * they enter the switch port logic. When Broadcom tags are enabled, we
-- 
2.30.1



