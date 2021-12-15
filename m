Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A17475E88
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245282AbhLORWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:22:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40060 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245321AbhLORWp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:22:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80B3BB8202E;
        Wed, 15 Dec 2021 17:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B932DC36AE0;
        Wed, 15 Dec 2021 17:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639588962;
        bh=MpBs7xA/RsQa6OVnZ3KLJxt45cuRmRkrsss4VshUJZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CPLowfcPzvNc40Cq/u6VeA1UUIZrtrl4/gY6jMk4+nGJ+ph3SE0hNEouFYv/4tk5P
         Wfki+aE+36BVQ5gGCX8X+wZhEQo017CP9GahEbXiADMV1fHYqwj35x0SNfYSizYxWr
         PzPukv9hrQTfOg18kQLdg02yn0MpkQa3RkMHEkdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 14/42] RDMA/irdma: Report correct WC errors
Date:   Wed, 15 Dec 2021 18:20:55 +0100
Message-Id: <20211215172027.131542665@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem@intel.com>

[ Upstream commit 25b5d6fd6d13b2de3780a0ae247befc43c4576fe ]

Return IBV_WC_REM_OP_ERR for responder QP errors instead of
IBV_WC_REM_ACCESS_ERR.

Return IBV_WC_LOC_QP_OP_ERR for errors detected on the SQ with bad opcodes

Fixes: 44d9e52977a1 ("RDMA/irdma: Implement device initialization definitions")
Link: https://lore.kernel.org/r/20211201231509.1930-1-shiraz.saleem@intel.com
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/hw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index 7de525a5ccf8c..7f58a1b9bb4f8 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -146,6 +146,7 @@ static void irdma_set_flush_fields(struct irdma_sc_qp *qp,
 		qp->flush_code = FLUSH_PROT_ERR;
 		break;
 	case IRDMA_AE_AMP_BAD_QP:
+	case IRDMA_AE_WQE_UNEXPECTED_OPCODE:
 		qp->flush_code = FLUSH_LOC_QP_OP_ERR;
 		break;
 	case IRDMA_AE_AMP_BAD_STAG_KEY:
@@ -156,7 +157,6 @@ static void irdma_set_flush_fields(struct irdma_sc_qp *qp,
 	case IRDMA_AE_PRIV_OPERATION_DENIED:
 	case IRDMA_AE_IB_INVALID_REQUEST:
 	case IRDMA_AE_IB_REMOTE_ACCESS_ERROR:
-	case IRDMA_AE_IB_REMOTE_OP_ERROR:
 		qp->flush_code = FLUSH_REM_ACCESS_ERR;
 		qp->event_type = IRDMA_QP_EVENT_ACCESS_ERR;
 		break;
@@ -184,6 +184,9 @@ static void irdma_set_flush_fields(struct irdma_sc_qp *qp,
 	case IRDMA_AE_AMP_MWBIND_INVALID_BOUNDS:
 		qp->flush_code = FLUSH_MW_BIND_ERR;
 		break;
+	case IRDMA_AE_IB_REMOTE_OP_ERROR:
+		qp->flush_code = FLUSH_REM_OP_ERR;
+		break;
 	default:
 		qp->flush_code = FLUSH_FATAL_ERR;
 		break;
-- 
2.33.0



