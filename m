Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB503BB38D
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233072AbhGDXSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:18:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233513AbhGDXOa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BD576195D;
        Sun,  4 Jul 2021 23:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440203;
        bh=oM6rNDpqYweL1cftZv3xe5lFVrjsjChJGVwr3e8zkuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=APY4fmy644bXE6E1qPOZamwaL5DmCO4qByKYzajOl7THQD/M0npe5oLe/+R8SPwLP
         67PK2AJordaoRvjTp9TV7TFsL309VIRtiQna8nEPKycGH6Pidv2tV0ksYLYF5dpQPF
         DvvaffxWctUvTtX9mpuijkmk0AjOOM6yZGnkx3xgHvRk5wcjvsFEisCdjYvYGsMpLK
         yCcgLZ4dOex+VGbsZlpQ2rKNEX2kE9KeljgRVeWpTXgyawvWOSI2tmRG3nHYozaKEQ
         gs9MPK/iDlSE2U1eaQSB8RNcNa0Z7Z42WG84L9+JCZy3aLwlIB59nb2fF9C+rW4KWP
         gIsymgmbPF2Uw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 19/50] media: imx: imx7_mipi_csis: Fix logging of only error event counters
Date:   Sun,  4 Jul 2021 19:09:07 -0400
Message-Id: <20210704230938.1490742-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230938.1490742-1-sashal@kernel.org>
References: <20210704230938.1490742-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit d2fcc9c2de1191ea80366e3658711753738dd10a ]

The mipi_csis_events array ends with 6 non-error events, not 4. Update
mipi_csis_log_counters() accordingly. While at it, log event counters in
forward order, as there's no reason to log them backward.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Rui Miguel Silva <rmfrfs@gmail.com>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Tested-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx7-mipi-csis.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/imx/imx7-mipi-csis.c b/drivers/staging/media/imx/imx7-mipi-csis.c
index 021bbd420390..63bc78e4cac8 100644
--- a/drivers/staging/media/imx/imx7-mipi-csis.c
+++ b/drivers/staging/media/imx/imx7-mipi-csis.c
@@ -528,13 +528,15 @@ static void mipi_csis_clear_counters(struct csi_state *state)
 
 static void mipi_csis_log_counters(struct csi_state *state, bool non_errors)
 {
-	int i = non_errors ? MIPI_CSIS_NUM_EVENTS : MIPI_CSIS_NUM_EVENTS - 4;
+	unsigned int num_events = non_errors ? MIPI_CSIS_NUM_EVENTS
+				: MIPI_CSIS_NUM_EVENTS - 6;
 	struct device *dev = &state->pdev->dev;
 	unsigned long flags;
+	unsigned int i;
 
 	spin_lock_irqsave(&state->slock, flags);
 
-	for (i--; i >= 0; i--) {
+	for (i = 0; i < num_events; ++i) {
 		if (state->events[i].counter > 0 || state->debug)
 			dev_info(dev, "%s events: %d\n", state->events[i].name,
 				 state->events[i].counter);
-- 
2.30.2

