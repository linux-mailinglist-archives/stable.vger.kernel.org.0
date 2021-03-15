Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36FD433B831
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbhCOOCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232911AbhCOOAJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0626B64F60;
        Mon, 15 Mar 2021 13:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816794;
        bh=Z8fH5rlLGbIktJTLYhpbTjBBvJ/zwgnW0HG04SHLf1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j0HjS45uHK8/9Xw/xS6e2/F4Lc2w8rLc0gyjN3fEZJt0fIEKMS/xUr6tgxvbqHiO9
         mm3UskkKtvLk+ufwWDXcK1ak58H0oqnpk6E4nkradPlL/dltawwSEpJ/WUKjHttySr
         oX3XJSxzS2x52CT7ebIKrN1gRNjzj+Y3NwxM7LsY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 118/290] net: dsa: tag_mtk: let DSA core deal with TX reallocation
Date:   Mon, 15 Mar 2021 14:53:31 +0100
Message-Id: <20210315135545.908786704@linuxfoundation.org>
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

[ Upstream commit 941f66beb7bb4e0e4726aa31336d9ccc1c3a3dc2 ]

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Sean Wang <sean.wang@mediatek.com>
Cc: John Crispin <john@phrozen.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_mtk.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index 4cdd9cf428fb..38dcdded74c0 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -34,9 +34,6 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 	 * table with VID.
 	 */
 	if (!skb_vlan_tagged(skb)) {
-		if (skb_cow_head(skb, MTK_HDR_LEN) < 0)
-			return NULL;
-
 		skb_push(skb, MTK_HDR_LEN);
 		memmove(skb->data, skb->data + MTK_HDR_LEN, 2 * ETH_ALEN);
 		is_vlan_skb = false;
-- 
2.30.1



