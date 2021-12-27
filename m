Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBAF648004A
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239371AbhL0PoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:44:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41434 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239383AbhL0PmS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:42:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E17661052;
        Mon, 27 Dec 2021 15:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3251C36AEA;
        Mon, 27 Dec 2021 15:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619736;
        bh=qoh2PCPhoLa1vHrfNktzYUgXC38ihRF0J1q7SD8nwu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6mB9ZmcXEUbCaMDllCK3AMpqFg+6WYSvcZ9i22AsAPTdZnrkr1ykq/BZ0JVjHpgl
         BJ83qupcZHewKgLkhv5YrSnW2Ej8o/SWJzLTX0l8AaGJlNkPmBG33upp5MUwYjpaXA
         Yv+evj2/+hwZFXjEKtTijJoxxxNAoyYSiRepdCVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiacheng Shi <billsjc@sjtu.edu.cn>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/128] RDMA/hns: Replace kfree() with kvfree()
Date:   Mon, 27 Dec 2021 16:29:54 +0100
Message-Id: <20211227151332.157664721@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiacheng Shi <billsjc@sjtu.edu.cn>

[ Upstream commit 12d3bbdd6bd2780b71cc466f3fbc6eb7d43bbc2a ]

Variables allocated by kvmalloc_array() should not be freed by kfree.
Because they may be allocated by vmalloc.  So we replace kfree() with
kvfree() here.

Fixes: 6fd610c5733d ("RDMA/hns: Support 0 hop addressing for SRQ buffer")
Link: https://lore.kernel.org/r/20211210094234.5829-1-billsjc@sjtu.edu.cn
Signed-off-by: Jiacheng Shi <billsjc@sjtu.edu.cn>
Acked-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_srq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_srq.c b/drivers/infiniband/hw/hns/hns_roce_srq.c
index 6eee9deadd122..e64ef6903fb4f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -259,7 +259,7 @@ static int alloc_srq_wrid(struct hns_roce_dev *hr_dev, struct hns_roce_srq *srq)
 
 static void free_srq_wrid(struct hns_roce_srq *srq)
 {
-	kfree(srq->wrid);
+	kvfree(srq->wrid);
 	srq->wrid = NULL;
 }
 
-- 
2.34.1



