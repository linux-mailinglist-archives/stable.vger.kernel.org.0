Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3D140920D
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244356AbhIMOHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:07:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344668AbhIMOFV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:05:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 885CE61A71;
        Mon, 13 Sep 2021 13:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540393;
        bh=eGdf2kV8mRk5nNuGBmPkMg81kjmIi9C7xp7zO1+/AJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kuoZsjugTcnx1opfIqelzsOjM9QtqK+Psj4VuhpyJga2bHkpK7uF9bOrLmZTjN3Gx
         E7RHF8T96SUiInckQHwmoUKzeItttJ6oji0jwbaSy363yStxNDkIrpJ47ara97E8d2
         9iA23MhCQdIC5Pa6hWsIKHBWQRYXbtFGtmZUfgnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuogee Hsieh <khsieh@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 175/300] drm/msm/dp: replug event is converted into an unplug followed by an plug events
Date:   Mon, 13 Sep 2021 15:13:56 +0200
Message-Id: <20210913131115.312261670@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuogee Hsieh <khsieh@codeaurora.org>

[ Upstream commit 7e10bf427850f2d7133fd091999abd5fc1755cdb ]

Remove special handling of replug interrupt and instead treat replug event
as a sequential unplug followed by a plugin event. This is needed to meet
the requirements of DP Link Layer CTS test case 4.2.1.3.

Changes in V2:
-- add fixes statement

Changes in V3:
-- delete EV_HPD_REPLUG_INT

Fixes: f21c8a276c2d ("drm/msm/dp: handle irq_hpd with sink_count = 0 correctly")

Signed-off-by: Kuogee Hsieh <khsieh@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/1628196295-7382-5-git-send-email-khsieh@codeaurora.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index e6706a88d804..2b1e127390e4 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -55,7 +55,6 @@ enum {
 	EV_HPD_INIT_SETUP,
 	EV_HPD_PLUG_INT,
 	EV_IRQ_HPD_INT,
-	EV_HPD_REPLUG_INT,
 	EV_HPD_UNPLUG_INT,
 	EV_USER_NOTIFICATION,
 	EV_CONNECT_PENDING_TIMEOUT,
@@ -1119,9 +1118,6 @@ static int hpd_event_thread(void *data)
 		case EV_IRQ_HPD_INT:
 			dp_irq_hpd_handle(dp_priv, todo->data);
 			break;
-		case EV_HPD_REPLUG_INT:
-			/* do nothing */
-			break;
 		case EV_USER_NOTIFICATION:
 			dp_display_send_hpd_notification(dp_priv,
 						todo->data);
@@ -1165,10 +1161,8 @@ static irqreturn_t dp_display_irq_handler(int irq, void *dev_id)
 
 	if (hpd_isr_status & 0x0F) {
 		/* hpd related interrupts */
-		if (hpd_isr_status & DP_DP_HPD_PLUG_INT_MASK ||
-			hpd_isr_status & DP_DP_HPD_REPLUG_INT_MASK) {
+		if (hpd_isr_status & DP_DP_HPD_PLUG_INT_MASK)
 			dp_add_event(dp, EV_HPD_PLUG_INT, 0, 0);
-		}
 
 		if (hpd_isr_status & DP_DP_IRQ_HPD_INT_MASK) {
 			/* stop sentinel connect pending checking */
@@ -1176,8 +1170,10 @@ static irqreturn_t dp_display_irq_handler(int irq, void *dev_id)
 			dp_add_event(dp, EV_IRQ_HPD_INT, 0, 0);
 		}
 
-		if (hpd_isr_status & DP_DP_HPD_REPLUG_INT_MASK)
-			dp_add_event(dp, EV_HPD_REPLUG_INT, 0, 0);
+		if (hpd_isr_status & DP_DP_HPD_REPLUG_INT_MASK) {
+			dp_add_event(dp, EV_HPD_UNPLUG_INT, 0, 0);
+			dp_add_event(dp, EV_HPD_PLUG_INT, 0, 3);
+		}
 
 		if (hpd_isr_status & DP_DP_HPD_UNPLUG_INT_MASK)
 			dp_add_event(dp, EV_HPD_UNPLUG_INT, 0, 0);
-- 
2.30.2



