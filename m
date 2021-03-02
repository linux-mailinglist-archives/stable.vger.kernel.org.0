Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF9C32B0D4
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236056AbhCCAjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:39:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:46570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351413AbhCBOXe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 09:23:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A13A064FBA;
        Tue,  2 Mar 2021 11:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686366;
        bh=e+4B+SZc++KIqzbrcwnrHoSGfVZ62k0sVHX6gV/iffw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N8vaCFz6Eacw2j7Crvq9EhCRqvSKzg6L9GEyMwo7Jwjw6eCLalU2tx2KyN2OiluWH
         2YHoMzt1N5N44DtsL9PiW9GEj9V5HFqelhLc/Nudxr6WtjGfse2D/nsspLZrQH/5wr
         4o1Pco20hJfqMtXNV3LZ2X9BJdFpfOmmP7XpRFqlSWYhtdOaiL+QoolKBsnMcdkRh4
         g+U7IEfazcBrLIbPPd/JKvtahwWcbWlj+wBjt/1/JPmNA+Quqoq4LPHBKYaxSyxdHR
         IaHgU2qL3LJ+dXmLqxud66SIhO1CefrFnvjKtBR5xou+GaEGYx0xnwpQWvaTlYQQUA
         E2ZuWQPA3+ogQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chaotian Jing <chaotian.jing@mediatek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 03/10] mmc: mediatek: fix race condition between msdc_request_timeout and irq
Date:   Tue,  2 Mar 2021 06:59:14 -0500
Message-Id: <20210302115921.63636-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115921.63636-1-sashal@kernel.org>
References: <20210302115921.63636-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 7fc6ce381142..125c06a10455 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -741,13 +741,13 @@ static void msdc_track_cmd_data(struct msdc_host *host,
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
@@ -765,7 +765,7 @@ static bool msdc_cmd_done(struct msdc_host *host, int events,
 	bool done = false;
 	bool sbc_error;
 	unsigned long flags;
-	u32 *rsp = cmd->resp;
+	u32 *rsp;
 
 	if (mrq->sbc && cmd == mrq->cmd &&
 	    (events & (MSDC_INT_ACMDRDY | MSDC_INT_ACMDCRCERR
@@ -786,6 +786,7 @@ static bool msdc_cmd_done(struct msdc_host *host, int events,
 
 	if (done)
 		return true;
+	rsp = cmd->resp;
 
 	sdr_clr_bits(host->base + MSDC_INTEN, cmd_ints_mask);
 
@@ -968,7 +969,7 @@ static void msdc_data_xfer_next(struct msdc_host *host,
 static bool msdc_data_xfer_done(struct msdc_host *host, u32 events,
 				struct mmc_request *mrq, struct mmc_data *data)
 {
-	struct mmc_command *stop = data->stop;
+	struct mmc_command *stop;
 	unsigned long flags;
 	bool done;
 	unsigned int check_data = events &
@@ -984,6 +985,7 @@ static bool msdc_data_xfer_done(struct msdc_host *host, u32 events,
 
 	if (done)
 		return true;
+	stop = data->stop;
 
 	if (check_data || (stop && stop->error)) {
 		dev_dbg(host->dev, "DMA status: 0x%8X\n",
-- 
2.30.1

