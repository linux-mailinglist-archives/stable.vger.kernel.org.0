Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC211F4372
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731686AbgFIRxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:53:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726100AbgFIRxa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:53:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B01F020774;
        Tue,  9 Jun 2020 17:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725210;
        bh=eEi2BJJpFfnkUtBswv1aNYBxmzGniwh10zqbzAln51k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z6eKE9ZWHphkC+FX4qn26Jivqs1pQ8DtnGTRSs1eMdEHxmE8lxVlNor+giovZDaBj
         2IzNv8VkpPNmq+h68XYbp334cuj+Q8ZjDkfclxT8WI5zgK9IoTtksYsKXJeDhAw62H
         ZPuBS8/gtSbnSt0bwd71oU45aC0pFDFTb2HWlYDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Mark Bloch <markb@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.6 05/41] net/mlx5: Fix crash upon suspend/resume
Date:   Tue,  9 Jun 2020 19:45:07 +0200
Message-Id: <20200609174112.638366127@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174112.129412236@linuxfoundation.org>
References: <20200609174112.129412236@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

[ Upstream commit 8fc3e29be9248048f449793502c15af329f35c6e ]

Currently a Linux system with the mlx5 NIC always crashes upon
hibernation - suspend/resume.

Add basic callbacks so the NIC could be suspended and resumed.

Fixes: 9603b61de1ee ("mlx5: Move pci device handling from mlx5_ib to mlx5_core")
Tested-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1552,6 +1552,22 @@ static void shutdown(struct pci_dev *pde
 	mlx5_pci_disable_device(dev);
 }
 
+static int mlx5_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
+
+	mlx5_unload_one(dev, false);
+
+	return 0;
+}
+
+static int mlx5_resume(struct pci_dev *pdev)
+{
+	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
+
+	return mlx5_load_one(dev, false);
+}
+
 static const struct pci_device_id mlx5_core_pci_table[] = {
 	{ PCI_VDEVICE(MELLANOX, PCI_DEVICE_ID_MELLANOX_CONNECTIB) },
 	{ PCI_VDEVICE(MELLANOX, 0x1012), MLX5_PCI_DEV_IS_VF},	/* Connect-IB VF */
@@ -1595,6 +1611,8 @@ static struct pci_driver mlx5_core_drive
 	.id_table       = mlx5_core_pci_table,
 	.probe          = init_one,
 	.remove         = remove_one,
+	.suspend        = mlx5_suspend,
+	.resume         = mlx5_resume,
 	.shutdown	= shutdown,
 	.err_handler	= &mlx5_err_handler,
 	.sriov_configure   = mlx5_core_sriov_configure,


