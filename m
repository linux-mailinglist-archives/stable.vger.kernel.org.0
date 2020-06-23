Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DDA2063DB
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390995AbgFWVMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:12:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391249AbgFWUbw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:31:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5926206C3;
        Tue, 23 Jun 2020 20:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944312;
        bh=c4yeni8grAT1kmZn+C9x5k8KfW+RwDJ+0veXoyi5PPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jdu1/MoK22uTeR4NNwMN2/7GWh5mkB8S9eTJbiPDlpftg+nPGKFGaGuibXA+qmh/Q
         XJVyYks2gqoIo2BcJkgaVxZdPjBEVU9sPdxYLzR5Gu1v7y09L4cjtTRKF2WCoA3JUo
         2QJJyJMu1TjCujcTfYl6VfquclcxrkZEXSE3hlHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 255/314] nvme-pci: use simple suspend when a HMB is enabled
Date:   Tue, 23 Jun 2020 21:57:30 +0200
Message-Id: <20200623195351.127189989@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit b97120b15ebd3de51325084136d3b9c3cce656d6 ]

While the NVMe specification allows the device to access the host memory
buffer in host DRAM from all power states, hosts will fail access to
DRAM during S3 and similar power states.

Fixes: d916b1be94b6 ("nvme-pci: use host managed power state for suspend")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 1c2129493508f..a13cae1901962 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2971,9 +2971,15 @@ static int nvme_suspend(struct device *dev)
 	 * the PCI bus layer to put it into D3 in order to take the PCIe link
 	 * down, so as to allow the platform to achieve its minimum low-power
 	 * state (which may not be possible if the link is up).
+	 *
+	 * If a host memory buffer is enabled, shut down the device as the NVMe
+	 * specification allows the device to access the host memory buffer in
+	 * host DRAM from all power states, but hosts will fail access to DRAM
+	 * during S3.
 	 */
 	if (pm_suspend_via_firmware() || !ctrl->npss ||
 	    !pcie_aspm_enabled(pdev) ||
+	    ndev->nr_host_mem_descs ||
 	    (ndev->ctrl.quirks & NVME_QUIRK_SIMPLE_SUSPEND))
 		return nvme_disable_prepare_reset(ndev, true);
 
-- 
2.25.1



