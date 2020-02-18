Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2111163275
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgBRT7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 14:59:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:37770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728398AbgBRT7S (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 14:59:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F10EE24655;
        Tue, 18 Feb 2020 19:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055958;
        bh=iJHNKSYGnxMSCtFIX5d8ZQWPZczsyXHD2fcIXpGlXXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B3A54nBIGsumJrtW0YDfJ/mvgCc0T/dszEVC4qvFvyMWy5POL4vYd1QobcsDUMDD8
         SxSBboPlSh7IqXh8e8Mggg+62tObQ/VwxPTsEL5sRyZAsIrVExRA0gAhCRosp/N4Jg
         x3EAXtfzE9xUs8LAiCbpjNUADsvLNW+V1R8z1M24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krishnamraju Eraparaju <krishna2@chelsio.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 45/66] RDMA/iw_cxgb4: initiate CLOSE when entering TERM
Date:   Tue, 18 Feb 2020 20:55:12 +0100
Message-Id: <20200218190432.166865120@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
References: <20200218190428.035153861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krishnamraju Eraparaju <krishna2@chelsio.com>

commit d219face9059f38ad187bde133451a2a308fdb7c upstream.

As per draft-hilland-iwarp-verbs-v1.0, sec 6.2.3, always initiate a CLOSE
when entering into TERM state.

In c4iw_modify_qp(), disconnect operation should only be performed when
the modify_qp call is invoked from ib_core. And all other internal
modify_qp calls(invoked within iw_cxgb4) that needs 'disconnect' should
call c4iw_ep_disconnect() explicitly after modify_qp. Otherwise, deadlocks
like below can occur:

 Call Trace:
  schedule+0x2f/0xa0
  schedule_preempt_disabled+0xa/0x10
  __mutex_lock.isra.5+0x2d0/0x4a0
  c4iw_ep_disconnect+0x39/0x430    => tries to reacquire ep lock again
  c4iw_modify_qp+0x468/0x10d0
  rx_data+0x218/0x570              => acquires ep lock
  process_work+0x5f/0x70
  process_one_work+0x1a7/0x3b0
  worker_thread+0x30/0x390
  kthread+0x112/0x130
  ret_from_fork+0x35/0x40

Fixes: d2c33370ae73 ("RDMA/iw_cxgb4: Always disconnect when QP is transitioning to TERMINATE state")
Link: https://lore.kernel.org/r/20200204091230.7210-1-krishna2@chelsio.com
Signed-off-by: Krishnamraju Eraparaju <krishna2@chelsio.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/cxgb4/cm.c |    4 ++++
 drivers/infiniband/hw/cxgb4/qp.c |    4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3036,6 +3036,10 @@ static int terminate(struct c4iw_dev *de
 				       C4IW_QP_ATTR_NEXT_STATE, &attrs, 1);
 		}
 
+		/* As per draft-hilland-iwarp-verbs-v1.0, sec 6.2.3,
+		 * when entering the TERM state the RNIC MUST initiate a CLOSE.
+		 */
+		c4iw_ep_disconnect(ep, 1, GFP_KERNEL);
 		c4iw_put_ep(&ep->com);
 	} else
 		pr_warn("TERM received tid %u no ep/qp\n", tid);
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1948,10 +1948,10 @@ int c4iw_modify_qp(struct c4iw_dev *rhp,
 			qhp->attr.layer_etype = attrs->layer_etype;
 			qhp->attr.ecode = attrs->ecode;
 			ep = qhp->ep;
-			c4iw_get_ep(&ep->com);
-			disconnect = 1;
 			if (!internal) {
+				c4iw_get_ep(&ep->com);
 				terminate = 1;
+				disconnect = 1;
 			} else {
 				terminate = qhp->attr.send_term;
 				ret = rdma_fini(rhp, qhp, ep);


