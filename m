Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD233FDCC1
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345252AbhIAMxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:53:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345343AbhIAMvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:51:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 674C7611CA;
        Wed,  1 Sep 2021 12:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500148;
        bh=mhnDZFp6Bvgo7d3AsSNxcg0qsh7TMyBGCIQMQVcAJ2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wOJ/Q1xD4sAh3GIapSTnS2I0eKWh1BngWI8FJMvtVj2RGwKqXmia5w6H99zlBC7yz
         quIpTsZN1gQ20XzDCayyoruT2pNxJAo3heoWBTzZIukk+cWSTx2a5lhPA4ojLO48cC
         3PVplB6D2yJT30HVDxf+e4MIJ1VHuB5Q3MLnU9/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gerd Rausch <gerd.rausch@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 096/113] net/rds: dma_map_sg is entitled to merge entries
Date:   Wed,  1 Sep 2021 14:28:51 +0200
Message-Id: <20210901122305.158107773@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerd Rausch <gerd.rausch@oracle.com>

[ Upstream commit fb4b1373dcab086d0619c29310f0466a0b2ceb8a ]

Function "dma_map_sg" is entitled to merge adjacent entries
and return a value smaller than what was passed as "nents".

Subsequently "ib_map_mr_sg" needs to work with this value ("sg_dma_len")
rather than the original "nents" parameter ("sg_len").

This old RDS bug was exposed and reliably causes kernel panics
(using RDMA operations "rds-stress -D") on x86_64 starting with:
commit c588072bba6b ("iommu/vt-d: Convert intel iommu driver to the iommu ops")

Simply put: Linux 5.11 and later.

Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Link: https://lore.kernel.org/r/60efc69f-1f35-529d-a7ef-da0549cad143@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/ib_frmr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
index 9b6ffff72f2d..28c1b0022178 100644
--- a/net/rds/ib_frmr.c
+++ b/net/rds/ib_frmr.c
@@ -131,9 +131,9 @@ static int rds_ib_post_reg_frmr(struct rds_ib_mr *ibmr)
 		cpu_relax();
 	}
 
-	ret = ib_map_mr_sg_zbva(frmr->mr, ibmr->sg, ibmr->sg_len,
+	ret = ib_map_mr_sg_zbva(frmr->mr, ibmr->sg, ibmr->sg_dma_len,
 				&off, PAGE_SIZE);
-	if (unlikely(ret != ibmr->sg_len))
+	if (unlikely(ret != ibmr->sg_dma_len))
 		return ret < 0 ? ret : -EINVAL;
 
 	if (cmpxchg(&frmr->fr_state,
-- 
2.30.2



