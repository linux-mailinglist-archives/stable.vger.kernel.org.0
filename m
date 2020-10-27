Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61B329C5D2
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754825AbgJ0OOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:14:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2507943AbgJ0OOH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:14:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEC432076A;
        Tue, 27 Oct 2020 14:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808046;
        bh=gDvY7EcElQuD5rxYTGAzgrnYsOghs9yk0ptOGQ5v1BM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=soO6E74X/TV6X9kmuc7oCVb2fbFqsy5tDGdCiRHKGpppCM1KJfsSLdGX6ROfMhrwq
         rKlFORaiAH+MQGKrG1BhKDWIWhGel1Kq0BzunFTtC8qg+FhGPBNcddRD01HpW3kUum
         7ms00RVfbjHr2HSUK/XZpQQs1KrBpwy/Iwk9n9os=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 105/191] IB/rdmavt: Fix sizeof mismatch
Date:   Tue, 27 Oct 2020 14:49:20 +0100
Message-Id: <20201027134914.745642930@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 8e71f694e0c819db39af2336f16eb9689f1ae53f ]

An incorrect sizeof is being used, struct rvt_ibport ** is not correct, it
should be struct rvt_ibport *. Note that since ** is the same size as
* this is not causing any issues.  Improve this fix by using
sizeof(*rdi->ports) as this allows us to not even reference the type
of the pointer.  Also remove line breaks as the entire statement can
fit on one line.

Link: https://lore.kernel.org/r/20201008095204.82683-1-colin.king@canonical.com
Addresses-Coverity: ("Sizeof not portable (SIZEOF_MISMATCH)")
Fixes: ff6acd69518e ("IB/rdmavt: Add device structure allocation")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Acked-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rdmavt/vt.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 64bdd442078a1..03a367db38e6d 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -97,9 +97,7 @@ struct rvt_dev_info *rvt_alloc_device(size_t size, int nports)
 	if (!rdi)
 		return rdi;
 
-	rdi->ports = kcalloc(nports,
-			     sizeof(struct rvt_ibport **),
-			     GFP_KERNEL);
+	rdi->ports = kcalloc(nports, sizeof(*rdi->ports), GFP_KERNEL);
 	if (!rdi->ports)
 		ib_dealloc_device(&rdi->ibdev);
 
-- 
2.25.1



