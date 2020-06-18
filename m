Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9861FE40B
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgFRCPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:15:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728803AbgFRBUf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:20:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17E76206F1;
        Thu, 18 Jun 2020 01:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443234;
        bh=jooARIFQyutBq1ygAucaUY+mBk/+xG06hczMM+cGxrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZFQBSwXrObF4kZ+fWuQAYBmb6tpcDsznZ4etaApXK5ZY5ZAvkGEn+QaZZ4OhDiRjp
         1lTr+PGtdMByYgNxTI6ECFFPE5sRmK1mLDHUFWzOa3kJ38yLl/fW70NoWzHfABxOQ4
         rY5whY03Psjb/Hug46NBDUP/C1FJX2k51z/DQyCA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amelie Delaunay <amelie.delaunay@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 187/266] mfd: stmfx: Fix stmfx_irq_init error path
Date:   Wed, 17 Jun 2020 21:15:12 -0400
Message-Id: <20200618011631.604574-187-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amelie Delaunay <amelie.delaunay@st.com>

[ Upstream commit 60c2c4bcb9202acad4cc26af20b44b6bd7874f7b ]

In case the interrupt signal can't be configured, IRQ domain needs to be
removed.

Fixes: 06252ade9156 ("mfd: Add ST Multi-Function eXpander (STMFX) core driver")
Signed-off-by: Amelie Delaunay <amelie.delaunay@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/stmfx.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/stmfx.c b/drivers/mfd/stmfx.c
index fde6541e347c..1977fe95f876 100644
--- a/drivers/mfd/stmfx.c
+++ b/drivers/mfd/stmfx.c
@@ -287,14 +287,19 @@ static int stmfx_irq_init(struct i2c_client *client)
 
 	ret = regmap_write(stmfx->map, STMFX_REG_IRQ_OUT_PIN, irqoutpin);
 	if (ret)
-		return ret;
+		goto irq_exit;
 
 	ret = devm_request_threaded_irq(stmfx->dev, client->irq,
 					NULL, stmfx_irq_handler,
 					irqtrigger | IRQF_ONESHOT,
 					"stmfx", stmfx);
 	if (ret)
-		stmfx_irq_exit(client);
+		goto irq_exit;
+
+	return 0;
+
+irq_exit:
+	stmfx_irq_exit(client);
 
 	return ret;
 }
-- 
2.25.1

