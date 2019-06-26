Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7053560EF
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfFZDuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:50:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726849AbfFZDlk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:41:40 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-74.mobile.att.net [107.77.172.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC977214DA;
        Wed, 26 Jun 2019 03:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520499;
        bh=42DavxmMtdOChN4Oo9N6dOlybAxZJaVMXYFtZzoSW/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hnSsdWGT9jNveGAooIb4wdW5urd1OFoSu9ZwnEGyVNiyF8u+Sb291lOqI8C6qsNZl
         DW6VL17spALLCOiU4p34FMNvQyR/yYmdukvz0+H9fArof1jFd9zcEvyDJOI1xlY6vp
         7AVuFRwMaoyHRSRAdpPj9buX9hPa9OIEcaPxWQaE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.1 10/51] iommu/vt-d: Set the right field for Page Walk Snoop
Date:   Tue, 25 Jun 2019 23:40:26 -0400
Message-Id: <20190626034117.23247-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034117.23247-1-sashal@kernel.org>
References: <20190626034117.23247-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 66d78ad316b0e1ca5ae19663468554e2c0e31c26 ]

Set the page walk snoop to the right bit, otherwise the domain
id field will be overlapped.

Reported-by: Dave Jiang <dave.jiang@intel.com>
Fixes: 6f7db75e1c469 ("iommu/vt-d: Add second level page table interface")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel-pasid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-pasid.c b/drivers/iommu/intel-pasid.c
index 03b12d2ee213..fdf05c45d516 100644
--- a/drivers/iommu/intel-pasid.c
+++ b/drivers/iommu/intel-pasid.c
@@ -387,7 +387,7 @@ static inline void pasid_set_present(struct pasid_entry *pe)
  */
 static inline void pasid_set_page_snoop(struct pasid_entry *pe, bool value)
 {
-	pasid_set_bits(&pe->val[1], 1 << 23, value);
+	pasid_set_bits(&pe->val[1], 1 << 23, value << 23);
 }
 
 /*
-- 
2.20.1

