Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D11FC47FF83
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239010AbhL0PiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:38:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238341AbhL0Pgu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:36:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2594BC0619D8;
        Mon, 27 Dec 2021 07:36:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC4C3610E8;
        Mon, 27 Dec 2021 15:36:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE3AC36AE7;
        Mon, 27 Dec 2021 15:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619407;
        bh=178ZAXgWwY2z667OAKMUNgs11YsjHBfoYCbeUAVlNAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZK3XWe9lN5U2Bb6BD8r8tosNTi1cKVTsbSgmIQrklg22rbGNcUQV13ef8HL3o4or7
         PrzrKIOeBrIFyI5UR3c2aZKa2+UjixhbNGGwL46/KP4WHC5hM4/YH0wFnTVS2O/4VQ
         fHNDRwwNYzomfPCnl7ZM8LHIZMVesUGI7uhDv8co=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiacheng Shi <billsjc@sjtu.edu.cn>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/76] RDMA/hns: Replace kfree() with kvfree()
Date:   Mon, 27 Dec 2021 16:30:28 +0100
Message-Id: <20211227151325.158654082@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
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
index f27523e1a12d7..08df97e0a6654 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -277,7 +277,7 @@ static int alloc_srq_wrid(struct hns_roce_dev *hr_dev, struct hns_roce_srq *srq)
 
 static void free_srq_wrid(struct hns_roce_srq *srq)
 {
-	kfree(srq->wrid);
+	kvfree(srq->wrid);
 	srq->wrid = NULL;
 }
 
-- 
2.34.1



