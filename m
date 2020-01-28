Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7B1214BB11
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbgA1OLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:11:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:60676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728116AbgA1OLd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:11:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2ECD20678;
        Tue, 28 Jan 2020 14:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220692;
        bh=v4wkE3pqRqKWQUHiLFZCxVeJI+D7Ymg2N+kIRpv3zM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZblL/CAu9+SBYfkD15gytfUPP4utRejLn6tBQ+H0B18MSbEpAqEc/LbrMnCcDE945
         sjl5Q1WCydOCxdEZ7jYmZuCvr4RgbbCfWBCykrYfE+xScNPF+oXqMblvKgDB4r04zJ
         778IPiQ8U5jb+8q5q0FwSfZLMoedRk+ipn/W03AU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Mitchell <kevmitch@arista.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 107/183] iommu/amd: Make iommu_disable safer
Date:   Tue, 28 Jan 2020 15:05:26 +0100
Message-Id: <20200128135840.626944088@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
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
index 6a69b5bb231f8..036fb186a3bef 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -360,6 +360,9 @@ static void iommu_enable(struct amd_iommu *iommu)
 
 static void iommu_disable(struct amd_iommu *iommu)
 {
+	if (!iommu->mmio_base)
+		return;
+
 	/* Disable command buffer */
 	iommu_feature_disable(iommu, CONTROL_CMDBUF_EN);
 
-- 
2.20.1



