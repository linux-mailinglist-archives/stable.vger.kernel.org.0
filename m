Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE2A353A87A
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354387AbiFAOJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354513AbiFAOIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:08:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D50219F;
        Wed,  1 Jun 2022 07:00:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 93A9DCE1A24;
        Wed,  1 Jun 2022 14:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DA7C34119;
        Wed,  1 Jun 2022 14:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654092025;
        bh=c/sh0ADfc8YO6RjUcVirxMAJQkJ6AkcflF2WlJjEjmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mn0XS1RpsnrW2L9KDw8KkLJIdGpzZGlo6ChpR7I5JOC/TKo5APKRbCXCf+wQ1SY6S
         PiTnye0EzGg8nkvfaEl4GU2WwpZyrfOAZobuXz01uzxMjOzAGsMrtT2wVnSbDwfqg2
         6PghbyIV5uNF/eN65H4I5TbbpyT6YrNgmuDYYiT3v+oBgcqxhMfwhk8Ygt0HARTwcX
         C9zgUGXPgKIxl9oGEakesqb5hayCVfrbBSSUi5tCPM0C5plNV9V9Ma7loIX9UfyCtM
         O+J31VEGGsjDanAFyuYF5yfKxWKrP4MnKnqphvYrZfvuczEN9Zw85VonxgK1VxiQeS
         BAx2skgdtjtnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Miller <doug.miller@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 14/15] RDMA/hfi1: Prevent panic when SDMA is disabled
Date:   Wed,  1 Jun 2022 09:59:49 -0400
Message-Id: <20220601135951.2005085-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135951.2005085-1-sashal@kernel.org>
References: <20220601135951.2005085-1-sashal@kernel.org>
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
index adeb259458de..64ee11542a56 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -308,6 +308,8 @@ static ssize_t hfi1_write_iter(struct kiocb *kiocb, struct iov_iter *from)
 	unsigned long dim = from->nr_segs;
 	int idx;
 
+	if (!HFI1_CAP_IS_KSET(SDMA))
+		return -EINVAL;
 	idx = srcu_read_lock(&fd->pq_srcu);
 	pq = srcu_dereference(fd->pq, &fd->pq_srcu);
 	if (!cq || !pq) {
-- 
2.35.1

