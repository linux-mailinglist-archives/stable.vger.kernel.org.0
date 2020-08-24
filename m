Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7674324F8AD
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbgHXIsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:48:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729599AbgHXIsp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:48:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE531204FD;
        Mon, 24 Aug 2020 08:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258925;
        bh=VW/CwsuVrwl6ReYbARigPDF/SbJ5qUjDCXEj9WHndn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hp4dCIONELk9xKjq6DKhfbvoPt7C6vy0UMrp0UgBUuwMy9RPdZ2tZvJARq1yCSkxI
         ztqaNTuranVh0wLZQkhkE6VarWpPLTV8zBtaxlfdwtaObq8rdIXnXm5WKt/sanNkmX
         1AkPGRIc8XEKDp1Tg0VPRWHjksbjW2IWAUo0pQSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 094/107] RDMA/bnxt_re: Do not add user qps to flushlist
Date:   Mon, 24 Aug 2020 10:31:00 +0200
Message-Id: <20200824082409.750402349@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082405.020301642@linuxfoundation.org>
References: <20200824082405.020301642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit a812f2d60a9fb7818f9c81f967180317b52545c0 ]

Driver shall add only the kernel qps to the flush list for clean up.
During async error events from the HW, driver is adding qps to this list
without checking if the qp is kernel qp or not.

Add a check to avoid user qp addition to the flush list.

Fixes: 942c9b6ca8de ("RDMA/bnxt_re: Avoid Hard lockup during error CQE processing")
Fixes: c50866e2853a ("bnxt_re: fix the regression due to changes in alloc_pbl")
Link: https://lore.kernel.org/r/1596689148-4023-1-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 27e2df44d043d..cfe5f47d9890e 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -789,7 +789,8 @@ static int bnxt_re_handle_qp_async_event(struct creq_qp_event *qp_event,
 	struct ib_event event;
 	unsigned int flags;
 
-	if (qp->qplib_qp.state == CMDQ_MODIFY_QP_NEW_STATE_ERR) {
+	if (qp->qplib_qp.state == CMDQ_MODIFY_QP_NEW_STATE_ERR &&
+	    rdma_is_kernel_res(&qp->ib_qp.res)) {
 		flags = bnxt_re_lock_cqs(qp);
 		bnxt_qplib_add_flush_qp(&qp->qplib_qp);
 		bnxt_re_unlock_cqs(qp, flags);
-- 
2.25.1



