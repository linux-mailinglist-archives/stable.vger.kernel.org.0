Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8BC4511E0
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236634AbhKOTPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:15:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:43004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244399AbhKOTOE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:14:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D0E66340E;
        Mon, 15 Nov 2021 18:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000448;
        bh=uaQ/xX6ZISWHFl6wXK0NvrL6eTNeJB9hrVLM22MBsbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t9o8pYo4me1xlmZq47cqFSZhZrIIHs4RQO2+oJ11GZVE6/veXRd5zKNDb2CG4ix4W
         G5SVcpV6F+yXs7cmRQZRFz9GtUivdsb1/7Ke4ojrBSJD5HVIDDrS7FX6oF077gS37R
         +EEGq/xWP6zqEKYAUtXvAEv44RNeFDRcfiTS4Yz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aharon Landau <aharonl@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 663/849] RDMA/core: Require the driver to set the IOVA correctly during rereg_mr
Date:   Mon, 15 Nov 2021 18:02:26 +0100
Message-Id: <20211115165442.693128694@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

[ Upstream commit f1a090f09f42be5a5542009f0be310fdb3e768fc ]

If the driver returns a new MR during rereg it has to fill it with the
IOVA from the proper source. If IB_MR_REREG_TRANS is set then the IOVA is
cmd.hca_va, otherwise the IOVA comes from the old MR. mlx5 for example has
two calls inside rereg_mr:

		return create_real_mr(new_pd, umem, mr->ibmr.iova,
				      new_access_flags);
and
		return create_real_mr(new_pd, new_umem, iova, new_access_flags);

Unconditionally overwriting the iova in the newly allocated MR will
corrupt the iova if the first path is used.

Remove the redundant initializations from ib_uverbs_rereg_mr().

Fixes: 6e0954b11c05 ("RDMA/uverbs: Allow drivers to create a new HW object during rereg_mr")
Link: https://lore.kernel.org/r/4b0a31bbc372842613286a10d7a8cbb0ee6069c7.1635400472.git.leonro@nvidia.com
Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 8c8ca7bce3caf..24dd550ceb119 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -837,11 +837,8 @@ static int ib_uverbs_rereg_mr(struct uverbs_attr_bundle *attrs)
 		new_mr->device = new_pd->device;
 		new_mr->pd = new_pd;
 		new_mr->type = IB_MR_TYPE_USER;
-		new_mr->dm = NULL;
-		new_mr->sig_attrs = NULL;
 		new_mr->uobject = uobj;
 		atomic_inc(&new_pd->usecnt);
-		new_mr->iova = cmd.hca_va;
 		new_uobj->object = new_mr;
 
 		rdma_restrack_new(&new_mr->res, RDMA_RESTRACK_MR);
-- 
2.33.0



