Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB5B33E3A6
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbhCQA5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:57:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231243AbhCQA4r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACADB64F9C;
        Wed, 17 Mar 2021 00:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942603;
        bh=aozgTVH3HTG6JxHeF/viQWKnhix4qY/2AgcsbmddK/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LAHObZRKVGTpvU5FE2qYTC09101MeOX9bNyzwF9YTCilMSR+3T8aPiVzfvRFNBW+O
         B1TvflOetf12ecnB8SjARhp6OlktlsaUEx7qgotpF+5PGSvk7nJ8gCvHs1AJyrnEcL
         FE8R611vLKeka+Esv/7Iuzl5TvUtGqwfi3v1JI0MAqo7K0naMIAgfiZSaArg8iWSDx
         V8ttJWwmv+48e2v7CSPkUIEpt8ZWKlQyGoGCPab386PdxBtL4Leir/ovhzTGf1iGnL
         /nndC+n6AFQwUwDEbY686i5EfnNClrfcGATqaYfDbo+74p1NUndXUuAVw3mckNalE4
         xFQdL/x+Uj9vw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 54/61] nvme-rdma: Fix a use after free in nvmet_rdma_write_data_done
Date:   Tue, 16 Mar 2021 20:55:28 -0400
Message-Id: <20210317005536.724046-54-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit abec6561fc4e0fbb19591a0b35676d8c783b5493 ]

In nvmet_rdma_write_data_done, rsp is recoverd by wc->wr_cqe and freed by
nvmet_rdma_release_rsp(). But after that, pr_info() used the freed
chunk's member object and could leak the freed chunk address with
wc->wr_cqe by computing the offset.

Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 06b6b742bb21..6c1f3ab7649c 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -802,9 +802,8 @@ static void nvmet_rdma_write_data_done(struct ib_cq *cq, struct ib_wc *wc)
 		nvmet_req_uninit(&rsp->req);
 		nvmet_rdma_release_rsp(rsp);
 		if (wc->status != IB_WC_WR_FLUSH_ERR) {
-			pr_info("RDMA WRITE for CQE 0x%p failed with status %s (%d).\n",
-				wc->wr_cqe, ib_wc_status_msg(wc->status),
-				wc->status);
+			pr_info("RDMA WRITE for CQE failed with status %s (%d).\n",
+				ib_wc_status_msg(wc->status), wc->status);
 			nvmet_rdma_error_comp(queue);
 		}
 		return;
-- 
2.30.1

