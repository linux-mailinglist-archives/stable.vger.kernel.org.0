Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 499E115ECF0
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388475AbgBNRar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:30:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:58650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390096AbgBNQHW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:07:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3B4124676;
        Fri, 14 Feb 2020 16:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696441;
        bh=ZMzivYDnpaZYdtbLeJqLb2sqgxAkm92n6yx/iyLIL4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nCtaR44n0UejoMnIBLB85m5KBfAenB6d5aNjwrCGjvSDMXNFcp1Jr/pCBfsjr9yJG
         bYLoEZeaWUicmKtjkQ1Fl6IMWPYnVwIJ8Goanvv1gwGKKVbLOwzhluHI18DvEh0Zga
         JVgRRHdGKYuk6svkpsL8PV3aH9ORQ06/sLNfC6G4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 257/459] RDMA/hns: Avoid printing address of mtt page
Date:   Fri, 14 Feb 2020 10:58:27 -0500
Message-Id: <20200214160149.11681-257-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

