Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFF03C4E75
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242318AbhGLHTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:19:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243879AbhGLHRx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:17:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD22F6144A;
        Mon, 12 Jul 2021 07:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074104;
        bh=IidLABSP/cvQqAYnVF1bmFpl/Ddrb1rDg7hFz5bvJJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMVPSSF00TgH1Bjv0opbR03FZwPCmzxhtXEvmWEGoBU18xu/yEfNCJDZBvcTiL2Hv
         Uf6fEnFCQSA+IBPmDA7dLD2T1NylYxC4HQc3viVEsM93GqR8SfibY8xNmSd+e8nmOw
         8jj8t6SG8KUWtI3YVRNRmbc7cq2tieJOjl8Ib0Tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yixing Liu <liuyixing1@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 466/700] RDMA/hns: Fix uninitialized variable
Date:   Mon, 12 Jul 2021 08:09:09 +0200
Message-Id: <20210712061026.167312548@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yixing Liu <liuyixing1@huawei.com>

[ Upstream commit 2a38c0f10e6d7d28e06ff1eb1f350804c4850275 ]

A random value will be returned if the condition below is not met, so it
needs to be initialized.

Fixes: 9ea9a53ea93b ("RDMA/hns: Add mapped page count checking for MTR")
Link: https://lore.kernel.org/r/1624011020-16992-3-git-send-email-liweihang@huawei.com
Signed-off-by: Yixing Liu <liuyixing1@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 79b3c3023fe7..b8454dcb0318 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -776,7 +776,7 @@ int hns_roce_mtr_map(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 	struct ib_device *ibdev = &hr_dev->ib_dev;
 	struct hns_roce_buf_region *r;
 	unsigned int i, mapped_cnt;
-	int ret;
+	int ret = 0;
 
 	/*
 	 * Only use the first page address as root ba when hopnum is 0, this
-- 
2.30.2



