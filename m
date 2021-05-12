Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1CDE37C58F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbhELPlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:41:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236116AbhELPhE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:37:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0050D61C46;
        Wed, 12 May 2021 15:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832702;
        bh=RxZkfmJ5GaHK2idvKUvSLAK5WC7auKNs2oyDJFi/+lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VA4Ayz4dtaR62Y1T7n8LjjW3M4S2dFNIVG12/G3bwqCo1W3CvAbm2xBZ+S0lcuo/G
         lrlgKWh+ElfWHCvENHOuZ+EGKncoIa4TSs05jyKWgBQoqS4PVqceBiVNcUqURL60Qq
         n1kmA5ROG18AYjI69qZQ2iOlWkAnNg4xKYrhh6uw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 388/530] iommu/vt-d: Dont set then clear private data in prq_event_thread()
Date:   Wed, 12 May 2021 16:48:18 +0200
Message-Id: <20210512144832.529053663@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 1d421058c815d54113d9afdf6db3f995c788cf0d ]

The VT-d specification (section 7.6) requires that the value in the
Private Data field of a Page Group Response Descriptor must match
the value in the Private Data field of the respective Page Request
Descriptor.

The private data field of a page group response descriptor is set then
immediately cleared in prq_event_thread(). This breaks the rule defined
by the VT-d specification. Fix it by moving clearing code up.

Fixes: 5b438f4ba315d ("iommu/vt-d: Support page request in scalable mode")
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Reviewed-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20210320024156.640798-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/svm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 5c95e9693bf5..d79639b5b8a9 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -1071,12 +1071,12 @@ no_pasid:
 				QI_PGRP_RESP_TYPE;
 			resp.qw1 = QI_PGRP_IDX(req->prg_index) |
 				QI_PGRP_LPIG(req->lpig);
+			resp.qw2 = 0;
+			resp.qw3 = 0;
 
 			if (req->priv_data_present)
 				memcpy(&resp.qw2, req->priv_data,
 				       sizeof(req->priv_data));
-			resp.qw2 = 0;
-			resp.qw3 = 0;
 			qi_submit_sync(iommu, &resp, 1, 0);
 		}
 prq_advance:
-- 
2.30.2



