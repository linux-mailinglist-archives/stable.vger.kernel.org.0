Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD0023A562
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbgHCMg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:36:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729349AbgHCMfq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:35:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCA662054F;
        Mon,  3 Aug 2020 12:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596458145;
        bh=eKu6DjY96eDrcXdrf0WG2Xm8sTccD7/FHOeOGDcFR9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k700RWP6U/NG9Oe3qxuNUHU9/QveotIxMa0PxNcGdtbWdNj0PY0aZi5ZguGbKIMs4
         02uhIHufum/+a61ECemEjHf3GgLIuwsncJv2HFnE+c+pbDLwA07JlcykPLQzDeNzgP
         fUQ4eqj4TE4eARP5wKZwv5VSq+f54SYJHSNW1evQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 48/51] cxgb4: add missing release on skb in uld_send()
Date:   Mon,  3 Aug 2020 14:20:33 +0200
Message-Id: <20200803121851.916978977@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121849.488233135@linuxfoundation.org>
References: <20200803121849.488233135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit e6827d1abdc9b061a57d7b7d3019c4e99fabea2f ]

In the implementation of uld_send(), the skb is consumed on all
execution paths except one. Release skb when returning NET_XMIT_DROP.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 0a5c4c7da5052..006f8b8aaa7dc 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -1812,6 +1812,7 @@ static inline int uld_send(struct adapter *adap, struct sk_buff *skb,
 	txq_info = adap->sge.uld_txq_info[tx_uld_type];
 	if (unlikely(!txq_info)) {
 		WARN_ON(true);
+		kfree_skb(skb);
 		return NET_XMIT_DROP;
 	}
 
-- 
2.25.1



