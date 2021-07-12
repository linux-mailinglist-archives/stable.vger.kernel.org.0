Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5C93C483B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235607AbhGLGhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:37:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236043AbhGLGfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:35:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2459860238;
        Mon, 12 Jul 2021 06:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071566;
        bh=nlOLuNtggwGJ3tkcVIGdx15wvGaENmzl1YWtE+KotX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wUnj8Hon6CSNEajin74pmYYEx1etHWUtbx3LAHuM7aGrcv4rJZbNH2wyxH2sbVQBf
         GQYi5QXYQY5FtSgb8YdKoW3mkMBm70tQDT7APL3DcrRRQZnp2767ie21hrTh02BLEV
         T4ZSLjc+rTKc+cvthAonHLvFvh4HOsJNgmliFVLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 126/593] media: imx: imx7_mipi_csis: Fix logging of only error event counters
Date:   Mon, 12 Jul 2021 08:04:46 +0200
Message-Id: <20210712060857.018301742@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7612993cc1d6..c5a548976f1d 100644
--- a/drivers/staging/media/imx/imx7-mipi-csis.c
+++ b/drivers/staging/media/imx/imx7-mipi-csis.c
@@ -597,13 +597,15 @@ static void mipi_csis_clear_counters(struct csi_state *state)
 
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



