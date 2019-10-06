Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1F53CD68F
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731301AbfJFRl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:41:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731296AbfJFRl5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:41:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58F1E2080F;
        Sun,  6 Oct 2019 17:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383716;
        bh=eSh8T2nSPy8y2TgRE1CffHRlokwH0nJvPtRMTdfQcbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HgqnxCslSRmk7tVBkR45eqJcdUbFSWW3GTnLpDwT9+zuf/XGJTLd/ls0zwOkoBhkP
         2hO0voKkbWY9+yVQoL58dcZ0KXaABINe0q3SLdSm53Vo4tg+irn5CSTW75BtFMyTv7
         8G7GajNAAC1WIJWgJrPjW6HfaTOxCLNEBZCrin4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bibby Hsieh <bibby.hsieh@mediatek.com>,
        CK Hu <ck.hu@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 068/166] mailbox: mediatek: cmdq: clear the event in cmdq initial flow
Date:   Sun,  6 Oct 2019 19:20:34 +0200
Message-Id: <20191006171219.093809332@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bibby Hsieh <bibby.hsieh@mediatek.com>

[ Upstream commit 6058f11870b8e6d4f5cc7b591097c00bf69a000d ]

GCE hardware stored event information in own internal sysram,
if the initial value in those sysram is not zero value
it will cause a situation that gce can wait the event immediately
after client ask gce to wait event but not really trigger the
corresponding hardware.

In order to make sure that the wait event function is
exactly correct, we need to clear the sysram value in
cmdq initial flow.

Fixes: 623a6143a845 ("mailbox: mediatek: Add Mediatek CMDQ driver")

Signed-off-by: Bibby Hsieh <bibby.hsieh@mediatek.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mtk-cmdq-mailbox.c       | 5 +++++
 include/linux/mailbox/mtk-cmdq-mailbox.h | 3 +++
 include/linux/soc/mediatek/mtk-cmdq.h    | 3 ---
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/mailbox/mtk-cmdq-mailbox.c b/drivers/mailbox/mtk-cmdq-mailbox.c
index 00d5219094e5d..48bba49139523 100644
--- a/drivers/mailbox/mtk-cmdq-mailbox.c
+++ b/drivers/mailbox/mtk-cmdq-mailbox.c
@@ -22,6 +22,7 @@
 #define CMDQ_NUM_CMD(t)			(t->cmd_buf_size / CMDQ_INST_SIZE)
 
 #define CMDQ_CURR_IRQ_STATUS		0x10
+#define CMDQ_SYNC_TOKEN_UPDATE		0x68
 #define CMDQ_THR_SLOT_CYCLES		0x30
 #define CMDQ_THR_BASE			0x100
 #define CMDQ_THR_SIZE			0x80
@@ -104,8 +105,12 @@ static void cmdq_thread_resume(struct cmdq_thread *thread)
 
 static void cmdq_init(struct cmdq *cmdq)
 {
+	int i;
+
 	WARN_ON(clk_enable(cmdq->clock) < 0);
 	writel(CMDQ_THR_ACTIVE_SLOT_CYCLES, cmdq->base + CMDQ_THR_SLOT_CYCLES);
+	for (i = 0; i <= CMDQ_MAX_EVENT; i++)
+		writel(i, cmdq->base + CMDQ_SYNC_TOKEN_UPDATE);
 	clk_disable(cmdq->clock);
 }
 
diff --git a/include/linux/mailbox/mtk-cmdq-mailbox.h b/include/linux/mailbox/mtk-cmdq-mailbox.h
index ccb73422c2fa2..e6f54ef6698b1 100644
--- a/include/linux/mailbox/mtk-cmdq-mailbox.h
+++ b/include/linux/mailbox/mtk-cmdq-mailbox.h
@@ -20,6 +20,9 @@
 #define CMDQ_WFE_WAIT			BIT(15)
 #define CMDQ_WFE_WAIT_VALUE		0x1
 
+/** cmdq event maximum */
+#define CMDQ_MAX_EVENT			0x3ff
+
 /*
  * CMDQ_CODE_MASK:
  *   set write mask
diff --git a/include/linux/soc/mediatek/mtk-cmdq.h b/include/linux/soc/mediatek/mtk-cmdq.h
index 54ade13a9b157..4e8899972db4d 100644
--- a/include/linux/soc/mediatek/mtk-cmdq.h
+++ b/include/linux/soc/mediatek/mtk-cmdq.h
@@ -13,9 +13,6 @@
 
 #define CMDQ_NO_TIMEOUT		0xffffffffu
 
-/** cmdq event maximum */
-#define CMDQ_MAX_EVENT				0x3ff
-
 struct cmdq_pkt;
 
 struct cmdq_client {
-- 
2.20.1



