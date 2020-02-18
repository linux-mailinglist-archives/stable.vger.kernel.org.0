Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A49B416320B
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgBRUFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:05:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:42460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728501AbgBRUCQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:02:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6760A24125;
        Tue, 18 Feb 2020 20:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056135;
        bh=mAmV8dIK69+9SooGk8jR/mmY2MxyUb+N5NoJ1Go+u4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ks1F4cfg6RU3DoST0Q+8pFF3P1lzIFyXKvtrBUgv0zKK8xOiqdOM38WvE8idN/DVO
         O0f0KwssRjq949lUIDT217ERI9DsNNVNsKwWmYtQFN+RMHvWXegayCdENmszDqY4Ty
         7RnFk3oDfvwujr/Nyn+k8zN92VfSv9TJ8xW8qvaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.5 49/80] IB/hfi1: Acquire lock to release TID entries when user file is closed
Date:   Tue, 18 Feb 2020 20:55:10 +0100
Message-Id: <20200218190436.942775429@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

commit a70ed0f2e6262e723ae8d70accb984ba309eacc2 upstream.

Each user context is allocated a certain number of RcvArray (TID)
entries and these entries are managed through TID groups. These groups
are put into one of three lists in each user context: tid_group_list,
tid_used_list, and tid_full_list, depending on the number of used TID
entries within each group. When TID packets are expected, one or more
TID groups will be allocated. After the packets are received, the TID
groups will be freed. Since multiple user threads may access the TID
groups simultaneously, a mutex exp_mutex is used to synchronize the
access. However, when the user file is closed, it tries to release
all TID groups without acquiring the mutex first, which risks a race
condition with another thread that may be releasing its TID groups,
leading to data corruption.

This patch addresses the issue by acquiring the mutex first before
releasing the TID groups when the file is closed.

Fixes: 3abb33ac6521 ("staging/hfi1: Add TID cache receive init and free funcs")
Link: https://lore.kernel.org/r/20200210131026.87408.86853.stgit@awfm-01.aw.intel.com
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -142,10 +142,12 @@ void hfi1_user_exp_rcv_free(struct hfi1_
 {
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 
+	mutex_lock(&uctxt->exp_mutex);
 	if (!EXP_TID_SET_EMPTY(uctxt->tid_full_list))
 		unlock_exp_tids(uctxt, &uctxt->tid_full_list, fd);
 	if (!EXP_TID_SET_EMPTY(uctxt->tid_used_list))
 		unlock_exp_tids(uctxt, &uctxt->tid_used_list, fd);
+	mutex_unlock(&uctxt->exp_mutex);
 
 	kfree(fd->invalid_tids);
 	fd->invalid_tids = NULL;


