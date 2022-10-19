Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B46F603E58
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbiJSJM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232637AbiJSJK5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:10:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1B0C4DB9;
        Wed, 19 Oct 2022 02:02:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C92161825;
        Wed, 19 Oct 2022 09:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E90CC433C1;
        Wed, 19 Oct 2022 09:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170127;
        bh=SVGyauJPlNV9CwUJHeaBYDZmpQHU7dMSWq2bl8Wcheg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCaPBBbxP023kNdTCIlsZDp8DveWT6QXLeEwTFuGGCOgsMt2IYKAnQ4n1Sf1FShV+
         7I5uyt/VYHvI32vpKh8mETZTcrSd9Q9usGR6n2fK2VbmL7JLLMyoKzyMjI/suDKueO
         5qKHN3a9FmZn8Q8MPQsJOQgrqcFHBl6eF/xk+rdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 538/862] RDMA/siw: Fix QP destroy to wait for all references dropped.
Date:   Wed, 19 Oct 2022 10:30:25 +0200
Message-Id: <20221019083313.726298309@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernard Metzler <bmt@zurich.ibm.com>

[ Upstream commit a3c278807a459e6f50afee6971cabe74cccfb490 ]

Delay QP destroy completion until all siw references to QP are
dropped. The calling RDMA core will free QP structure after
successful return from siw_qp_destroy() call, so siw must not
hold any remaining reference to the QP upon return.
A use-after-free was encountered in xfstest generic/460, while
testing NFSoRDMA. Here, after a TCP connection drop by peer,
the triggered siw_cm_work_handler got delayed until after
QP destroy call, referencing a QP which has already freed.

Fixes: 303ae1cdfdf7 ("rdma/siw: application interface")
Reported-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Bernard Metzler <bmt@zurich.ibm.com>
Link: https://lore.kernel.org/r/20220920082503.224189-1-bmt@zurich.ibm.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw.h       | 1 +
 drivers/infiniband/sw/siw/siw_qp.c    | 2 +-
 drivers/infiniband/sw/siw/siw_verbs.c | 3 +++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw.h b/drivers/infiniband/sw/siw/siw.h
index df03d84c6868..2f3a9cda3850 100644
--- a/drivers/infiniband/sw/siw/siw.h
+++ b/drivers/infiniband/sw/siw/siw.h
@@ -418,6 +418,7 @@ struct siw_qp {
 	struct ib_qp base_qp;
 	struct siw_device *sdev;
 	struct kref ref;
+	struct completion qp_free;
 	struct list_head devq;
 	int tx_cpu;
 	struct siw_qp_attrs attrs;
diff --git a/drivers/infiniband/sw/siw/siw_qp.c b/drivers/infiniband/sw/siw/siw_qp.c
index 7e01f2438afc..e6f634971228 100644
--- a/drivers/infiniband/sw/siw/siw_qp.c
+++ b/drivers/infiniband/sw/siw/siw_qp.c
@@ -1342,6 +1342,6 @@ void siw_free_qp(struct kref *ref)
 	vfree(qp->orq);
 
 	siw_put_tx_cpu(qp->tx_cpu);
-
+	complete(&qp->qp_free);
 	atomic_dec(&sdev->num_qp);
 }
diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index 8dedae7ae79e..3e814cfb298c 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -480,6 +480,8 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 	list_add_tail(&qp->devq, &sdev->qp_list);
 	spin_unlock_irqrestore(&sdev->lock, flags);
 
+	init_completion(&qp->qp_free);
+
 	return 0;
 
 err_out_xa:
@@ -624,6 +626,7 @@ int siw_destroy_qp(struct ib_qp *base_qp, struct ib_udata *udata)
 	qp->scq = qp->rcq = NULL;
 
 	siw_qp_put(qp);
+	wait_for_completion(&qp->qp_free);
 
 	return 0;
 }
-- 
2.35.1



