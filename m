Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB96300511
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbhAVOO7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:14:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:34614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728284AbhAVOOF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:14:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AB3B23AC2;
        Fri, 22 Jan 2021 14:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324669;
        bh=Au9xa8xvz2mVntZXPNrBEMmN2TqLpr0/JMNfuFkoCOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yindkd1pLiXMlOCs0Mze9hHDAUi0DUjsh8IUwN8/8711QF5MN1ooDJMVgKO4/im/5
         Wn+Cuo0U6dA8Qd8uQxFzVT/nxTkbThqhxUzZjtRC3W5Qq3dllkszG/ULCRf9sS85ws
         94Lw9CUzr2lk43wXEpARAwemj6Lwum0U7uFJokMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 4.9 19/35] RDMA/usnic: Fix memleak in find_free_vf_and_create_qp_grp
Date:   Fri, 22 Jan 2021 15:10:21 +0100
Message-Id: <20210122135733.097978253@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135732.357969201@linuxfoundation.org>
References: <20210122135732.357969201@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

commit a306aba9c8d869b1fdfc8ad9237f1ed718ea55e6 upstream.

If usnic_ib_qp_grp_create() fails at the first call, dev_list
will not be freed on error, which leads to memleak.

Fixes: e3cf00d0a87f ("IB/usnic: Add Cisco VIC low-level hardware driver")
Link: https://lore.kernel.org/r/20201226074248.2893-1-dinghao.liu@zju.edu.cn
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -180,6 +180,7 @@ find_free_vf_and_create_qp_grp(struct us
 
 		}
 		usnic_uiom_free_dev_list(dev_list);
+		dev_list = NULL;
 	}
 
 	if (!found) {
@@ -207,6 +208,8 @@ find_free_vf_and_create_qp_grp(struct us
 	spin_unlock(&vf->lock);
 	if (IS_ERR_OR_NULL(qp_grp)) {
 		usnic_err("Failed to allocate qp_grp\n");
+		if (usnic_ib_share_vf)
+			usnic_uiom_free_dev_list(dev_list);
 		return ERR_PTR(qp_grp ? PTR_ERR(qp_grp) : -ENOMEM);
 	}
 


