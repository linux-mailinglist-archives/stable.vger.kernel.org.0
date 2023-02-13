Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F478694A2C
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbjBMPFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbjBMPFD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:05:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080531C7E4
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:04:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98E96610A4
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:04:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18B5C433EF;
        Mon, 13 Feb 2023 15:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300697;
        bh=To4gLrycDdATJVeWkV/N0qjBJy6qNGPC9EbakIqbYlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nTUUb/s3GMbYkP//yGs8DHp1u7bI0ScR/QmZpihtkk4OKLR0SJ/HjBstUWg1wtMS7
         uG9IOEjPm6FdgusLBeHcvIPu1aR+TLqtul4GbIcFOBb7dBKyr8sy8X88Pa45/nPtJU
         xe5Tz34SXWr2uz8LBkfjJoTPM2oV9nD4JIm4rnKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Neel Patel <neel.patel@amd.com>,
        Shannon Nelson <shannon.nelson@amd.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/139] ionic: clean interrupt before enabling queue to avoid credit race
Date:   Mon, 13 Feb 2023 15:50:59 +0100
Message-Id: <20230213144751.925284862@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
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
index cb12d0171517e..fcd4213c99b83 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -257,6 +257,7 @@ static int ionic_qcq_enable(struct ionic_qcq *qcq)
 			.oper = IONIC_Q_ENABLE,
 		},
 	};
+	int ret;
 
 	idev = &lif->ionic->idev;
 	dev = lif->ionic->dev;
@@ -264,16 +265,24 @@ static int ionic_qcq_enable(struct ionic_qcq *qcq)
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



