Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0E8408FEF
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243440AbhIMNsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:48:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241556AbhIMNp7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:45:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37A1361242;
        Mon, 13 Sep 2021 13:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539913;
        bh=XF0uZ/NJuhtO93oLxSrCmNBUZFUFZrktfskP+lMO9hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i+gF2z4jupMC/jhqi2wqz9OnoVub1dnvPLdVx4FhsoWB5cUg3yrwn0pVhr7qbeohX
         s8VmoUsQWw4kErmgE2RQli+JxfsiomIdFolnsdjbUx4CRVz7X0wAj0rW204uz0sSv+
         jpx3JTZlhNI68gOLvlYHjgTcnBMg2flKhb+pcqf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 204/236] atlantic: Fix driver resume flow.
Date:   Mon, 13 Sep 2021 15:15:09 +0200
Message-Id: <20210913131107.320496103@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>

[ Upstream commit 57f780f1c43362b86fd23d20bd940e2468237716 ]

Driver crashes when restoring from the Hibernate. In the resume flow,
driver need to clean up the older nic/vec objects and re-initialize them.

Fixes: 8aaa112a57c1d ("net: atlantic: refactoring pm logic")
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index 59253846e885..f26d03735619 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -417,6 +417,9 @@ static int atl_resume_common(struct device *dev, bool deep)
 	pci_restore_state(pdev);
 
 	if (deep) {
+		/* Reinitialize Nic/Vecs objects */
+		aq_nic_deinit(nic, !nic->aq_hw->aq_nic_cfg->wol);
+
 		ret = aq_nic_init(nic);
 		if (ret)
 			goto err_exit;
-- 
2.30.2



