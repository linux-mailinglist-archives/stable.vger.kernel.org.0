Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 197B6300CAB
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 20:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbhAVSjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:39:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:37758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728481AbhAVOSj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:18:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 902B223A80;
        Fri, 22 Jan 2021 14:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324841;
        bh=RDkRbcXx8V1I6np2hRV+dag2NKdprJnYdmNhGMMx09o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vrWYfEq4AyhnvyHcNqSeO7OOBLUqB0ytjeqF1xVoX0Xu+59UC1kDJzt44ipDhY+7i
         CW9TXs2hqVmPQ101uPsi9b7flQjtX4Rst/liMzRNWt5duKag7dWN3oXxO4FHK1gGa9
         BcYOtHG2Q602MbRz1bOomurthbfjpSQQC5BCgs3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 4.14 26/50] RDMA/usnic: Fix memleak in find_free_vf_and_create_qp_grp
Date:   Fri, 22 Jan 2021 15:12:07 +0100
Message-Id: <20210122135736.255731028@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.176469491@linuxfoundation.org>
References: <20210122135735.176469491@linuxfoundation.org>
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
@@ -188,6 +188,7 @@ find_free_vf_and_create_qp_grp(struct us
 
 		}
 		usnic_uiom_free_dev_list(dev_list);
+		dev_list = NULL;
 	}
 
 	/* Try to find resources on an unused vf */
@@ -212,6 +213,8 @@ find_free_vf_and_create_qp_grp(struct us
 qp_grp_check:
 	if (IS_ERR_OR_NULL(qp_grp)) {
 		usnic_err("Failed to allocate qp_grp\n");
+		if (usnic_ib_share_vf)
+			usnic_uiom_free_dev_list(dev_list);
 		return ERR_PTR(qp_grp ? PTR_ERR(qp_grp) : -ENOMEM);
 	}
 	return qp_grp;


