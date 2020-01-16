Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C548413FCE2
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390437AbgAPXTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:19:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388134AbgAPXTf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:19:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB30C2073A;
        Thu, 16 Jan 2020 23:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216775;
        bh=ypNyw1MjB0/bfpX02WXK0mi16a6Oth6mpa7Q0tMXgrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A3LlWKjUALpCusB07jFaC6n6VHgtzukIhrYxPvafMDjkUCIfkFrg8jbZyE8O6Prf9
         mQFkyZAN5lHWe+nk0rB9wbm6aiy+CJI3Cr/ZGCh09/w44DN8LFxhfTT248zTDqFgQb
         4x2CTV6iUa8XQ+ZZi6l3q7RivNOyFkO43YR+UwNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 006/203] IB/hfi1: Dont cancel unused work item
Date:   Fri, 17 Jan 2020 00:15:23 +0100
Message-Id: <20200116231745.609284790@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

commit ca9033ba69c7e3477f207df69867b2ea969197c8 upstream.

In the iowait structure, two iowait_work entries were included to queue a
given object: one for normal IB operations, and the other for TID RDMA
operations. For non-TID RDMA operations, the iowait_work structure for TID
RDMA is initialized to contain a NULL function (not used). When the QP is
reset, the function iowait_cancel_work will be called to cancel any
pending work. The problem is that this function will call
cancel_work_sync() for both iowait_work entries, even though the one for
TID RDMA is not used at all. Eventually, the call cascades to
__flush_work(), wherein a WARN_ON will be triggered due to the fact that
work->func is NULL.

The WARN_ON was introduced in commit 4d43d395fed1 ("workqueue: Try to
catch flush_work() without INIT_WORK().")

This patch fixes the issue by making sure that a work function is present
for TID RDMA before calling cancel_work_sync in iowait_cancel_work.

Fixes: 4d43d395fed1 ("workqueue: Try to catch flush_work() without INIT_WORK().")
Fixes: 5da0fc9dbf89 ("IB/hfi1: Prepare resource waits for dual leg")
Link: https://lore.kernel.org/r/20191219211941.58387.39883.stgit@awfm-01.aw.intel.com
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/iowait.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/hfi1/iowait.c
+++ b/drivers/infiniband/hw/hfi1/iowait.c
@@ -81,7 +81,9 @@ void iowait_init(struct iowait *wait, u3
 void iowait_cancel_work(struct iowait *w)
 {
 	cancel_work_sync(&iowait_get_ib_work(w)->iowork);
-	cancel_work_sync(&iowait_get_tid_work(w)->iowork);
+	/* Make sure that the iowork for TID RDMA is used */
+	if (iowait_get_tid_work(w)->iowork.func)
+		cancel_work_sync(&iowait_get_tid_work(w)->iowork);
 }
 
 /**


