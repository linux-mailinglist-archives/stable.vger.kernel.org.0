Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83511201476
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391732AbgFSQKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:10:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391417AbgFSPGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:06:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B209721835;
        Fri, 19 Jun 2020 15:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579183;
        bh=MR39vtB/C9XrQbTfXckuJXqd4TZpcXNPYMB/BQEKY5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O2IoPdVnJzdhyr90Hx9OibI1Bsy3bTCqYN4hM4YrBQppl0KDqNEKvrhcPRACe2tIE
         SohjKpDwIP3IUQ7XhA9K7Xkmq64LOHnl0X5Xv9BQc5Ljprfrq+GToNAf+M+PQ4aye5
         v5IZMZYnUkXLXCdq79waBeXC98iHl2K5H4XIhe58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tuan Phan <tuanphan@os.amperecomputing.com>,
        Hanjun Guo <guoahanjun@huawei.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/261] ACPI/IORT: Fix PMCG node single ID mapping handling
Date:   Fri, 19 Jun 2020 16:30:50 +0200
Message-Id: <20200619141651.794880896@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuan Phan <tuanphan@os.amperecomputing.com>

[ Upstream commit 50c8ab8d9fbf5b18d5162a797ca26568afc0af1a ]

An IORT PMCG node can have no ID mapping if its overflow interrupt is
wire based therefore the code that parses the PMCG node can not assume
the node will always have a single mapping present at index 0.

Fix iort_get_id_mapping_index() by checking for an overflow interrupt
and mapping count.

Fixes: 24e516049360 ("ACPI/IORT: Add support for PMCG")

Signed-off-by: Tuan Phan <tuanphan@os.amperecomputing.com>
Reviewed-by: Hanjun Guo <guoahanjun@huawei.com>
Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Link: https://lore.kernel.org/r/1589994787-28637-1-git-send-email-tuanphan@os.amperecomputing.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/arm64/iort.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
index 5a7551d060f2..bc95a5eebd13 100644
--- a/drivers/acpi/arm64/iort.c
+++ b/drivers/acpi/arm64/iort.c
@@ -361,6 +361,7 @@ static struct acpi_iort_node *iort_node_get_id(struct acpi_iort_node *node,
 static int iort_get_id_mapping_index(struct acpi_iort_node *node)
 {
 	struct acpi_iort_smmu_v3 *smmu;
+	struct acpi_iort_pmcg *pmcg;
 
 	switch (node->type) {
 	case ACPI_IORT_NODE_SMMU_V3:
@@ -388,6 +389,10 @@ static int iort_get_id_mapping_index(struct acpi_iort_node *node)
 
 		return smmu->id_mapping_index;
 	case ACPI_IORT_NODE_PMCG:
+		pmcg = (struct acpi_iort_pmcg *)node->node_data;
+		if (pmcg->overflow_gsiv || node->mapping_count == 0)
+			return -EINVAL;
+
 		return 0;
 	default:
 		return -EINVAL;
-- 
2.25.1



