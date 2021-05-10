Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADB337888A
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbhEJLWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:22:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237189AbhEJLLc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D22B16101D;
        Mon, 10 May 2021 11:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644879;
        bh=OKwK4eLz2HroNbBIrmCzlVwA30oGt11q/lcXejRblVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y591PdSXqLxmZjD6tg0LyMdNE/KukCQRXFeRmbO+YbGg3+TphaORETwCKgxr/Dzxo
         XXS+ocibOWpZeZ7ek+ayF53xidfmW7PIb3jBUg9Ip3yVV+8tc/9LspEA5nlCcBEix8
         U4/4oJmZhAcOGbQeF1TMW3Sr2zMMj5wz7BmQLo2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 260/384] mfd: arizona: Fix rumtime PM imbalance on error
Date:   Mon, 10 May 2021 12:20:49 +0200
Message-Id: <20210510102023.436631500@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



