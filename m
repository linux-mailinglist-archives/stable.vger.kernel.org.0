Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55E6D148218
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391462AbgAXLZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:25:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391458AbgAXLZN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:25:13 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BE3F206D4;
        Fri, 24 Jan 2020 11:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865113;
        bh=Vv9erbEQQGavVsx826/tDXV2+GO6A1Maocox5xDS/ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itw01S6HSMqG/N++8h5WJTdre59pf7Ga26PwAi+lMxCvDQ6hNN/SMRL1sbPh0oZxk
         vqxnTRFCXmHvP7m5412S3yTdaW/un/jv63skLxjsmFB1B8znmEXokHmu9j4zZ8kXmk
         A9L7imw3nhsF/bXaG5Bn1PSuV3s/u4J8k4fkDmvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Mitchell <kevmitch@arista.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 457/639] iommu/amd: Make iommu_disable safer
Date:   Fri, 24 Jan 2020 10:30:27 +0100
Message-Id: <20200124093144.438370856@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Mitchell <kevmitch@arista.com>

[ Upstream commit 3ddbe913e55516d3e2165d43d4d5570761769878 ]

Make it safe to call iommu_disable during early init error conditions
before mmio_base is set, but after the struct amd_iommu has been added
to the amd_iommu_list. For example, this happens if firmware fails to
fill in mmio_phys in the ACPI table leading to a NULL pointer
dereference in iommu_feature_disable.

Fixes: 2c0ae1720c09c ('iommu/amd: Convert iommu initialization to state machine')
Signed-off-by: Kevin Mitchell <kevmitch@arista.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu_init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 1e9a5da562f0d..465f28a7844c2 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -422,6 +422,9 @@ static void iommu_enable(struct amd_iommu *iommu)
 
 static void iommu_disable(struct amd_iommu *iommu)
 {
+	if (!iommu->mmio_base)
+		return;
+
 	/* Disable command buffer */
 	iommu_feature_disable(iommu, CONTROL_CMDBUF_EN);
 
-- 
2.20.1



