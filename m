Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29322329074
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242928AbhCAUIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:08:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242338AbhCAT5K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:57:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9285D65388;
        Mon,  1 Mar 2021 17:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621363;
        bh=8UDkSKJlDrC4FnP4WTHr4ryIuize/DgRuwd7VjbSmLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p94cRjszpF2Wl2aDxnjcVLsfBacD1NPkj/wraGDYIofR2EJiFt9R3mc/mmAKg6PMf
         bN9Lu5RjTi6tl4SyUu/YwYIYU2SQooL13lmfNVz3d9DUjB3yVbuetPJr1MaUQAsOAi
         WsXzdGd/m9oNGzNHjDtRG8FJS+yzlvDQACLDbXhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 488/775] PCI: xilinx-cpm: Fix reference count leak on error path
Date:   Mon,  1 Mar 2021 17:10:56 +0100
Message-Id: <20210301161225.646629811@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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



