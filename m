Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECEDC2A16F8
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgJaLtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:49:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727983AbgJaLnN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:43:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ED9F2074F;
        Sat, 31 Oct 2020 11:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144592;
        bh=IBDCAtZAeG0/LGaYSQXF5LKZWfH9gmejTmW2vzUoc1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=udRR3kJ/zKG+EYQPieufB7DhPGOgkl76c3LaRfzceUgCh8GnYrnEjUdmZE1OVqnyg
         7oAEGL0zW8Pcv3IcISNxDtAeVf87UzpnQJOEuooEkPe1tRY/PD4A6JEZIN9yAnDZof
         oFHjXrANysj9OeS7q8MZJNjY5azli5Yq7ik4omw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Aloni <dan@kernelim.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.8 60/70] RDMA/addr: Fix race with netevent_callback()/rdma_addr_cancel()
Date:   Sat, 31 Oct 2020 12:36:32 +0100
Message-Id: <20201031113502.375472125@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

commit 2ee9bf346fbfd1dad0933b9eb3a4c2c0979b633e upstream.

This three thread race can result in the work being run once the callback
becomes NULL:

       CPU1                 CPU2                   CPU3
 netevent_callback()
                     process_one_req()       rdma_addr_cancel()
                      [..]
     spin_lock_bh()
  	set_timeout()
     spin_unlock_bh()

						spin_lock_bh()
						list_del_init(&req->list);
						spin_unlock_bh()

		     req->callback = NULL
		     spin_lock_bh()
		       if (!list_empty(&req->list))
                         // Skipped!
		         // cancel_delayed_work(&req->work);
		     spin_unlock_bh()

		    process_one_req() // again
		     req->callback() // BOOM
						cancel_delayed_work_sync()

The solution is to always cancel the work once it is completed so any
in between set_timeout() does not result in it running again.

Cc: stable@vger.kernel.org
Fixes: 44e75052bc2a ("RDMA/rdma_cm: Make rdma_addr_cancel into a fence")
Link: https://lore.kernel.org/r/20200930072007.1009692-1-leon@kernel.org
Reported-by: Dan Aloni <dan@kernelim.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/addr.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -647,13 +647,12 @@ static void process_one_req(struct work_
 	req->callback = NULL;
 
 	spin_lock_bh(&lock);
+	/*
+	 * Although the work will normally have been canceled by the workqueue,
+	 * it can still be requeued as long as it is on the req_list.
+	 */
+	cancel_delayed_work(&req->work);
 	if (!list_empty(&req->list)) {
-		/*
-		 * Although the work will normally have been canceled by the
-		 * workqueue, it can still be requeued as long as it is on the
-		 * req_list.
-		 */
-		cancel_delayed_work(&req->work);
 		list_del_init(&req->list);
 		kfree(req);
 	}


