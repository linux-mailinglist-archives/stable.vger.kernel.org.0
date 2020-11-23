Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A520F2C0842
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732651AbgKWMqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:46:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:60232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732769AbgKWMqj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:46:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4845820888;
        Mon, 23 Nov 2020 12:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135598;
        bh=g+js9ujXaU4nKsk0sMQ7XtNkPbemdzCVkoOmEv8Ou9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kv5qTww9WNOeQcY7klWy14kLgrV04KvOc9UZLLnYzV3MvdStJYwSfJJHZV9O4x1Bn
         DniHSgjh/zltJRW5b2Y/+f9QEbzGffjoWOq8zNXwgkyqy349+V+TvkQa3vN5uHYSpk
         7fV6eqoXwiMwUpqPl9iYZFqUFJr2l72/AlDJdaYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 127/252] IB/hfi1: Fix error return code in hfi1_init_dd()
Date:   Mon, 23 Nov 2020 13:21:17 +0100
Message-Id: <20201123121841.719546871@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit dabbd6abcdbeb1358a53ec28a244429320eb0e3a ]

Fix to return a negative error code from the error handling case instead
of 0, as done elsewhere in this function.

Fixes: 4730f4a6c6b2 ("IB/hfi1: Activate the dummy netdev")
Link: https://lore.kernel.org/r/1605249747-17942-1-git-send-email-zhangchangzhong@huawei.com
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/chip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 7eaf995382168..c87b94ea29397 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -15245,7 +15245,8 @@ int hfi1_init_dd(struct hfi1_devdata *dd)
 		    & CCE_REVISION_SW_MASK);
 
 	/* alloc netdev data */
-	if (hfi1_netdev_alloc(dd))
+	ret = hfi1_netdev_alloc(dd);
+	if (ret)
 		goto bail_cleanup;
 
 	ret = set_up_context_variables(dd);
-- 
2.27.0



