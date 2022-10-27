Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E428560FDD7
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236763AbiJ0Q7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236797AbiJ0Q7f (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:59:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AC6659E
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:59:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E046EB82719
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33633C43470;
        Thu, 27 Oct 2022 16:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889967;
        bh=hQi2nDg9gEA8pGowgl8ziuZ+P9uqPO1YRl50hIEDGWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BS7wD71OR+t/EFKr+/X9DB1zTKnboJ1TXoRojZFcKNvqljlZV4d6CWweGKYoGIk2o
         gCQwN+wouma11g3PNQcvHtL9GB3LxzM/MmAEGtjkmoxZ7PZbRB4pAUvqIL1iLGMJNQ
         foRyACE8D0KrwH/Yle/4pzwOwljNWfgJXvgmnXKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brett Creeley <brett@pensando.io>,
        Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 67/94] ionic: catch NULL pointer issue on reconfig
Date:   Thu, 27 Oct 2022 18:55:09 +0200
Message-Id: <20221027165059.894342976@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
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

From: Brett Creeley <brett@pensando.io>

[ Upstream commit aa1d7e1267c12e07d979aa34c613716a89029db2 ]

It's possible that the driver will dereference a qcq that doesn't exist
when calling ionic_reconfigure_queues(), which causes a page fault BUG.

If a reduction in the number of queues is followed by a different
reconfig such as changing the ring size, the driver can hit a NULL
pointer when trying to clean up non-existent queues.

Fix this by checking to make sure both the qcqs array and qcq entry
exists bofore trying to use and free the entry.

Fixes: 101b40a0171f ("ionic: change queue count with no reset")
Signed-off-by: Brett Creeley <brett@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Link: https://lore.kernel.org/r/20221017233123.15869-1-snelson@pensando.io
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 0be79c516781..6ae6d79193a3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2820,11 +2820,15 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 	 * than the full array, but leave the qcq shells in place
 	 */
 	for (i = lif->nxqs; i < lif->ionic->ntxqs_per_lif; i++) {
-		lif->txqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
-		ionic_qcq_free(lif, lif->txqcqs[i]);
+		if (lif->txqcqs && lif->txqcqs[i]) {
+			lif->txqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
+			ionic_qcq_free(lif, lif->txqcqs[i]);
+		}
 
-		lif->rxqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
-		ionic_qcq_free(lif, lif->rxqcqs[i]);
+		if (lif->rxqcqs && lif->rxqcqs[i]) {
+			lif->rxqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
+			ionic_qcq_free(lif, lif->rxqcqs[i]);
+		}
 	}
 
 	if (err)
-- 
2.35.1



