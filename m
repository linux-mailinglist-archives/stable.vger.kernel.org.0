Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0626333B820
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbhCOOCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232894AbhCOOAG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4250964F64;
        Mon, 15 Mar 2021 13:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816790;
        bh=c8KAdcG5B2JQKskhgtJjRsGY0l4cuauy7Qe4U1UDquQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FXFAp21Z8K76fod3LEu7plseQBJ5BmxfjmFW6WoLERrzD0ao6DGErsKoQ86Oe5vGl
         6Kt9DPTKPgC0UmybihPQZgyARn/qiKk4Y495NdeJOvwW8KWg1b+tymVV7LoBjxbdyp
         bFGj3BeEgNIZKUVVw2d42WpHsLYx5CUYD0aUD2nY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Crispin <john@phrozen.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/290] net: dsa: tag_qca: let DSA core deal with TX reallocation
Date:   Mon, 15 Mar 2021 14:53:29 +0100
Message-Id: <20210315135545.841674579@linuxfoundation.org>
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

[ Upstream commit 9bbda29ae1044bc4c1c01a5b7c44688c4765785f ]

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Cc: John Crispin <john@phrozen.org>
Cc: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_qca.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index 1b9e8507112b..88181b52f480 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -34,9 +34,6 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 	__be16 *phdr;
 	u16 hdr;
 
-	if (skb_cow_head(skb, QCA_HDR_LEN) < 0)
-		return NULL;
-
 	skb_push(skb, QCA_HDR_LEN);
 
 	memmove(skb->data, skb->data + QCA_HDR_LEN, 2 * ETH_ALEN);
-- 
2.30.1



