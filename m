Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E23338A433
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235091AbhETKCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235324AbhETJ7x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:59:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F073861883;
        Thu, 20 May 2021 09:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503535;
        bh=nJYuKBDy21ROuD2oBpZ2+sxuPbgro27WhZtPGJwL07I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VLW1pF3gyXDJ1whoJpOC99hq+PQG3AOBU6cghJ2IWqaTFUNC1ULS9VNW29LHj8V64
         eB5RjR+nS16/4ezoBobpUnQ6Kpr0pduDPaMw5IZtRa0ZRsJtkQAqbIMor26Qgt/cEi
         dxW/5XJ+w5Ra4iM8ZCXy+3UhkwMpHdoxVod++HBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Wensheng <wangwensheng4@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 266/425] RDMA/srpt: Fix error return code in srpt_cm_req_recv()
Date:   Thu, 20 May 2021 11:20:35 +0200
Message-Id: <20210520092140.188575128@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
index bc979a85a505..6090f1ce0c56 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2301,6 +2301,7 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 		pr_info("rejected SRP_LOGIN_REQ because target %s_%d is not enabled\n",
 			sdev->device->name, port_num);
 		mutex_unlock(&sport->mutex);
+		ret = -EINVAL;
 		goto reject;
 	}
 
-- 
2.30.2



