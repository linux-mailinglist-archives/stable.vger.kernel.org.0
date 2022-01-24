Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F165D499952
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454953AbiAXVeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:34:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37160 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448937AbiAXVOS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:14:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F6EF6141C;
        Mon, 24 Jan 2022 21:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353ABC340E5;
        Mon, 24 Jan 2022 21:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058856;
        bh=V/bcMqNPkVX/u08LsSoXhVbrVGRhAneAsOwIFiWm3F0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qny8aKexySmth3BreCq3Mnfc7yGjBund4Khv/z0IgdNvKkRNjuM16oABixLU3NhPh
         VGbe9XnvQ8s/UBIghpIPCdXP+6I2xe3c4KyhCAyx+Fn9GLwclSM0CiUgGxohWsy788
         js8vG12HsLWm89WOjieSKnIfBttm3Sw/GIofPPk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rakesh Babu Saladi <rsaladi2@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0424/1039] octeontx2-nicvf: Free VF PTP resources.
Date:   Mon, 24 Jan 2022 19:36:53 +0100
Message-Id: <20220124184139.559681839@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rakesh Babu Saladi <rsaladi2@marvell.com>

[ Upstream commit eabd0f88b0d2d433c5dfe88218d4ce1c11ef04b8 ]

When a VF is removed respective PTP resources are not
being freed currently. This patch fixes it.

Fixes: 43510ef4ddad ("octeontx2-nicvf: Add PTP hardware clock support to NIX VF")
Signed-off-by: Rakesh Babu Saladi <rsaladi2@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 78944ad3492ff..d75f3a78fabf1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -684,7 +684,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	err = register_netdev(netdev);
 	if (err) {
 		dev_err(dev, "Failed to register netdevice\n");
-		goto err_detach_rsrc;
+		goto err_ptp_destroy;
 	}
 
 	err = otx2_wq_init(vf);
@@ -709,6 +709,8 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 err_unreg_netdev:
 	unregister_netdev(netdev);
+err_ptp_destroy:
+	otx2_ptp_destroy(vf);
 err_detach_rsrc:
 	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
 		qmem_free(vf->dev, vf->dync_lmt);
@@ -742,6 +744,7 @@ static void otx2vf_remove(struct pci_dev *pdev)
 	unregister_netdev(netdev);
 	if (vf->otx2_wq)
 		destroy_workqueue(vf->otx2_wq);
+	otx2_ptp_destroy(vf);
 	otx2vf_disable_mbox_intr(vf);
 	otx2_detach_resources(&vf->mbox);
 	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
-- 
2.34.1



