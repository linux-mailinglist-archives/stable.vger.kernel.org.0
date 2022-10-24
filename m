Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E23E60AC53
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbiJXOGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236862AbiJXOD0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:03:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4F2BECCD;
        Mon, 24 Oct 2022 05:48:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20436612C9;
        Mon, 24 Oct 2022 12:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B87C433D6;
        Mon, 24 Oct 2022 12:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615594;
        bh=l5t1cvnPhuKMp3Whc9t5aoadFeQyh42Tn6TuXidGmEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sfKKxjGn0PkejKRwWHIr+IMvjHYtDtEjxZh3xWS7e2s64822Id2oyri/lqXh6gB+w
         tlslCd1TLLameaqXwFlpENI3m/f+PhYD7G3qWS7hg2JXJ+lcBaupWJMfRx7Ar5DYAR
         5REESUp4ZKxniAj+C3J0O/H+aAHjx6S1uKSMZk34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 311/530] RDMA/siw: Fix QP destroy to wait for all references dropped.
Date:   Mon, 24 Oct 2022 13:30:55 +0200
Message-Id: <20221024113059.123722823@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index aa3f60d54a70..ff33659acffa 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -478,6 +478,8 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 	list_add_tail(&qp->devq, &sdev->qp_list);
 	spin_unlock_irqrestore(&sdev->lock, flags);
 
+	init_completion(&qp->qp_free);
+
 	return 0;
 
 err_out_xa:
@@ -622,6 +624,7 @@ int siw_destroy_qp(struct ib_qp *base_qp, struct ib_udata *udata)
 	qp->scq = qp->rcq = NULL;
 
 	siw_qp_put(qp);
+	wait_for_completion(&qp->qp_free);
 
 	return 0;
 }
-- 
2.35.1



