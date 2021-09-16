Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D4540E7D5
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347247AbhIPRgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:36:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353446AbhIPRdy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:33:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F77F61C15;
        Thu, 16 Sep 2021 16:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810892;
        bh=MA9Q8cU7Z78EOKO/dTu2ryzIHA7RNsG+Nr8gEJp1LHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RKJ+bgdCUrqiH/8fOchE4fsodN1T7eiY8Vp3Sl+gP/cZgGcKlzkFnkXKwo8yak0Fz
         uAr7zGgb4kSfTb6zuMBbxEPcASk+0S/R9XBC41jgYen3ejB11MHUdgO2VG0hCiENzT
         qUNnkCVPVU3lJ9v5QMA0ur43bnJW77miZWDYsFLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 275/432] nvmem: qfprom: Fix up qfprom_disable_fuse_blowing() ordering
Date:   Thu, 16 Sep 2021 18:00:24 +0200
Message-Id: <20210916155820.130629357@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rajendra Nayak <rnayak@codeaurora.org>

[ Upstream commit 11c4b3e264d68ba6dcd52d12dbcfd3f564f2f137 ]

qfprom_disable_fuse_blowing() disables a bunch of resources,
and then does a few register writes in the 'conf' address
space.
It works perhaps because the resources are needed only for the
'raw' register space writes, and that the 'conf' space allows
read/writes regardless.
However that makes the code look confusing, so just move the
register writes before turning off the resources in the
function.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210806085947.22682-3-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/qfprom.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvmem/qfprom.c b/drivers/nvmem/qfprom.c
index 81fbad5e939d..b0ca4c626466 100644
--- a/drivers/nvmem/qfprom.c
+++ b/drivers/nvmem/qfprom.c
@@ -139,6 +139,9 @@ static void qfprom_disable_fuse_blowing(const struct qfprom_priv *priv,
 {
 	int ret;
 
+	writel(old->timer_val, priv->qfpconf + QFPROM_BLOW_TIMER_OFFSET);
+	writel(old->accel_val, priv->qfpconf + QFPROM_ACCEL_OFFSET);
+
 	/*
 	 * This may be a shared rail and may be able to run at a lower rate
 	 * when we're not blowing fuses.  At the moment, the regulator framework
@@ -159,9 +162,6 @@ static void qfprom_disable_fuse_blowing(const struct qfprom_priv *priv,
 			 "Failed to set clock rate for disable (ignoring)\n");
 
 	clk_disable_unprepare(priv->secclk);
-
-	writel(old->timer_val, priv->qfpconf + QFPROM_BLOW_TIMER_OFFSET);
-	writel(old->accel_val, priv->qfpconf + QFPROM_ACCEL_OFFSET);
 }
 
 /**
-- 
2.30.2



