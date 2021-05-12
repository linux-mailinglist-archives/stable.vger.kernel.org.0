Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F8037CC1A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243068AbhELQkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:40:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234863AbhELQcI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:32:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A780C61C26;
        Wed, 12 May 2021 15:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835105;
        bh=dXf5vGQwieSUUgoo/DezY1gSGpeymCL14N2PqbDveSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYo5/EvbZMfOcyZE9X3/sjQ+BW6pLRLRkQbmZHtZGeS5prfMJ391nVpNNuXo1zi2i
         Z6O2pLOUFKT+M1bTMdifwKkInJhj1pgQn1lj5c5nHm8fzG3dDt9NU0z98Mv1Dodvdo
         ONMag1lfaVIlIUcGC3bO/1ZxEGFVYS/HaEaoz6G8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 210/677] staging: qlge: fix an error code in probe()
Date:   Wed, 12 May 2021 16:44:16 +0200
Message-Id: <20210512144844.220920807@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit f7bff017741d98567265ed6a6449311a51810fb6 ]

If alloc_etherdev_mq() fails then return -ENOMEM instead of success.
The "err = 0;" triggers an unused assignment now so remove that as
well.

Fixes: 953b94009377 ("staging: qlge: Initialize devlink health dump framework")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YFiyicHI189PXrha@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/qlge/qlge_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 5516be3af898..c1d52190e1bd 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4550,7 +4550,7 @@ static int qlge_probe(struct pci_dev *pdev,
 	struct net_device *ndev = NULL;
 	struct devlink *devlink;
 	static int cards_found;
-	int err = 0;
+	int err;
 
 	devlink = devlink_alloc(&qlge_devlink_ops, sizeof(struct qlge_adapter));
 	if (!devlink)
@@ -4561,8 +4561,10 @@ static int qlge_probe(struct pci_dev *pdev,
 	ndev = alloc_etherdev_mq(sizeof(struct qlge_netdev_priv),
 				 min(MAX_CPUS,
 				     netif_get_num_default_rss_queues()));
-	if (!ndev)
+	if (!ndev) {
+		err = -ENOMEM;
 		goto devlink_free;
+	}
 
 	ndev_priv = netdev_priv(ndev);
 	ndev_priv->qdev = qdev;
-- 
2.30.2



