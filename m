Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE0A32899C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhCASAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:00:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:49712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237418AbhCARyI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:54:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC93D65202;
        Mon,  1 Mar 2021 17:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619296;
        bh=8UDkSKJlDrC4FnP4WTHr4ryIuize/DgRuwd7VjbSmLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KR9SuKfcbmDeXP3iOToPKhDXjUeRbgEaUq9R4AosZqgJkk8w00c3kfc0gXmk4/jYR
         r/aTHlcFDWL9hbcUHyazZdDyR3Sj65u8rPSXYvSEmGWPyVLU8oXBZcf3oyX35HcOzc
         6HN0laoyjrwQ3WzkBNOyeNGIIEGXKnry68GrvUXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 404/663] PCI: xilinx-cpm: Fix reference count leak on error path
Date:   Mon,  1 Mar 2021 17:10:52 +0100
Message-Id: <20210301161201.857764552@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit ae191d2e513ae5274224777ae67018a584074a28 ]

Also drop the reference count of the node on error path.

Link: https://lore.kernel.org/r/20210120143745.699-1-bianpan2016@163.com
Fixes: 508f610648b9 ("PCI: xilinx-cpm: Add Versal CPM Root Port driver")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-xilinx-cpm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/pcie-xilinx-cpm.c b/drivers/pci/controller/pcie-xilinx-cpm.c
index f92e0152e65e3..67937facd90cd 100644
--- a/drivers/pci/controller/pcie-xilinx-cpm.c
+++ b/drivers/pci/controller/pcie-xilinx-cpm.c
@@ -404,6 +404,7 @@ static int xilinx_cpm_pcie_init_irq_domain(struct xilinx_cpm_pcie_port *port)
 	return 0;
 out:
 	xilinx_cpm_free_irq_domains(port);
+	of_node_put(pcie_intc_node);
 	dev_err(dev, "Failed to allocate IRQ domains\n");
 
 	return -ENOMEM;
-- 
2.27.0



