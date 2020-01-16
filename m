Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 199F213FFDD
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390842AbgAPXVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:21:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:48946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390841AbgAPXVe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:21:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC40F20684;
        Thu, 16 Jan 2020 23:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216894;
        bh=UkKZKQjcFR/L9SdLEmzhc6Q5BcXNE8y+WPiXgyb7swc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rBXdlbWc3Xm9du4vagX0W0RH9t45yKbQNH7tYVOZcv5D+hTSAizWoeSCVbhvFQhby
         2OzfmKfk4bZLuFLcb5eIzEMBNKFGOB184ie/B2s7LT7wi2Em0Crfg7Ocmq/Q2cFZjO
         6dUAqnE81fif/mI+HQJUviT8K1m1TegDjLkM7eP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lang Cheng <chenglang@huawei.com>,
        Weihang Li <liweihang@hisilicon.com>,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH 5.4 063/203] RDMA/hns: Modify return value of restrack functions
Date:   Fri, 17 Jan 2020 00:16:20 +0100
Message-Id: <20200116231749.565691000@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lang Cheng <chenglang@huawei.com>

commit cfd82da4e741c16d71a12123bf0cb585af2b8796 upstream.

The restrack function return EINVAL instead of EMSGSIZE when the driver
operation fails.

Fixes: 4b42d05d0b2c ("RDMA/hns: Remove unnecessary kzalloc")
Signed-off-by: Lang Cheng <chenglang@huawei.com>
Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Link: https://lore.kernel.org/r/1567566885-23088-5-git-send-email-liweihang@hisilicon.com
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hns/hns_roce_restrack.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/hns/hns_roce_restrack.c
+++ b/drivers/infiniband/hw/hns/hns_roce_restrack.c
@@ -95,7 +95,7 @@ static int hns_roce_fill_res_cq_entry(st
 
 	ret = hr_dev->dfx->query_cqc_info(hr_dev, hr_cq->cqn, (int *)context);
 	if (ret)
-		goto err;
+		return -EINVAL;
 
 	table_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_DRIVER);
 	if (!table_attr) {


