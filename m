Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97A7513F845
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731514AbgAPQz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:55:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:40638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732792AbgAPQzZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:55:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFC6122522;
        Thu, 16 Jan 2020 16:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193724;
        bh=bbNkedQdnDzdtuUlAZ2NagqN5EXVfxVOs37adHQ4BEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZJzo/G2HLWjfXwgiP9E493ETgx21Y3sJQQMlGULYOk0ku3sqXHLc1FULYRJhaSOk
         GvpzDlidoGbFLCvofUxpRZsOyG8XwBh8wezrnGs4bGbAbH3dgvdo45cwofUSGJ8QDE
         41KE4O0128ytpB0k4MmpZzNTig7sTOznomoVaOVc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Houlong Wei <houlong.wei@mediatek.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 018/671] mailbox: mediatek: Add check for possible failure of kzalloc
Date:   Thu, 16 Jan 2020 11:44:09 -0500
Message-Id: <20200116165502.8838-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Houlong Wei <houlong.wei@mediatek.com>

[ Upstream commit 9f0a0a381c5db56e7922dbeea6831f27db58372f ]

The patch 623a6143a845("mailbox: mediatek: Add Mediatek CMDQ driver")
introduce the following static checker warning:
  drivers/mailbox/mtk-cmdq-mailbox.c:366 cmdq_mbox_send_data()
  error: potential null dereference 'task'.  (kzalloc returns null)

Fixes: 623a6143a845 ("mailbox: mediatek: Add Mediatek CMDQ driver")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Houlong Wei <houlong.wei@mediatek.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mtk-cmdq-mailbox.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mailbox/mtk-cmdq-mailbox.c b/drivers/mailbox/mtk-cmdq-mailbox.c
index aec46d5d3506..f7cc29c00302 100644
--- a/drivers/mailbox/mtk-cmdq-mailbox.c
+++ b/drivers/mailbox/mtk-cmdq-mailbox.c
@@ -363,6 +363,9 @@ static int cmdq_mbox_send_data(struct mbox_chan *chan, void *data)
 	WARN_ON(cmdq->suspended);
 
 	task = kzalloc(sizeof(*task), GFP_ATOMIC);
+	if (!task)
+		return -ENOMEM;
+
 	task->cmdq = cmdq;
 	INIT_LIST_HEAD(&task->list_entry);
 	task->pa_base = pkt->pa_base;
-- 
2.20.1

