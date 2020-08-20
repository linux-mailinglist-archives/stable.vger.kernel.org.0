Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922A624BF0A
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729908AbgHTNjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:39:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728055AbgHTJ3O (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:29:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FD2B22CA1;
        Thu, 20 Aug 2020 09:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915753;
        bh=zpt2YetnxzLR/R4oNSBiaF+8lbYDDHmsyitJF7wm9mA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HsmBtBqGE4sPi35/4CVgdWDom3b2cHqR4w4uMi+o/48DOqB5kqXmSCIXgYaAPn5D3
         8a0axh+UdJ4ABS3AxBNeQKo1ViVNhXd0GRtM034UIaX2kGiAUXve1qOaMxF43C3fKp
         zs5yrn2/4JxrC/wK1EGQOYoLOde3UNj2bfX1X5JA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 121/232] RDMA/ipoib: Return void from ipoib_ib_dev_stop()
Date:   Thu, 20 Aug 2020 11:19:32 +0200
Message-Id: <20200820091618.677764561@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
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
index 9a3379c49541f..9ce6a36fe48ed 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -515,7 +515,7 @@ void ipoib_ib_dev_cleanup(struct net_device *dev);
 
 int ipoib_ib_dev_open_default(struct net_device *dev);
 int ipoib_ib_dev_open(struct net_device *dev);
-int ipoib_ib_dev_stop(struct net_device *dev);
+void ipoib_ib_dev_stop(struct net_device *dev);
 void ipoib_ib_dev_up(struct net_device *dev);
 void ipoib_ib_dev_down(struct net_device *dev);
 int ipoib_ib_dev_stop_default(struct net_device *dev);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index da3c5315bbb51..6ee64c25aaff4 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -846,7 +846,7 @@ int ipoib_ib_dev_stop_default(struct net_device *dev)
 	return 0;
 }
 
-int ipoib_ib_dev_stop(struct net_device *dev)
+void ipoib_ib_dev_stop(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
@@ -854,8 +854,6 @@ int ipoib_ib_dev_stop(struct net_device *dev)
 
 	clear_bit(IPOIB_FLAG_INITIALIZED, &priv->flags);
 	ipoib_flush_ah(dev);
-
-	return 0;
 }
 
 int ipoib_ib_dev_open_default(struct net_device *dev)
-- 
2.25.1



