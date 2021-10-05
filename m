Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D638D4228A9
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234964AbhJENxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:53:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235613AbhJENw7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6654B6152B;
        Tue,  5 Oct 2021 13:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441869;
        bh=gfSSvYoKamvAQoaTJ4v7jnSD7dGLcrlIf0jNkDZz3qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lhght99JIcveyYS1nJUwxMBs9bZQ4/2G6AjRPMOuWJRyyCAH+JBtPdV5qbyKSumZf
         lnVO/K3f4hQvUnU396Uk6GsLTgvpM4pNlSLwBWENSxL646xWqiqIETZmvSZTa4icGJ
         bz7Jiy1BgLSI3aVyIrP2n38oNmTcpmFjec8zrm1IFCxBsfiUMqfAzX7Am6NVq3UCdj
         IsBXcUe8N7NOg61BYtU5vmaHqdahskJDO6rGJyU418JBa34f8to8Vja0cPdHzGpUEU
         w12kl/f9iQwU3r8q15WTVePGMoPFgNYIU8cD3+uZJyLLriN0LMv9S3vlxgpf8eNy7v
         LEaf7wLhBuzCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, nuno.sa@analog.com,
        jdelvare@suse.com, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 24/40] hwmon: (ltc2947) Properly handle errors when looking for the external clock
Date:   Tue,  5 Oct 2021 09:50:03 -0400
Message-Id: <20211005135020.214291-24-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 6f7d70467121f790b36af2d84bc02b5c236bf5e6 ]

The return value of devm_clk_get should in general be propagated to
upper layer. In this case the clk is optional, use the appropriate
wrapper instead of interpreting all errors as "The optional clk is not
available".

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20210923201113.398932-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ltc2947-core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/ltc2947-core.c b/drivers/hwmon/ltc2947-core.c
index bb3f7749a0b0..5423466de697 100644
--- a/drivers/hwmon/ltc2947-core.c
+++ b/drivers/hwmon/ltc2947-core.c
@@ -989,8 +989,12 @@ static int ltc2947_setup(struct ltc2947_data *st)
 		return ret;
 
 	/* check external clock presence */
-	extclk = devm_clk_get(st->dev, NULL);
-	if (!IS_ERR(extclk)) {
+	extclk = devm_clk_get_optional(st->dev, NULL);
+	if (IS_ERR(extclk))
+		return dev_err_probe(st->dev, PTR_ERR(extclk),
+				     "Failed to get external clock\n");
+
+	if (extclk) {
 		unsigned long rate_hz;
 		u8 pre = 0, div, tbctl;
 		u64 aux;
-- 
2.33.0

