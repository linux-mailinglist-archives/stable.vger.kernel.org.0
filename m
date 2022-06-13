Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F33548F07
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245636AbiFMKpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243546AbiFMKlg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:41:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4E829CBF;
        Mon, 13 Jun 2022 03:23:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A3CAB80E94;
        Mon, 13 Jun 2022 10:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD836C34114;
        Mon, 13 Jun 2022 10:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115831;
        bh=/3YpkFpa0PKlf61xiEMBIL/Wzdp1RfVVz6gxZhozYrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yRDCPV8RGr84nDSHTH3/d/G+Fbx6/JQ/bDhy1HNq2aVlYzinjfRFrormIQfTs3W6Y
         xP9oMuGZ/Zl0hrop5fdJuFo5JpoXovs0S+4lhUGtiKWnj7AbjRirhELupvWKqoqIZ8
         hrJI7EtASjzjRaUkzJXTk8YlDBw1xl59WZ8k7ipQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Douglas Miller <doug.miller@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 046/218] RDMA/hfi1: Prevent panic when SDMA is disabled
Date:   Mon, 13 Jun 2022 12:08:24 +0200
Message-Id: <20220613094919.327049369@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



