Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B83DD18A5AE
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 22:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgCRVDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 17:03:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728437AbgCRUzp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:55:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8FE4208FE;
        Wed, 18 Mar 2020 20:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564944;
        bh=ctyX5zrqCFcoyk2sSXO2XUC6BM1qpvOncSDgBlMNsKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bDnkOcwo6wVbPaMFVp5HWCLV11G3ry2s2Fhv0sSg3TepDiXS0JD7WfqzFLO9ZzYsA
         oxXIEo54Ha0VK3Mew0CWmtfO4+InmhwMzLYvZ2ypJZj5k9mJKIWc27JIOn37yCdqjz
         rjJmbP6VjYH/OjERIB3mIx1HTDQuPZiQcSdmcCQA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hamish Martin <hamish.martin@alliedtelesis.co.nz>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 29/37] i2c: gpio: suppress error on probe defer
Date:   Wed, 18 Mar 2020 16:55:01 -0400
Message-Id: <20200318205509.17053-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205509.17053-1-sashal@kernel.org>
References: <20200318205509.17053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hamish Martin <hamish.martin@alliedtelesis.co.nz>

[ Upstream commit 3747cd2efe7ecb9604972285ab3f60c96cb753a8 ]

If a GPIO we are trying to use is not available and we are deferring
the probe, don't output an error message.
This seems to have been the intent of commit 05c74778858d
("i2c: gpio: Add support for named gpios in DT") but the error was
still output due to not checking the updated 'retdesc'.

Fixes: 05c74778858d ("i2c: gpio: Add support for named gpios in DT")
Signed-off-by: Hamish Martin <hamish.martin@alliedtelesis.co.nz>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
index c008d209f0b83..87014d144ccdc 100644
--- a/drivers/i2c/busses/i2c-gpio.c
+++ b/drivers/i2c/busses/i2c-gpio.c
@@ -248,7 +248,7 @@ static struct gpio_desc *i2c_gpio_get_desc(struct device *dev,
 	if (ret == -ENOENT)
 		retdesc = ERR_PTR(-EPROBE_DEFER);
 
-	if (ret != -EPROBE_DEFER)
+	if (PTR_ERR(retdesc) != -EPROBE_DEFER)
 		dev_err(dev, "error trying to get descriptor: %d\n", ret);
 
 	return retdesc;
-- 
2.20.1

