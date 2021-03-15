Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F29C33B882
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234498AbhCOODp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:03:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232774AbhCOOAT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39A9C64F0D;
        Mon, 15 Mar 2021 14:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816803;
        bh=A7KzmZ+7cPokMkxJwj/neEjsw5DbcgWD6TSvAQxWBH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBkABgGBsuJ1XIFCJuNb70gr3xgzMWNQ1S5DgxaR59BTwGij54LkdGu9qp1vdHIyf
         jCXDH27MD0J/Vd6gMVJQntVWW7uDquIW5hCFu1MgzQiwlpeigddHAQD9B/ywfTjgk9
         Jrre7Jo8EgkL32tFxCfnZx5ax0zPQYGVrUVj7olY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 123/290] net: dsa: tag_gswip: let DSA core deal with TX reallocation
Date:   Mon, 15 Mar 2021 14:53:36 +0100
Message-Id: <20210315135546.070226001@linuxfoundation.org>
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

[ Upstream commit 9b9826ae117f211bcbdc75db844d5fd8b159fc59 ]

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

This one is interesting, the DSA tag is 8 bytes on RX and 4 bytes on TX.
Because DSA is unaware of asymmetrical tag lengths, the overhead/needed
headroom is declared as 8 bytes and therefore 4 bytes larger than it
needs to be. If this becomes a problem, and the GSWIP driver can't be
converted to a uniform header length, we might need to make DSA aware of
separate RX/TX overhead values.

Cc: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_gswip.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/dsa/tag_gswip.c b/net/dsa/tag_gswip.c
index 408d4af390a0..2f5bd5e338ab 100644
--- a/net/dsa/tag_gswip.c
+++ b/net/dsa/tag_gswip.c
@@ -60,13 +60,8 @@ static struct sk_buff *gswip_tag_xmit(struct sk_buff *skb,
 				      struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	int err;
 	u8 *gswip_tag;
 
-	err = skb_cow_head(skb, GSWIP_TX_HEADER_LEN);
-	if (err)
-		return NULL;
-
 	skb_push(skb, GSWIP_TX_HEADER_LEN);
 
 	gswip_tag = skb->data;
-- 
2.30.1



