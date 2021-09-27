Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D4F419C68
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236459AbhI0R3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:29:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237428AbhI0R0Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:26:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6518D60240;
        Mon, 27 Sep 2021 17:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763000;
        bh=BYDeXjV6I4HBqvAXeJgqRcmSfKvidx5YI/DXAoxBqt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QhQJvYxZPhhpFYBiG9uiQ4fmfF9qRHpW6yBHKcshd/ZVU4uQirPrj3Lf6SaarMoQT
         qC1anfJv7IPXbOCm0IpiV61esVh6hqb6c/cWLWMgWHPqFfSbKS4h8tIVK4GxKra7oh
         FkwVRBYRLK2Z2QRFZianFz1BxCbd55uke1HndnjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 089/162] atlantic: Fix issue in the pm resume flow.
Date:   Mon, 27 Sep 2021 19:02:15 +0200
Message-Id: <20210927170236.509873039@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>

[ Upstream commit 4d88c339c423eefe2fd48215016cb0c75fcb4c4d ]

After fixing hibernation resume flow, another usecase was found which
should be explicitly handled - resume when device is in "down" state.
Invoke aq_nic_init jointly with aq_nic_start only if ndev was already
up during suspend/hibernate. We still need to perform nic_deinit() if
caller requests for it, to handle the freeze/resume scenarios.

Fixes: 57f780f1c433 ("atlantic: Fix driver resume flow.")
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index f26d03735619..5b996330f228 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -419,13 +419,13 @@ static int atl_resume_common(struct device *dev, bool deep)
 	if (deep) {
 		/* Reinitialize Nic/Vecs objects */
 		aq_nic_deinit(nic, !nic->aq_hw->aq_nic_cfg->wol);
+	}
 
+	if (netif_running(nic->ndev)) {
 		ret = aq_nic_init(nic);
 		if (ret)
 			goto err_exit;
-	}
 
-	if (netif_running(nic->ndev)) {
 		ret = aq_nic_start(nic);
 		if (ret)
 			goto err_exit;
-- 
2.33.0



