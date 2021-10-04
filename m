Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C46420F87
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbhJDNfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:35:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237041AbhJDNds (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:33:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4575563231;
        Mon,  4 Oct 2021 13:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353323;
        bh=NjK0VONX59kuUgZNW4kpqcg7X7vcUvRcsgH3Cjz61CA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F2fgfIA0scHGnemZ6u+rV4kcj1jI/Gjwb73Jd4tC6hXZKNDngWMU+fcj63xtHHbAu
         P0Sq+7kdRlkVkMStzgENptPhWj8arPL313jL2g/MBuCXjo/piF1w1F0jn+8lWpxzHg
         c/dz9y8bXHi3e7WOBeuLxtXgAU5iWzkAqIxWwKHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sindhu Devale <sindhu.devale@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 083/172] RDMA/irdma: Validate number of CQ entries on create CQ
Date:   Mon,  4 Oct 2021 14:52:13 +0200
Message-Id: <20211004125047.670577370@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sindhu Devale <sindhu.devale@intel.com>

[ Upstream commit f4475f249445b3c1fb99919b0514a075b6d6b3d4 ]

Add lower bound check for CQ entries at creation time.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Link: https://lore.kernel.org/r/20210916191222.824-3-shiraz.saleem@intel.com
Signed-off-by: Sindhu Devale <sindhu.devale@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 6107f37321d2..6c3d28f744cb 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2040,7 +2040,7 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 		/* Kmode allocations */
 		int rsize;
 
-		if (entries > rf->max_cqe) {
+		if (entries < 1 || entries > rf->max_cqe) {
 			err_code = -EINVAL;
 			goto cq_free_rsrc;
 		}
-- 
2.33.0



