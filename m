Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3BF9451DCB
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344457AbhKPAeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343900AbhKOTWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6C1F63601;
        Mon, 15 Nov 2021 18:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002119;
        bh=nTA0OQ5mkvkAXPhwPrgOfiLVMD0IM1hnlXcwnO14uIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/FIC3lFRjzIvKxgyBGAi5t+U9j2UR9qq8/JGq5NPVwrFB5YYRaHyWmkMhD7+GR8B
         OSj1T1GhkkQ/CulgygrZbPa67d6/O2gr6sM4WEeb60GKKlz8xLhiryKsQpJ6EY6kQq
         aCa8GsnKFhrnKJo9FIha0jAAaQi9/2t7vnDuje34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "jason-jh.lin" <jason-jh.lin@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 444/917] mailbox: Remove WARN_ON for async_cb.cb in cmdq_exec_done
Date:   Mon, 15 Nov 2021 17:58:59 +0100
Message-Id: <20211115165443.835130179@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: jason-jh.lin <jason-jh.lin@mediatek.com>

[ Upstream commit ce1537fe288469bf68ee0aabdb860a790b4755ef ]

Because mtk_drm_crtc_update_config is not using cmdq_pkt_flush_async,
it won't have pkt->async_cb.cb anymore.

So remove the WARN_ON check of pkt->async_cb.cb at cmdq_exec_done.

Fixes: 1b6b0ce2240e ("mailbox: mtk-cmdq: Use mailbox rx_callback")
Signed-off-by: jason-jh.lin <jason-jh.lin@mediatek.com>
Reviewed-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Tested-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mtk-cmdq-mailbox.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mailbox/mtk-cmdq-mailbox.c b/drivers/mailbox/mtk-cmdq-mailbox.c
index 64175a893312e..c591dab9d5a48 100644
--- a/drivers/mailbox/mtk-cmdq-mailbox.c
+++ b/drivers/mailbox/mtk-cmdq-mailbox.c
@@ -195,7 +195,6 @@ static void cmdq_task_exec_done(struct cmdq_task *task, int sta)
 	struct cmdq_task_cb *cb = &task->pkt->async_cb;
 	struct cmdq_cb_data data;
 
-	WARN_ON(cb->cb == (cmdq_async_flush_cb)NULL);
 	data.sta = sta;
 	data.data = cb->data;
 	data.pkt = task->pkt;
-- 
2.33.0



