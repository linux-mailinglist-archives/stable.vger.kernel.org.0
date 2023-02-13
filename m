Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BACD769496E
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbjBMO7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbjBMO6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:58:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710701DB81
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:58:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D56E0B8125F
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:58:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50130C433D2;
        Mon, 13 Feb 2023 14:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300297;
        bh=46LCEg4+Xyit3h+BCpu6GHwpj0KKJuJj6jTqB1ArxD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bU2FRwRiVMC1bRxZ+Oi6FohWllvpwWMt2ROryqqmAjm0evQjm8kqmj2Qzd+SM3WC8
         8C/7KnlurvwHQbsruW/RKN1re80/uCcOlPYaUeClMKeA50EAV3RYNx51Kw0BDhCcUv
         Sqhkj7XVkiO5QAOVWtKCouRgOT+Kvrvhq1dj0q8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Neel Patel <neel.patel@amd.com>,
        Shannon Nelson <shannon.nelson@amd.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 25/67] ionic: clean interrupt before enabling queue to avoid credit race
Date:   Mon, 13 Feb 2023 15:49:06 +0100
Message-Id: <20230213144733.564211030@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neel Patel <neel.patel@amd.com>

[ Upstream commit e8797a058466b60fc5a3291b92430c93ba90eaff ]

Clear the interrupt credits before enabling the queue rather
than after to be sure that the enabled queue starts at 0 and
that we don't wipe away possible credits after enabling the
queue.

Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
Signed-off-by: Neel Patel <neel.patel@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 886c997a3ad14..6fbd2a51d66ce 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -268,6 +268,7 @@ static int ionic_qcq_enable(struct ionic_qcq *qcq)
 			.oper = IONIC_Q_ENABLE,
 		},
 	};
+	int ret;
 
 	idev = &lif->ionic->idev;
 	dev = lif->ionic->dev;
@@ -275,16 +276,24 @@ static int ionic_qcq_enable(struct ionic_qcq *qcq)
 	dev_dbg(dev, "q_enable.index %d q_enable.qtype %d\n",
 		ctx.cmd.q_control.index, ctx.cmd.q_control.type);
 
+	if (qcq->flags & IONIC_QCQ_F_INTR)
+		ionic_intr_clean(idev->intr_ctrl, qcq->intr.index);
+
+	ret = ionic_adminq_post_wait(lif, &ctx);
+	if (ret)
+		return ret;
+
+	if (qcq->napi.poll)
+		napi_enable(&qcq->napi);
+
 	if (qcq->flags & IONIC_QCQ_F_INTR) {
 		irq_set_affinity_hint(qcq->intr.vector,
 				      &qcq->intr.affinity_mask);
-		napi_enable(&qcq->napi);
-		ionic_intr_clean(idev->intr_ctrl, qcq->intr.index);
 		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,
 				IONIC_INTR_MASK_CLEAR);
 	}
 
-	return ionic_adminq_post_wait(lif, &ctx);
+	return 0;
 }
 
 static int ionic_qcq_disable(struct ionic_qcq *qcq, bool send_to_hw)
-- 
2.39.0



