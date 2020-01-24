Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D622147D76
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388804AbgAXKAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:00:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:36296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733301AbgAXKAv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:00:51 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A66520709;
        Fri, 24 Jan 2020 10:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860051;
        bh=uEHml99Vu7T5nMz6INsN49qJjRwyT1Zq+sMOwD2QEAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aWsa+Mz/gZ2TDnAWOQ2Ihg+RDlqX94xg4W+TlGT7jbiYUzcBCjizJbWAGa0P3SysO
         R/U99nMd50mJnZX6fsmitO2Aby3WXZ8cuSAABOR6KaJQA9ffsqz9OMBcieL/ZQRWQB
         rgwfudzqE68DQELsjgs+RGLSRQU4AtMZguHma0Qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Mitchell <kevmitch@arista.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 248/343] iommu/amd: Make iommu_disable safer
Date:   Fri, 24 Jan 2020 10:31:06 +0100
Message-Id: <20200124092952.707763954@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
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
index 6a3cf4d0bd5e3..4d2920988d607 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -420,6 +420,9 @@ static void iommu_enable(struct amd_iommu *iommu)
 
 static void iommu_disable(struct amd_iommu *iommu)
 {
+	if (!iommu->mmio_base)
+		return;
+
 	/* Disable command buffer */
 	iommu_feature_disable(iommu, CONTROL_CMDBUF_EN);
 
-- 
2.20.1



