Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6304037CE6A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240958AbhELRFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237888AbhELQnO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:43:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09A3661444;
        Wed, 12 May 2021 16:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836024;
        bh=NNPE9PcbUhNJ6CCi2lWmO181hl1VnNt3/WoPm54I5Ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pT92tjMpSub/C6WtaIhqtqSZkF7RhSCgTI9Ut7dgcH2El64CV1sA3eTE4Sr8YWSHt
         Gdw14I7uUnex8rZEufFgEZfJ4/S/EJsoPQI3QWxWhgILBjBaKmVvQcd9PwRY9w6SD9
         Bkk960im4v4g9QL/sa+vOfSjd5LLCaWmy4j3QTfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 580/677] iommu/vt-d: Fix an error handling path in intel_prepare_irq_remapping()
Date:   Wed, 12 May 2021 16:50:26 +0200
Message-Id: <20210512144856.655111172@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 745610c4a3e3baaebf6d1f8cd5b4d82892432520 ]

If 'intel_cap_audit()' fails, we should return directly, as already done in
the surrounding error handling path.

Fixes: ad3d19029979 ("iommu/vt-d: Audit IOMMU Capabilities and add helper functions")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/98d531caabe66012b4fffc7813fd4b9470afd517.1618124777.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/irq_remapping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index 611ef5243cb6..5c16ebe037a1 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -736,7 +736,7 @@ static int __init intel_prepare_irq_remapping(void)
 		return -ENODEV;
 
 	if (intel_cap_audit(CAP_AUDIT_STATIC_IRQR, NULL))
-		goto error;
+		return -ENODEV;
 
 	if (!dmar_ir_support())
 		return -ENODEV;
-- 
2.30.2



