Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8684C101422
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfKSFah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:30:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729151AbfKSFag (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:30:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0EA821783;
        Tue, 19 Nov 2019 05:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141436;
        bh=4c8T9lhoM24QU9yBAUVR0Cr0Z6EWI2IrsZQyZeiUGIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cWjm9GnDtByIbmnctOuF2PbkmTP/qDgvx8oZjRm+xbiw+E3Ut7e60a5H84cOi7MAO
         SQi5xOeaV0w/ZuxpMoCkclg7ISXCLIXXKJ7dsrPQ+I/fLtXA5FL5s8O62BoYiLUKcV
         ABg+BgDqbRUTIAuid7ROFmU3/b5EPIBwG/s6/8/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 160/422] RDMA/hns: Fix an error code in hns_roce_v2_init_eq_table()
Date:   Tue, 19 Nov 2019 06:15:57 +0100
Message-Id: <20191119051408.873974374@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit f1a315420e79fe5c077fa119db9439ffabd2cda2 ]

The error code isn't set on this path.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index cf878e1b71fc1..3f8e13190aa71 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5117,6 +5117,7 @@ static int hns_roce_v2_init_eq_table(struct hns_roce_dev *hr_dev)
 		create_singlethread_workqueue("hns_roce_irq_workqueue");
 	if (!hr_dev->irq_workq) {
 		dev_err(dev, "Create irq workqueue failed!\n");
+		ret = -ENOMEM;
 		goto err_request_irq_fail;
 	}
 
-- 
2.20.1



