Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C87D371C5B
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbhECQwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234607AbhECQuf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:50:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A85E661369;
        Mon,  3 May 2021 16:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060065;
        bh=OKwK4eLz2HroNbBIrmCzlVwA30oGt11q/lcXejRblVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LT2L8QzCrxBeqpAvBaMfgoASzHucjh+f3ROsr6XzyHlpULD9zFXHViMabAR03I2cr
         ri7srV2OTSUvKN+3rBbcNQHSY0yXHRXvEJr+q1lyJuW5BDdJhlE1UVIXVsbzWHBCmC
         HKvChfMRki9jKd0n0bYvmsHbqkjP0wAVNjpli0Rykq7jBYn9wpId+niWhl0w9RKMeb
         Qv7bXn9ktKNO1d29Qkr8nKb61Q62a8lC4xn8I7ZAtZQqDzOc2oeZpM2YH74p40+yao
         XghhlpMpxbtfSIhO7ezKnQzjZLxYS3WPt7GT1LA7hWMPV66Dt9UMOlPZkiSfC5aNRq
         c05LXkCbel6KQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>, patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 5.4 55/57] mfd: arizona: Fix rumtime PM imbalance on error
Date:   Mon,  3 May 2021 12:39:39 -0400
Message-Id: <20210503163941.2853291-55-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit fe6df2b48043bbe1e852b2320501d3b169363c35 ]

pm_runtime_get_sync() will increase the rumtime PM counter
even it returns an error. Thus a pairing decrement is needed
to prevent refcount leak. Fix this by replacing this API with
pm_runtime_resume_and_get(), which will not change the runtime
PM counter on error.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/arizona-irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
index 077d9ab112b7..d919ae9691e2 100644
--- a/drivers/mfd/arizona-irq.c
+++ b/drivers/mfd/arizona-irq.c
@@ -100,7 +100,7 @@ static irqreturn_t arizona_irq_thread(int irq, void *data)
 	unsigned int val;
 	int ret;
 
-	ret = pm_runtime_get_sync(arizona->dev);
+	ret = pm_runtime_resume_and_get(arizona->dev);
 	if (ret < 0) {
 		dev_err(arizona->dev, "Failed to resume device: %d\n", ret);
 		return IRQ_NONE;
-- 
2.30.2

