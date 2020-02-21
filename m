Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD82167346
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732603AbgBUIKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:10:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:46250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732602AbgBUIKy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:10:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB05E20578;
        Fri, 21 Feb 2020 08:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272654;
        bh=ZMzivYDnpaZYdtbLeJqLb2sqgxAkm92n6yx/iyLIL4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8BNmJepLIp4z/cvvWmDG19ur67JJYVRvXgu5Px7CihR8YbyJkAeS068iV6TcB0oc
         elXT/mpcd89ZnC2ka0jsXP+j6wlof4Pi1dxyaUFUu8Mj9AaA4y2m4DLqmDVRdv6NEb
         hI3musUMDaJOdWB5o8OeKqEcqTJF3jhu8I3h9ZXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 189/344] RDMA/hns: Avoid printing address of mtt page
Date:   Fri, 21 Feb 2020 08:39:48 +0100
Message-Id: <20200221072406.206373537@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenpeng Liang <liangwenpeng@huawei.com>

[ Upstream commit eca44507c3e908b7362696a4d6a11d90371334c6 ]

Address of a page shouldn't be printed in case of security issues.

Link: https://lore.kernel.org/r/1578313276-29080-2-git-send-email-liweihang@huawei.com
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_mr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 5f8416ba09a94..702b59f0dab91 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -1062,8 +1062,8 @@ int hns_roce_ib_umem_write_mtt(struct hns_roce_dev *hr_dev,
 		if (!(npage % (1 << (mtt->page_shift - PAGE_SHIFT)))) {
 			if (page_addr & ((1 << mtt->page_shift) - 1)) {
 				dev_err(dev,
-					"page_addr 0x%llx is not page_shift %d alignment!\n",
-					page_addr, mtt->page_shift);
+					"page_addr is not page_shift %d alignment!\n",
+					mtt->page_shift);
 				ret = -EINVAL;
 				goto out;
 			}
-- 
2.20.1



