Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33D833B8E4
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbhCOOEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232957AbhCOOAW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17D4C64F66;
        Mon, 15 Mar 2021 14:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816805;
        bh=OlOpvOU5GIyrAwrw0RBzVM1WlqGG14kk1BefBGU9pzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQMnGx/rXikM1c1+1LrJEAkE7glZ1DrvMqSAHJbcYorMgJplYHzCcP+6do03BAR6G
         DLkgzw0tkVaX2KA9RkLIBIEd+BK77fyk/1oP9PA4o+d0YzBkIpZl+DETo/NoMi0OsS
         +cGtIzz1ISzusK2P1lQGl9XQNq5H+QTaPfYJ1bFg=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Per Forlin <per.forlin@axis.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/290] net: dsa: tag_ar9331: let DSA core deal with TX reallocation
Date:   Mon, 15 Mar 2021 14:53:37 +0100
Message-Id: <20210315135546.108648395@linuxfoundation.org>
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

[ Upstream commit 86c4ad9a7876777c12fd5a7010152e4141fcb94d ]

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Cc: Per Forlin <per.forlin@axis.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Oleksij Rempel <linux@rempel-privat.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_ar9331.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/dsa/tag_ar9331.c b/net/dsa/tag_ar9331.c
index 55b00694cdba..002cf7f952e2 100644
--- a/net/dsa/tag_ar9331.c
+++ b/net/dsa/tag_ar9331.c
@@ -31,9 +31,6 @@ static struct sk_buff *ar9331_tag_xmit(struct sk_buff *skb,
 	__le16 *phdr;
 	u16 hdr;
 
-	if (skb_cow_head(skb, AR9331_HDR_LEN) < 0)
-		return NULL;
-
 	phdr = skb_push(skb, AR9331_HDR_LEN);
 
 	hdr = FIELD_PREP(AR9331_HDR_VERSION_MASK, AR9331_HDR_VERSION);
-- 
2.30.1



