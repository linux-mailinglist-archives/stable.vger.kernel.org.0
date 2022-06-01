Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05DB53A80E
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345783AbiFAOGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354627AbiFAOFD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:05:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD357ABF50;
        Wed,  1 Jun 2022 06:59:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5619961637;
        Wed,  1 Jun 2022 13:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC61EC385B8;
        Wed,  1 Jun 2022 13:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091939;
        bh=7935UyMVAnT3dXYvLzTRTvC+kabYaDndD1293erSu68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tjxsZCtfclxRuzS393weDetu1v++gWdQgKX/kG1s/jbXFIIUkAWhTo6oPyqZ2uGsP
         DVdKOz+7JySJ0gzEToGpwmbhBkcKrKiTXeJLvwzoaq9PlqTO18kapTyZrslYueftKZ
         xBG3wKZLeUjPuU2315S7LTo1LHJbH49FeeNSKN4xa3kG467LnyLjCoY6nD6Cml2lY1
         c9fYL0n9PozHmYL8nYgcKqDVmnCJW0SzHte1bb+8zVTvlvZNRzua0CsfKofP/qD66B
         uE3UycU/7BfKzP0iBThKd3FnAzZDyFsQYYV6qNf7ZljsWQqZdoz+kk+OnEd1plxjde
         Kaoe1WcSiEwkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Miller <doug.miller@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 25/26] RDMA/hfi1: Prevent panic when SDMA is disabled
Date:   Wed,  1 Jun 2022 09:57:58 -0400
Message-Id: <20220601135759.2004435-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135759.2004435-1-sashal@kernel.org>
References: <20220601135759.2004435-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Miller <doug.miller@cornelisnetworks.com>

[ Upstream commit 629e052d0c98e46dde9f0824f0aa437f678d9b8f ]

If the hfi1 module is loaded with HFI1_CAP_SDMA off, a call to
hfi1_write_iter() will dereference a NULL pointer and panic. A typical
stack frame is:

  sdma_select_user_engine [hfi1]
  hfi1_user_sdma_process_request [hfi1]
  hfi1_write_iter [hfi1]
  do_iter_readv_writev
  do_iter_write
  vfs_writev
  do_writev
  do_syscall_64

The fix is to test for SDMA in hfi1_write_iter() and fail the I/O with
EINVAL.

Link: https://lore.kernel.org/r/20220520183706.48973.79803.stgit@awfm-01.cornelisnetworks.com
Signed-off-by: Douglas Miller <doug.miller@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 329ee4f48d95..cfc2110fc38a 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -306,6 +306,8 @@ static ssize_t hfi1_write_iter(struct kiocb *kiocb, struct iov_iter *from)
 	unsigned long dim = from->nr_segs;
 	int idx;
 
+	if (!HFI1_CAP_IS_KSET(SDMA))
+		return -EINVAL;
 	idx = srcu_read_lock(&fd->pq_srcu);
 	pq = srcu_dereference(fd->pq, &fd->pq_srcu);
 	if (!cq || !pq) {
-- 
2.35.1

