Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3B17147E12
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389076AbgAXKFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:05:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:42104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389231AbgAXKFc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:05:32 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F09E1218AC;
        Fri, 24 Jan 2020 10:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860332;
        bh=ZQJcr8zWH7QXXD6C2PQS8x5HXi5pY5gTQTAD7NXS2S4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YbkvpPM+4FCkSPmQqgwlV9iGtdkNuzQUciyXWgenOiv1DRQzWQ1vRTxp7qTSh/gMO
         Ucfi9xaf64jCExl3RBqgFrRjSM38BcZej+T8W2oxHTIjktNRisWmyJZDLCDBznSgFJ
         sBqFwrwS3gV8gzGbiwUUkf8eyynKFiZpV2O8NhxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filippo Sironi <sironi@amazon.de>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 307/343] iommu/amd: Wait for completion of IOTLB flush in attach_device
Date:   Fri, 24 Jan 2020 10:32:05 +0100
Message-Id: <20200124093000.246276106@linuxfoundation.org>
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

From: Filippo Sironi <sironi@amazon.de>

[ Upstream commit 0b15e02f0cc4fb34a9160de7ba6db3a4013dc1b7 ]

To make sure the domain tlb flush completes before the
function returns, explicitly wait for its completion.

Signed-off-by: Filippo Sironi <sironi@amazon.de>
Fixes: 42a49f965a8d ("amd-iommu: flush domain tlb when attaching a new device")
[joro: Added commit message and fixes tag]
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index d09c24825734e..778f167be2d35 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2160,6 +2160,8 @@ skip_ats_check:
 	 */
 	domain_flush_tlb_pde(domain);
 
+	domain_flush_complete(domain);
+
 	return ret;
 }
 
-- 
2.20.1



