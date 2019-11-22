Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31CB11070DC
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbfKVKht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:37:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:39706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727706AbfKVKhs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:37:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F88F20708;
        Fri, 22 Nov 2019 10:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419067;
        bh=julWjBlCYWiwOVW4slF5Jvmglxdu1fcIEx8uEPF98IM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BKQroPfpglQIcrxeak4SjIHpk0NbhH8dgeHdijfhKxwRp9wQSoyOFZRuQ9HMBFMjV
         1alLPH9N0W8co2pPooqkMMwR228or3SA/XrUr3GXcMIU6owlgI7In4XiGUfzEH6/vV
         uCmJF/SQusrSrfsEKj3XBolYqEAiqfQQjeGkuNj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 146/159] backlight: lm3639: Unconditionally call led_classdev_unregister
Date:   Fri, 22 Nov 2019 11:28:57 +0100
Message-Id: <20191122100841.344611282@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 7cea645ae9c5a54aa7904fddb2cdf250acd63a6c ]

Clang warns that the address of a pointer will always evaluated as true
in a boolean context.

drivers/video/backlight/lm3639_bl.c:403:14: warning: address of
'pchip->cdev_torch' will always evaluate to 'true'
[-Wpointer-bool-conversion]
        if (&pchip->cdev_torch)
        ~~   ~~~~~~~^~~~~~~~~~
drivers/video/backlight/lm3639_bl.c:405:14: warning: address of
'pchip->cdev_flash' will always evaluate to 'true'
[-Wpointer-bool-conversion]
        if (&pchip->cdev_flash)
        ~~   ~~~~~~~^~~~~~~~~~
2 warnings generated.

These statements have been present since 2012, introduced by
commit 0f59858d5119 ("backlight: add new lm3639 backlight
driver"). Given that they have been called unconditionally since
then presumably without any issues, removing the always true if
statements to fix the warnings without any real world changes.

Link: https://github.com/ClangBuiltLinux/linux/issues/119
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/lm3639_bl.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/lm3639_bl.c b/drivers/video/backlight/lm3639_bl.c
index cd50df5807ead..086611c7bc03c 100644
--- a/drivers/video/backlight/lm3639_bl.c
+++ b/drivers/video/backlight/lm3639_bl.c
@@ -400,10 +400,8 @@ static int lm3639_remove(struct i2c_client *client)
 
 	regmap_write(pchip->regmap, REG_ENABLE, 0x00);
 
-	if (&pchip->cdev_torch)
-		led_classdev_unregister(&pchip->cdev_torch);
-	if (&pchip->cdev_flash)
-		led_classdev_unregister(&pchip->cdev_flash);
+	led_classdev_unregister(&pchip->cdev_torch);
+	led_classdev_unregister(&pchip->cdev_flash);
 	if (pchip->bled)
 		device_remove_file(&(pchip->bled->dev), &dev_attr_bled_mode);
 	return 0;
-- 
2.20.1



