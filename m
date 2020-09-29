Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA9A27C749
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731138AbgI2Lwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:52:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730666AbgI2LrO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:47:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2137421941;
        Tue, 29 Sep 2020 11:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380033;
        bh=XyWyy+niajMmdGPwQsAAHQn0GIcP6F2aIX62zK1L8qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0zuY+cT6mDDemo5rIoTzFZU/tAtQIBYx9TwCf4su9M0f2V7KjXwp9sj9XF0Z/6uP/
         h/XigdvF06evDvgzuR7rzny+z1jSCslk/LRfG73BkP4yfF7zN1+9GR1IXtyVT10TqM
         bb3MMTCP8SkK4nRHrWvjejTYNiKHXzJ/cQaMIqww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Chopra <manishc@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 38/99] net: qede: Disable aRFS for NPAR and 100G
Date:   Tue, 29 Sep 2020 13:01:21 +0200
Message-Id: <20200929105931.602754697@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

[ Upstream commit 0367f05885b9f21d062447bd2ba1302ba3cc7392 ]

In some configurations ARFS cannot be used, so disable it if device
is not capable.

Fixes: e4917d46a653 ("qede: Add aRFS support")
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_filter.c |  3 +++
 drivers/net/ethernet/qlogic/qede/qede_main.c   | 11 +++++------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index fe72bb6c9455e..203cc76214c70 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -336,6 +336,9 @@ int qede_alloc_arfs(struct qede_dev *edev)
 {
 	int i;
 
+	if (!edev->dev_info.common.b_arfs_capable)
+		return -EINVAL;
+
 	edev->arfs = vzalloc(sizeof(*edev->arfs));
 	if (!edev->arfs)
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 29e285430f995..082055ee2d397 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -827,7 +827,7 @@ static void qede_init_ndev(struct qede_dev *edev)
 		      NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 		      NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_HW_TC;
 
-	if (!IS_VF(edev) && edev->dev_info.common.num_hwfns == 1)
+	if (edev->dev_info.common.b_arfs_capable)
 		hw_features |= NETIF_F_NTUPLE;
 
 	if (edev->dev_info.common.vxlan_enable ||
@@ -2278,7 +2278,7 @@ static void qede_unload(struct qede_dev *edev, enum qede_unload_mode mode,
 	qede_vlan_mark_nonconfigured(edev);
 	edev->ops->fastpath_stop(edev->cdev);
 
-	if (!IS_VF(edev) && edev->dev_info.common.num_hwfns == 1) {
+	if (edev->dev_info.common.b_arfs_capable) {
 		qede_poll_for_freeing_arfs_filters(edev);
 		qede_free_arfs(edev);
 	}
@@ -2345,10 +2345,9 @@ static int qede_load(struct qede_dev *edev, enum qede_load_mode mode,
 	if (rc)
 		goto err2;
 
-	if (!IS_VF(edev) && edev->dev_info.common.num_hwfns == 1) {
-		rc = qede_alloc_arfs(edev);
-		if (rc)
-			DP_NOTICE(edev, "aRFS memory allocation failed\n");
+	if (qede_alloc_arfs(edev)) {
+		edev->ndev->features &= ~NETIF_F_NTUPLE;
+		edev->dev_info.common.b_arfs_capable = false;
 	}
 
 	qede_napi_add_enable(edev);
-- 
2.25.1



