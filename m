Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319D053A8C1
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344766AbiFAOL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354571AbiFAOJf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:09:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCCBA186;
        Wed,  1 Jun 2022 07:00:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 967896149F;
        Wed,  1 Jun 2022 14:00:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D64FC3411E;
        Wed,  1 Jun 2022 14:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654092058;
        bh=/3YpkFpa0PKlf61xiEMBIL/Wzdp1RfVVz6gxZhozYrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OU/dpFWozSu1b7rmR154M8jJzp/kQ8toibl+PVIadiLHI7aeaXSYU/zqSwY/sIj2V
         D+EE80hhES7J397k1pMtPUeVdOmELbqpfOQw9Hsf7tfOh8ZjTV7cYF04ZHPQSWx6Ef
         8fMIwAUiPrGvfvyBjWRluQItm2+jGnKUJ2M5maJUr3d/LxhSoBMea6lxxG8mSRHoFe
         lva7kHrJ7KXxBrf5mrzr7shXFJ6+g9NRXojhXVYubzrGth634CZFjel+7vcRHwcuJz
         k+vlUI2waoLzIgHVg2zoHSPmckeFTdiTq2AfN/5J2X1nEWZ/pJAQ/nztBOz/aaG+rI
         yI+r+PQMyFSDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Miller <doug.miller@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 13/14] RDMA/hfi1: Prevent panic when SDMA is disabled
Date:   Wed,  1 Jun 2022 10:00:26 -0400
Message-Id: <20220601140027.2005280-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601140027.2005280-1-sashal@kernel.org>
References: <20220601140027.2005280-1-sashal@kernel.org>
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
index b3ab803bf8b1..7b8644610feb 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -424,6 +424,8 @@ static ssize_t hfi1_write_iter(struct kiocb *kiocb, struct iov_iter *from)
 	unsigned long dim = from->nr_segs;
 	int idx;
 
+	if (!HFI1_CAP_IS_KSET(SDMA))
+		return -EINVAL;
 	idx = srcu_read_lock(&fd->pq_srcu);
 	pq = srcu_dereference(fd->pq, &fd->pq_srcu);
 	if (!cq || !pq) {
-- 
2.35.1

