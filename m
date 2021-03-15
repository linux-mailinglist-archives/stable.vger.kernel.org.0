Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830B133B7E3
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbhCOOBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231286AbhCON7p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C47F64F6D;
        Mon, 15 Mar 2021 13:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816751;
        bh=T5wvFzsGYzArj4n7CriyzkjOCCV3mQtkBavvzvnzmp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=znFUWBQ5WwqBaWPMevMSVY85bTBdp0SyF+Bp3+YUMwfk2D6AXWSZqThgYex47P5S2
         cEYSVA9ovt4BVz41VNKAQ3fQRkkI3J/gUZGnvsKGTcVJ1j6GPAYDxyuy7aXW76cH6s
         oj8n3HZnzSZJpdm/3AIMgHXVxjydGR+Scad3Dbg0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chaotian Jing <chaotian.jing@mediatek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 045/120] mmc: mediatek: fix race condition between msdc_request_timeout and irq
Date:   Mon, 15 Mar 2021 14:56:36 +0100
Message-Id: <20210315135721.467709232@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Chaotian Jing <chaotian.jing@mediatek.com>

[ Upstream commit 0354ca6edd464a2cf332f390581977b8699ed081 ]

when get request SW timeout, if CMD/DAT xfer done irq coming right now,
then there is race between the msdc_request_timeout work and irq handler,
and the host->cmd and host->data may set to NULL in irq handler. also,
current flow ensure that only one path can go to msdc_request_done(), so
no need check the return value of cancel_delayed_work().

Signed-off-by: Chaotian Jing <chaotian.jing@mediatek.com>
Link: https://lore.kernel.org/r/20201218071611.12276-1-chaotian.jing@mediatek.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mtk-sd.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index 9ecf86ba4bb0..967e47770af6 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -928,13 +928,13 @@ static void msdc_track_cmd_data(struct msdc_host *host,
 static void msdc_request_done(struct msdc_host *host, struct mmc_request *mrq)
 {
 	unsigned long flags;
-	bool ret;
 
-	ret = cancel_delayed_work(&host->req_timeout);
-	if (!ret) {
-		/* delay work already running */
-		return;
-	}
+	/*
+	 * No need check the return value of cancel_delayed_work, as only ONE
+	 * path will go here!
+	 */
+	cancel_delayed_work(&host->req_timeout);
+
 	spin_lock_irqsave(&host->lock, flags);
 	host->mrq = NULL;
 	spin_unlock_irqrestore(&host->lock, flags);
@@ -952,7 +952,7 @@ static bool msdc_cmd_done(struct msdc_host *host, int events,
 	bool done = false;
 	bool sbc_error;
 	unsigned long flags;
-	u32 *rsp = cmd->resp;
+	u32 *rsp;
 
 	if (mrq->sbc && cmd == mrq->cmd &&
 	    (events & (MSDC_INT_ACMDRDY | MSDC_INT_ACMDCRCERR
@@ -973,6 +973,7 @@ static bool msdc_cmd_done(struct msdc_host *host, int events,
 
 	if (done)
 		return true;
+	rsp = cmd->resp;
 
 	sdr_clr_bits(host->base + MSDC_INTEN, cmd_ints_mask);
 
@@ -1154,7 +1155,7 @@ static void msdc_data_xfer_next(struct msdc_host *host,
 static bool msdc_data_xfer_done(struct msdc_host *host, u32 events,
 				struct mmc_request *mrq, struct mmc_data *data)
 {
-	struct mmc_command *stop = data->stop;
+	struct mmc_command *stop;
 	unsigned long flags;
 	bool done;
 	unsigned int check_data = events &
@@ -1170,6 +1171,7 @@ static bool msdc_data_xfer_done(struct msdc_host *host, u32 events,
 
 	if (done)
 		return true;
+	stop = data->stop;
 
 	if (check_data || (stop && stop->error)) {
 		dev_dbg(host->dev, "DMA status: 0x%8X\n",
-- 
2.30.1



