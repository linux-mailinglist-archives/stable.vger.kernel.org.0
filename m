Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF1E8F7F23
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbfKKSep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:34:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:52450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727498AbfKKSeo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:34:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96DED2173B;
        Mon, 11 Nov 2019 18:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497284;
        bh=Jlv9ukXX2oMCUigdyLnVYSC/Qt/S2pddvMuA9duPMcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uFz8EJvRBqHifok2T4X5uWnloqI8tPPKetdkJUNaiNQ5j6C/mhQAjfLJtuOrWRkgB
         PdlrJ4rdn+mvJNlabRscJ8hcrQe9xqNHZH21Gs/x05Amm46NRHZ365lZZtHnF2ZoCy
         J16m7o/Bk8oXeMuF4O6FrS0OdJBmTWKRVjq3NmYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dakshaja Uppalapati <dakshaja@chelsio.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 52/65] RDMA/iw_cxgb4: Avoid freeing skb twice in arp failure case
Date:   Mon, 11 Nov 2019 19:28:52 +0100
Message-Id: <20191111181351.621458821@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181331.917659011@linuxfoundation.org>
References: <20191111181331.917659011@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Potnuri Bharat Teja <bharat@chelsio.com>

[ Upstream commit d4934f45693651ea15357dd6c7c36be28b6da884 ]

_put_ep_safe() and _put_pass_ep_safe() free the skb before it is freed by
process_work(). fix double free by freeing the skb only in process_work().

Fixes: 1dad0ebeea1c ("iw_cxgb4: Avoid touch after free error in ARP failure handlers")
Link: https://lore.kernel.org/r/1572006880-5800-1-git-send-email-bharat@chelsio.com
Signed-off-by: Dakshaja Uppalapati <dakshaja@chelsio.com>
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index e5752352e0fb1..605d50ad123cc 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -490,7 +490,6 @@ static int _put_ep_safe(struct c4iw_dev *dev, struct sk_buff *skb)
 
 	ep = *((struct c4iw_ep **)(skb->cb + 2 * sizeof(void *)));
 	release_ep_resources(ep);
-	kfree_skb(skb);
 	return 0;
 }
 
@@ -501,7 +500,6 @@ static int _put_pass_ep_safe(struct c4iw_dev *dev, struct sk_buff *skb)
 	ep = *((struct c4iw_ep **)(skb->cb + 2 * sizeof(void *)));
 	c4iw_put_ep(&ep->parent_ep->com);
 	release_ep_resources(ep);
-	kfree_skb(skb);
 	return 0;
 }
 
-- 
2.20.1



