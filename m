Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1DF72B6984
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 17:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgKQQKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 11:10:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:41962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbgKQQKa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 11:10:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F85B2467D;
        Tue, 17 Nov 2020 16:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605629429;
        bh=WYWEjT4lDX5/lkP5vF2QMGtyN9rB/hXvYbR9C0SxpuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPB6honUAgBQ+q6K0H7SJCnuRWp71EvL7rLvIT555GHmh3C8qi15yIbL9wdc1m9+W
         hkaoBLOi/Vf70ranhekz/YjobYh14f8JgPix/S8B2tqpeRk5NwwJ8ZKWIjEN9jPJSr
         B6f2vWmhemgDxrMDn5524fS2KGKA6yA73qi28V6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Liu, Yi L" <yi.l.liu@intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 024/151] iommu/vt-d: Fix a bug for PDP check in prq_event_thread
Date:   Tue, 17 Nov 2020 14:04:14 +0100
Message-Id: <20201117122122.585934640@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu, Yi L <yi.l.liu@intel.com>

[ Upstream commit 71cd8e2d16703a9df5c86a9e19f4cba99316cc53 ]

In prq_event_thread(), the QI_PGRP_PDP is wrongly set by
'req->pasid_present' which should be replaced to
'req->priv_data_present'.

Fixes: 5b438f4ba315 ("iommu/vt-d: Support page request in scalable mode")
Signed-off-by: Liu, Yi L <yi.l.liu@intel.com>
Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/1604025444-6954-3-git-send-email-yi.y.sun@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel-svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-svm.c b/drivers/iommu/intel-svm.c
index 1d3816cd65d57..ec69a99b99bab 100644
--- a/drivers/iommu/intel-svm.c
+++ b/drivers/iommu/intel-svm.c
@@ -646,7 +646,7 @@ static irqreturn_t prq_event_thread(int irq, void *d)
 			resp.qw0 = QI_PGRP_PASID(req->pasid) |
 				QI_PGRP_DID(req->rid) |
 				QI_PGRP_PASID_P(req->pasid_present) |
-				QI_PGRP_PDP(req->pasid_present) |
+				QI_PGRP_PDP(req->priv_data_present) |
 				QI_PGRP_RESP_CODE(result) |
 				QI_PGRP_RESP_TYPE;
 			resp.qw1 = QI_PGRP_IDX(req->prg_index) |
-- 
2.27.0



