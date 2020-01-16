Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C20B13F32E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390450AbgAPSlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:41:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:53516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389358AbgAPRLx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:11:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 767D824692;
        Thu, 16 Jan 2020 17:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194713;
        bh=9CDhK2Sd42pZ+PhVJnnuGEpUks1p1zRL9gxcUm+9XKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t6cEFPn87+n2PhdBSnuuwAcwfVHCu0JhrizWUFUX/TnU1RTqu9OtjrD+ZrFlx7kFz
         LYsvDJsBEufSZcb7o/JMFYAwkVzC+J9G54Wu8XdQaHS3/Y+nF7BHHEf0iUg+kWWTAV
         k3U/JlXDLfmpB8vfgQCoG9d8rbPETdElKv8ddTjI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 550/671] RDMA: Fix goto target to release the allocated memory
Date:   Thu, 16 Jan 2020 12:03:08 -0500
Message-Id: <20200116170509.12787-287-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 4a9d46a9fe14401f21df69cea97c62396d5fb053 ]

In bnxt_re_create_srq(), when ib_copy_to_udata() fails allocated memory
should be released by goto fail.

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Link: https://lore.kernel.org/r/20190910222120.16517-1-navid.emamdoost@gmail.com
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index bea8318e7007..a019ff266f52 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1446,7 +1446,7 @@ struct ib_srq *bnxt_re_create_srq(struct ib_pd *ib_pd,
 			dev_err(rdev_to_dev(rdev), "SRQ copy to udata failed!");
 			bnxt_qplib_destroy_srq(&rdev->qplib_res,
 					       &srq->qplib_srq);
-			goto exit;
+			goto fail;
 		}
 	}
 	if (nq)
-- 
2.20.1

