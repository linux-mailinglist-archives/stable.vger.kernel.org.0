Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E921482F8
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404434AbgAXLcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:32:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404431AbgAXLcT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:32:19 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74F7421556;
        Fri, 24 Jan 2020 11:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865539;
        bh=sl4NdRa+WOVYw8gmukFFneHGdSjLAGmayVkxy0HW92Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EiJtUAdUs7HWZ6qvXUfpMMEv1vPAmlFQtvblrHenDCUpYx3MTBvyybdSBVuzn7UaZ
         yo4JTXMGYgMCtzz2fUbqQA1A1o4FhWDTRviO7ttxSjeldChuCqRc1gItwtpH8vldqU
         hB5bKakIbr4wF4/TKTOjQOEIqBYtEZm5ggzV8XJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filippo Sironi <sironi@amazon.de>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 573/639] iommu/amd: Wait for completion of IOTLB flush in attach_device
Date:   Fri, 24 Jan 2020 10:32:23 +0100
Message-Id: <20200124093201.189937837@linuxfoundation.org>
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
index 9991386fb7000..bea19aa337587 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2153,6 +2153,8 @@ skip_ats_check:
 	 */
 	domain_flush_tlb_pde(domain);
 
+	domain_flush_complete(domain);
+
 	return ret;
 }
 
-- 
2.20.1



