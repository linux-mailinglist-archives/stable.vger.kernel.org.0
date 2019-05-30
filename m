Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7CF02F646
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfE3Eyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:54:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728055AbfE3DKW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:22 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5AF524481;
        Thu, 30 May 2019 03:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185822;
        bh=ot9FM3WGabb+tXREUKJBTyJMdSCYuDcHcMZmKOAYjwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FlP7QGpGBQ+eVzAw8xyzVw8I2zNJIPxm0NbniROXN2+63iVTF5Gg3ybtyZj1u18Cl
         57HWtVbK0XcO6oDdLrIQSYEonwF+iXwThnXmDZii5XfhvPeBafdZK6cWo3FO5/hNxw
         D8WwfRg50fYwW1F+oJv389nVziJxiVHa+xChtyJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 119/405] regulator: core: Actually put the gpiod after use
Date:   Wed, 29 May 2019 20:01:57 -0700
Message-Id: <20190530030547.022035842@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 78927aa40bc82f32de07323ddc1c9de07ac68180 ]

I went to great lengths to hand over the management of the GPIO
descriptors to the regulator core, and some stray rebased
oneliner in the old patch must have been assuming the devices
were still doing devres management of it.

We handed the management over to the regulator core, so of
course the regulator core shall issue gpiod_put() when done.

Sorry for the descriptor leak.

Fixes: 541d052d7215 ("regulator: core: Only support passing enable GPIO descriptors")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 968dcd9d7a070..6da41207e479a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2256,6 +2256,7 @@ static void regulator_ena_gpio_free(struct regulator_dev *rdev)
 		if (pin->gpiod == rdev->ena_pin->gpiod) {
 			if (pin->request_count <= 1) {
 				pin->request_count = 0;
+				gpiod_put(pin->gpiod);
 				list_del(&pin->list);
 				kfree(pin);
 				rdev->ena_pin = NULL;
-- 
2.20.1



