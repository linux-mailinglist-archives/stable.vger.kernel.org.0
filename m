Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A086D37CE3C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239094AbhELREB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:04:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234281AbhELQm7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 897BE61E57;
        Wed, 12 May 2021 16:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835960;
        bh=/hQTqqhVII6R5FKYAmWrl2YL7BJboSQZ9i0Vpj164F0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I9B7Q1uoRx49tIzNlNbd1MIQREPyud53xC89XuouHYozmc7xjm2ifnrkjxSfojIiQ
         QBA5XGVXZ3o1qqbGXYMkeutJ4gwRc2W1afxI4L4OeqDqkZs+Wcuwk+E55issC007Aa
         XLQqptncz7HXQTmghNlmTK/56moXq/niksqey1LE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Wensheng <wangwensheng4@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 553/677] RDMA/srpt: Fix error return code in srpt_cm_req_recv()
Date:   Wed, 12 May 2021 16:49:59 +0200
Message-Id: <20210512144855.760922910@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index 6be60aa5ffe2..7f0420ad9057 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2378,6 +2378,7 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 		pr_info("rejected SRP_LOGIN_REQ because target %s_%d is not enabled\n",
 			dev_name(&sdev->device->dev), port_num);
 		mutex_unlock(&sport->mutex);
+		ret = -EINVAL;
 		goto reject;
 	}
 
-- 
2.30.2



