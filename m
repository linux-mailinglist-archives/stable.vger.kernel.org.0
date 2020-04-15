Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58DC01AA272
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441303AbgDOMzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:55:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897204AbgDOLhF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:37:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41E6620857;
        Wed, 15 Apr 2020 11:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950625;
        bh=0NX5m65ZX918gnHGu6BeQVuUAFP1/jHZfec34UtVYrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JeB0uawFSum/O1VKR6XkQGVfWRquKsYQ7Qo+pd0HiZPqSi1EG9QIpPNxR8BzVfEIX
         2V2LXiIo7j+VVrBU95cbZD6P6ZH/oQijxkRgSvU8v95OFsIIQB/BmH56yQdzJhm2Qs
         X+sZERbfVx0ECT3i+SXysjFKP0njhP/KTz3sUTcI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.6 116/129] iommu/vt-d: Fix page request descriptor size
Date:   Wed, 15 Apr 2020 07:34:31 -0400
Message-Id: <20200415113445.11881-116-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

[ Upstream commit 52355fb1919ef7ed9a38e0f3de6e928de1f57217 ]

Intel VT-d might support PRS (Page Reqest Support) when it's
running in the scalable mode. Each page request descriptor
occupies 32 bytes and is 32-bytes aligned. The page request
descriptor offset mask should be 32-bytes aligned.

Fixes: 5b438f4ba315d ("iommu/vt-d: Support page request in scalable mode")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel-svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-svm.c b/drivers/iommu/intel-svm.c
index fc7d78876e021..2998418f0a383 100644
--- a/drivers/iommu/intel-svm.c
+++ b/drivers/iommu/intel-svm.c
@@ -531,7 +531,7 @@ struct page_req_dsc {
 	u64 priv_data[2];
 };
 
-#define PRQ_RING_MASK ((0x1000 << PRQ_ORDER) - 0x10)
+#define PRQ_RING_MASK	((0x1000 << PRQ_ORDER) - 0x20)
 
 static bool access_error(struct vm_area_struct *vma, struct page_req_dsc *req)
 {
-- 
2.20.1

