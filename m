Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34622F9E5C
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390413AbhARLhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:37:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390305AbhARLhq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:37:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14CAB222B3;
        Mon, 18 Jan 2021 11:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969810;
        bh=+wQtXzb4CYkFsY1DUTqvgR7g5+ZTp/nIge4oYb+8L5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1aMF2qjhOlrkNy3lNXhLLndRFLxOrvkRQKAVMGyy7Mz1vtWREjChNCN0bYxVOAgXQ
         lpZI2f3bendIlwdB38c4HTENozivJwZxnikHyEUYVev0fOv3iLJwn/U2mrOuHjh6PY
         VTF87O/iHoHULKmRBScPUahRagl5vsZJSxsdL4X0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 4.19 34/43] RDMA/usnic: Fix memleak in find_free_vf_and_create_qp_grp
Date:   Mon, 18 Jan 2021 12:34:57 +0100
Message-Id: <20210118113336.600317415@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113334.966227881@linuxfoundation.org>
References: <20210118113334.966227881@linuxfoundation.org>
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
@@ -212,6 +212,7 @@ find_free_vf_and_create_qp_grp(struct us
 
 		}
 		usnic_uiom_free_dev_list(dev_list);
+		dev_list = NULL;
 	}
 
 	/* Try to find resources on an unused vf */
@@ -236,6 +237,8 @@ find_free_vf_and_create_qp_grp(struct us
 qp_grp_check:
 	if (IS_ERR_OR_NULL(qp_grp)) {
 		usnic_err("Failed to allocate qp_grp\n");
+		if (usnic_ib_share_vf)
+			usnic_uiom_free_dev_list(dev_list);
 		return ERR_PTR(qp_grp ? PTR_ERR(qp_grp) : -ENOMEM);
 	}
 	return qp_grp;


