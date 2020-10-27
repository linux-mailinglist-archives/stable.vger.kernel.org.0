Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD5C29BC0F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802606AbgJ0Pu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801365AbgJ0PlB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:41:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91A95223AB;
        Tue, 27 Oct 2020 15:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813259;
        bh=vkcZ4ad6+FpfWpO3Y3LV2OvlLL+b1E9MMSne2jfsDiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c6+H52BcBxsPKKSGbmQWpv9/b/KSJ1qIcmJ+LlVSyGoZ5i+HxnlJyCF7KGrpLbERr
         MlZaomVYaIIu82ay2VznWSgWSzfwHy12YHbf0H2qvCp6x71/tbcOYLfJUOBAUfN9QD
         czX+rAaQyWui8Ns/jdDYQ7+56N7oAGV7XJ9F3eFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 492/757] IB/rdmavt: Fix sizeof mismatch
Date:   Tue, 27 Oct 2020 14:52:22 +0100
Message-Id: <20201027135513.552333419@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index f904bb34477ae..2d534c450f3c8 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -95,9 +95,7 @@ struct rvt_dev_info *rvt_alloc_device(size_t size, int nports)
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



