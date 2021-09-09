Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB9A404B6B
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240171AbhIILwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:52:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236591AbhIILuX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:50:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C47761350;
        Thu,  9 Sep 2021 11:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187828;
        bh=MA9Q8cU7Z78EOKO/dTu2ryzIHA7RNsG+Nr8gEJp1LHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jFgF8vkWvl98B/sdo/42NTaZkNl8s837907Ncjg4Fkx6X/cJEb5WANWDUrS16LU1c
         myjiIuyx1MEvGjbZEdUiD4dqCvVARHKg616KLqBzHmfN3xibpMwMH1U9L8LDmzqmcw
         mnvPTkjdXP5CDTgIwV+jA/OKK794Oplnkip17c2obHAYW41VJSTqdYjSjYc8SS37CE
         l3ifdDJOqP8HSEpK+x6EudmCSXHxCgz9BWd5SZAxS5gVBfm21VuOjF8zKqYFb8yN3M
         5uzaVyepurqHEHPGxHuUR9zlSeY1RG8El+GOHepWGu+hVarsN6/xT6YikX1mAtPdR6
         F/TWwmBh3wSvQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rajendra Nayak <rnayak@codeaurora.org>,
        Douglas Anderson <dianders@chromium.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.14 125/252] nvmem: qfprom: Fix up qfprom_disable_fuse_blowing() ordering
Date:   Thu,  9 Sep 2021 07:38:59 -0400
Message-Id: <20210909114106.141462-125-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

