Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D500233B825
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbhCOOCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232903AbhCOOAG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41AF264D9E;
        Mon, 15 Mar 2021 13:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816792;
        bh=+0Nz8HKkIPVZmCJ9gBvMAOuONetGn2ZfuTmsTBZRdyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HsqwoN1bRAUrFCQW+7A79aHL+M703vFxBMPRLUfKyJA6YOGWWHKWt1ZnC1wJdEQkX
         udmh7fU4Hfg9IUyXtPnxyBoXffwUQli6rpam+zVL+oUgHQ3/oSmPMgTTl30yPBcEjf
         mHugdTVXqh8SfUH+oeExqZv0gAZbQSKgOvxTjy3I=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/290] net: dsa: tag_ocelot: let DSA core deal with TX reallocation
Date:   Mon, 15 Mar 2021 14:53:30 +0100
Message-Id: <20210315135545.876382369@linuxfoundation.org>
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

[ Upstream commit 9c5c3bd00557e57c1049f7861f11e5e39f0fb42d ]

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_ocelot.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 3b468aca5c53..16a1afd5b8e1 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -143,13 +143,6 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 	struct ocelot_port *ocelot_port;
 	u8 *prefix, *injection;
 	u64 qos_class, rew_op;
-	int err;
-
-	err = skb_cow_head(skb, OCELOT_TOTAL_TAG_LEN);
-	if (unlikely(err < 0)) {
-		netdev_err(netdev, "Cannot make room for tag.\n");
-		return NULL;
-	}
 
 	ocelot_port = ocelot->ports[dp->index];
 
-- 
2.30.1



