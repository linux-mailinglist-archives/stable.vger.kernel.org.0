Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE6B24B4B8
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730924AbgHTKK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:10:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728509AbgHTKKv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:10:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 489C0206DA;
        Thu, 20 Aug 2020 10:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918250;
        bh=deAXlMAOnKUuC4bREE4TaknAbxR6vkBJLpB4dFrHtk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZLoFDvTqbGYSxDLg5aS+I0TsywmKFFiV5Nq8SzCLn2af+ziAVy7FWHEBFAdNeXNBh
         kqoYIJq4pIonYZTnzcFkV1wsXr1lAzDmMxtlQ4MuiQmKnfzHoZ3RinRHcUvnTO27zL
         AG0oVGA2HWgx3hssHgehh4IFV720C8QP5sNqaTyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 087/228] leds: lm355x: avoid enum conversion warning
Date:   Thu, 20 Aug 2020 11:21:02 +0200
Message-Id: <20200820091611.964472782@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 985b1f596f9ed56f42b8c2280005f943e1434c06 ]

clang points out that doing arithmetic between diffent enums is usually
a mistake:

drivers/leds/leds-lm355x.c:167:28: warning: bitwise operation between different enumeration types ('enum lm355x_tx2' and 'enum lm355x_ntc') [-Wenum-enum-conversion]
                reg_val = pdata->pin_tx2 | pdata->ntc_pin;
                          ~~~~~~~~~~~~~~ ^ ~~~~~~~~~~~~~~
drivers/leds/leds-lm355x.c:178:28: warning: bitwise operation between different enumeration types ('enum lm355x_tx2' and 'enum lm355x_ntc') [-Wenum-enum-conversion]
                reg_val = pdata->pin_tx2 | pdata->ntc_pin | pdata->pass_mode;
                          ~~~~~~~~~~~~~~ ^ ~~~~~~~~~~~~~~

In this driver, it is intentional, so add a cast to hide the false-positive
warning. It appears to be the only instance of this warning at the moment.

Fixes: b98d13c72592 ("leds: Add new LED driver for lm355x chips")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-lm355x.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-lm355x.c b/drivers/leds/leds-lm355x.c
index 6cb94f9a2f3f3..b9c60dd2b1327 100644
--- a/drivers/leds/leds-lm355x.c
+++ b/drivers/leds/leds-lm355x.c
@@ -168,18 +168,19 @@ static int lm355x_chip_init(struct lm355x_chip_data *chip)
 	/* input and output pins configuration */
 	switch (chip->type) {
 	case CHIP_LM3554:
-		reg_val = pdata->pin_tx2 | pdata->ntc_pin;
+		reg_val = (u32)pdata->pin_tx2 | (u32)pdata->ntc_pin;
 		ret = regmap_update_bits(chip->regmap, 0xE0, 0x28, reg_val);
 		if (ret < 0)
 			goto out;
-		reg_val = pdata->pass_mode;
+		reg_val = (u32)pdata->pass_mode;
 		ret = regmap_update_bits(chip->regmap, 0xA0, 0x04, reg_val);
 		if (ret < 0)
 			goto out;
 		break;
 
 	case CHIP_LM3556:
-		reg_val = pdata->pin_tx2 | pdata->ntc_pin | pdata->pass_mode;
+		reg_val = (u32)pdata->pin_tx2 | (u32)pdata->ntc_pin |
+		          (u32)pdata->pass_mode;
 		ret = regmap_update_bits(chip->regmap, 0x0A, 0xC4, reg_val);
 		if (ret < 0)
 			goto out;
-- 
2.25.1



