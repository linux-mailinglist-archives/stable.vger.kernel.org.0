Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9223611099
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbiJ1MHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbiJ1MHK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:07:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E51190E7A
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 05:07:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 906F0B829BE
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 12:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A61C433C1;
        Fri, 28 Oct 2022 12:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666958823;
        bh=NBhOUHrH7xKpVUuO3SWOcpekq6A71VXdGMgM5bI7k9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJW1lZNPUG1L93hPuGCr9xe4N2VX4QdB/ppirKxj8SbsIlttMtoLYleEFjiA5Mjuw
         nMfFzo+Zb7mMmeKV7FqbmDtuZ3NMwU9Txnch1wFuPXGMfGJ39xtO2K/Xkc7+mjQ6ra
         rSd/b4jzoVm1okV25nFUp5t6l6N8/6TlhNrKE4nM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brett Creeley <brett@pensando.io>,
        Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 35/73] ionic: catch NULL pointer issue on reconfig
Date:   Fri, 28 Oct 2022 14:03:32 +0200
Message-Id: <20221028120233.903250093@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
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
index e42520f909fe..cb12d0171517 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2383,11 +2383,15 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
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
 
 	return err;
-- 
2.35.1



