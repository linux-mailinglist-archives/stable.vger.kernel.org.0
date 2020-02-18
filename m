Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAAD1630D0
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 20:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgBRT4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 14:56:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:33758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727333AbgBRT4j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 14:56:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F9B32464E;
        Tue, 18 Feb 2020 19:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055798;
        bh=D35N25K8N/+3qxxU6oWsd/VcsaIY+YrZgEa17lB9r1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZWTZAJE1Yrqs+H+YH1HSx9FyBlH+ZLOI7Xna+v+kcqwQNQI91mZey7M8GfG/p+o0
         qeEMkncvJKdV/VOKiO7jTh7XPddVPyfOxloObkglvQim19LonkQ6OcGxjflJHT0VLj
         c5nm0iWdPhfFMjuK1FttlvXoyXXqwU+g2hKMcrEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.19 25/38] IB/hfi1: Acquire lock to release TID entries when user file is closed
Date:   Tue, 18 Feb 2020 20:55:11 +0100
Message-Id: <20200218190421.639770102@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190418.536430858@linuxfoundation.org>
References: <20200218190418.536430858@linuxfoundation.org>
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
@@ -165,10 +165,12 @@ void hfi1_user_exp_rcv_free(struct hfi1_
 	if (fd->handler) {
 		hfi1_mmu_rb_unregister(fd->handler);
 	} else {
+		mutex_lock(&uctxt->exp_mutex);
 		if (!EXP_TID_SET_EMPTY(uctxt->tid_full_list))
 			unlock_exp_tids(uctxt, &uctxt->tid_full_list, fd);
 		if (!EXP_TID_SET_EMPTY(uctxt->tid_used_list))
 			unlock_exp_tids(uctxt, &uctxt->tid_used_list, fd);
+		mutex_unlock(&uctxt->exp_mutex);
 	}
 
 	kfree(fd->invalid_tids);


