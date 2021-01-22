Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7363004FE
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbhAVOLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:11:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:34362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728249AbhAVOKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:10:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50A3C23A5F;
        Fri, 22 Jan 2021 14:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324549;
        bh=Au9xa8xvz2mVntZXPNrBEMmN2TqLpr0/JMNfuFkoCOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ppaPsSwRcg1gxk/LRYaZ2yWTjexVj1wJncls0O6dpDpkKkmJaWgth+ydbkTdjC7js
         dXHcNwcOeQ7aBRiL8ce1x1FEszuz6QUwKspTw3yZepECTSXtjMmwCnAFMkDXYIQuuK
         rg+/C/Zp1AmuQMUIB4xK/EorVkJPNt9A9UaazjsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 4.4 16/31] RDMA/usnic: Fix memleak in find_free_vf_and_create_qp_grp
Date:   Fri, 22 Jan 2021 15:08:30 +0100
Message-Id: <20210122135732.521195496@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135731.873346566@linuxfoundation.org>
References: <20210122135731.873346566@linuxfoundation.org>
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
 


