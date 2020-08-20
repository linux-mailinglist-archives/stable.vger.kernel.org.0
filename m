Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC24824B739
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730798AbgHTKPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:15:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731008AbgHTKPH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:15:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BF4020738;
        Thu, 20 Aug 2020 10:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918506;
        bh=LIyGF576MagAjqOt06FNqkLGN4XwGvEsX1dTekAscic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ABp2YiZVAGI2/rvW3Ll+ufHJo/oMM+SFw1xlrQzN8zetO8yUKBaKEg5YSpgftPfmu
         lkGGSvd5WQYAONhRYCVoNGg19RykL1yAVjhBxvzLqZ+VQqfR/cXOvQXWz30yDBureA
         YSrIpkmZIzLAQZbck0miolFAzSH8d7tvr0Erccso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 196/228] RDMA/ipoib: Return void from ipoib_ib_dev_stop()
Date:   Thu, 20 Aug 2020 11:22:51 +0200
Message-Id: <20200820091617.361805582@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

[ Upstream commit 95a5631f6c9f3045f26245e6045244652204dfdb ]

The return value from ipoib_ib_dev_stop() is always 0 - change it to be
void.

Link: https://lore.kernel.org/r/20200623105236.18683-1-kamalheib1@gmail.com
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h    | 2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c | 4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 4a5c7a07a6315..268e23ba4a636 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -509,7 +509,7 @@ void ipoib_ib_dev_cleanup(struct net_device *dev);
 
 int ipoib_ib_dev_open_default(struct net_device *dev);
 int ipoib_ib_dev_open(struct net_device *dev);
-int ipoib_ib_dev_stop(struct net_device *dev);
+void ipoib_ib_dev_stop(struct net_device *dev);
 void ipoib_ib_dev_up(struct net_device *dev);
 void ipoib_ib_dev_down(struct net_device *dev);
 int ipoib_ib_dev_stop_default(struct net_device *dev);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index d77e8e2ae05f2..8e1f48fe6f2e7 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -809,7 +809,7 @@ int ipoib_ib_dev_stop_default(struct net_device *dev)
 	return 0;
 }
 
-int ipoib_ib_dev_stop(struct net_device *dev)
+void ipoib_ib_dev_stop(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
@@ -817,8 +817,6 @@ int ipoib_ib_dev_stop(struct net_device *dev)
 
 	clear_bit(IPOIB_FLAG_INITIALIZED, &priv->flags);
 	ipoib_flush_ah(dev);
-
-	return 0;
 }
 
 void ipoib_ib_tx_timer_func(unsigned long ctx)
-- 
2.25.1



