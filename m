Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D8B37C276
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhELPKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:10:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233335AbhELPIc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:08:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B7916195B;
        Wed, 12 May 2021 15:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831716;
        bh=zXJ5vnl4BS3WSeN4C+Spk3lEBo6FTnHIjbFcCRYA38o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/It9afj1vkTEEak/HHCjIy4RSx+1mpAAsyarckApMEsbvpDDyDbLNJtH9bfK0wPl
         6WqFvRUCj/NwXzaY6Pca3n8sFUP+zD1DUfC9K7FKZUga+HkdDrgl7w0LehENdv9+tY
         XyEpyxS4yMPhRzlZbhYj7tYHF+UpsuoLGNw1macU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Wensheng <wangwensheng4@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 196/244] RDMA/srpt: Fix error return code in srpt_cm_req_recv()
Date:   Wed, 12 May 2021 16:49:27 +0200
Message-Id: <20210512144749.269483821@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Wensheng <wangwensheng4@huawei.com>

[ Upstream commit 6bc950beff0c440ac567cdc4e7f4542a9920953d ]

Fix to return a negative error code from the error handling case instead
of 0, as done elsewhere in this function.

Fixes: db7683d7deb2 ("IB/srpt: Fix login-related race conditions")
Link: https://lore.kernel.org/r/20210408113132.87250-1-wangwensheng4@huawei.com
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Wensheng <wangwensheng4@huawei.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 02b92e3cd9a8..2822ca5e8277 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2373,6 +2373,7 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 		pr_info("rejected SRP_LOGIN_REQ because target %s_%d is not enabled\n",
 			dev_name(&sdev->device->dev), port_num);
 		mutex_unlock(&sport->mutex);
+		ret = -EINVAL;
 		goto reject;
 	}
 
-- 
2.30.2



