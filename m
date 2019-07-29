Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A97CA7956A
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389334AbfG2TmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:42:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389316AbfG2TmU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:42:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A18292054F;
        Mon, 29 Jul 2019 19:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429339;
        bh=aXYymebGDijswDt5Qlb5JMim/POmyUbYkuzpcQQJ4I8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0bXh2NRFgbO8hgSZ1wwm1URL7sWoh662msSalM4YxjXs2hM+Hwck9DEVXBBrv6Lcl
         MybCw2SKp4zXvNjbAHtwFgYw0B/SiX4qCyf8ZILo4MDqriczavBNdf/9kGxhxnglOg
         GB7KgoKRN0YUgn/i52jK3Y61fTHT3aKml3s+WBbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Minghuan Lian <Minghuan.Lian@nxp.com>,
        Subrahmanya Lingappa <l.subrahmanya@mobiveil.co.in>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 065/113] PCI: mobiveil: Initialize Primary/Secondary/Subordinate bus numbers
Date:   Mon, 29 Jul 2019 21:22:32 +0200
Message-Id: <20190729190711.053065127@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6f3ab451aa5c2cbff33197d82fe8489cbd55ad91 ]

The reset value of Primary, Secondary and Subordinate bus numbers is
zero which is a broken setup.

Program a sensible default value for Primary/Secondary/Subordinate
bus numbers.

Signed-off-by: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Minghuan Lian <Minghuan.Lian@nxp.com>
Reviewed-by: Subrahmanya Lingappa <l.subrahmanya@mobiveil.co.in>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mobiveil.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/pci/controller/pcie-mobiveil.c b/drivers/pci/controller/pcie-mobiveil.c
index 3e81e68b5ce0..2fe7ebdad2d2 100644
--- a/drivers/pci/controller/pcie-mobiveil.c
+++ b/drivers/pci/controller/pcie-mobiveil.c
@@ -508,6 +508,12 @@ static int mobiveil_host_init(struct mobiveil_pcie *pcie)
 		return err;
 	}
 
+	/* setup bus numbers */
+	value = csr_readl(pcie, PCI_PRIMARY_BUS);
+	value &= 0xff000000;
+	value |= 0x00ff0100;
+	csr_writel(pcie, value, PCI_PRIMARY_BUS);
+
 	/*
 	 * program Bus Master Enable Bit in Command Register in PAB Config
 	 * Space
-- 
2.20.1



