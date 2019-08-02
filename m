Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBAE17F3CD
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392154AbfHBJwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:52:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392162AbfHBJwG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:52:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65B7D2064A;
        Fri,  2 Aug 2019 09:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739525;
        bh=NDzdtxxf5CTPkR4noOJDNwcJusSCkxEjRhMXSxze9aQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=reMAv4ow5mjvPZBg+iMEVKyBpKl3Z7a+ch0ovBMtAv/CsvOas5WeSct5D+TZwFOLk
         Y3YHbERDQKefAY2XcJZa643fkNDVCy8EtzM8MJ6vbFWOwjPZ7Zk3g9Rf3hqMVeWv6v
         oPUJHkboO07RE7BB2W2H25zmmrQ8Szq+jytUESak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Changcheng Liu <changcheng.liu@aliyun.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 186/223] RDMA/i40iw: Set queue pair state when being queried
Date:   Fri,  2 Aug 2019 11:36:51 +0200
Message-Id: <20190802092249.575873998@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2e67e775845373905d2c2aecb9062c2c4352a535 ]

The API for ib_query_qp requires the driver to set qp_state and
cur_qp_state on return, add the missing sets.

Fixes: d37498417947 ("i40iw: add files for iwarp interface")
Signed-off-by: Changcheng Liu <changcheng.liu@aliyun.com>
Acked-by: Shiraz Saleem <shiraz.saleem@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 095912fb3201..c3d2400e36b9 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -812,6 +812,8 @@ static int i40iw_query_qp(struct ib_qp *ibqp,
 	struct i40iw_qp *iwqp = to_iwqp(ibqp);
 	struct i40iw_sc_qp *qp = &iwqp->sc_qp;
 
+	attr->qp_state = iwqp->ibqp_state;
+	attr->cur_qp_state = attr->qp_state;
 	attr->qp_access_flags = 0;
 	attr->cap.max_send_wr = qp->qp_uk.sq_size;
 	attr->cap.max_recv_wr = qp->qp_uk.rq_size;
-- 
2.20.1



