Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124BE23A705
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgHCMV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:21:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgHCMVT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:21:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8BCC204EC;
        Mon,  3 Aug 2020 12:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457278;
        bh=2lx6fiOAnloLslFPX4dhjxc7Ol++GN7voOrLJzKi1o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zzD+KytRrj1/9fid5SMDY1Y4QcVfUi64oN64gla3RZf0y255sqptZGSTNCebl0hiU
         h5s5sqhuf9UwCnPH5speB0ap8fW34VtMuukxcrMkZO7HFCGu5+wc6sct6kMaDwqc+S
         zTAyf7cqL/W5evdBnikWQBUaJcrm4OQ3UxpxhA88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.7 010/120] RDMA/mlx5: Fix prefetch memory leak if get_prefetchable_mr fails
Date:   Mon,  3 Aug 2020 14:17:48 +0200
Message-Id: <20200803121903.359637989@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

commit 5351a56b1a4ceafd7a17ebfdf3cda430cdfd365d upstream.

destroy_prefetch_work() must always be called if the work is not going
to be queued. The num_sge also should have been set to i, not i-1
which avoids the condition where it shouldn't have been called in the
first place.

Cc: stable@vger.kernel.org
Fixes: fb985e278a30 ("RDMA/mlx5: Use SRCU properly in ODP prefetch")
Link: https://lore.kernel.org/r/20200727095712.495652-1-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/odp.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1798,9 +1798,7 @@ static bool init_prefetch_work(struct ib
 		work->frags[i].mr =
 			get_prefetchable_mr(pd, advice, sg_list[i].lkey);
 		if (!work->frags[i].mr) {
-			work->num_sge = i - 1;
-			if (i)
-				destroy_prefetch_work(work);
+			work->num_sge = i;
 			return false;
 		}
 
@@ -1866,6 +1864,7 @@ int mlx5_ib_advise_mr_prefetch(struct ib
 	srcu_key = srcu_read_lock(&dev->odp_srcu);
 	if (!init_prefetch_work(pd, advice, pf_flags, work, sg_list, num_sge)) {
 		srcu_read_unlock(&dev->odp_srcu, srcu_key);
+		destroy_prefetch_work(work);
 		return -EINVAL;
 	}
 	queue_work(system_unbound_wq, &work->work);


