Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB108188196
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgCQLFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726947AbgCQLFg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:05:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2418620714;
        Tue, 17 Mar 2020 11:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443135;
        bh=H0rW0vMvQM2DtkjsZ50Ys26s3AYXpZbX2s0A4tQT7rA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3pW7xWlxFvYlklw2qyoFrKQZ+j3botmhyS+syiBk4mykmqaTSkbwCbbg08zVIRPG
         PF08OCl4Xmqy+KUcFkR2/bAwlVVucamNfvFRLSFJX8UxicKtkTCfQ+7A5XKZtQ+6uz
         8QYb966geRouiUsJ+pAFE5d6qhPdVqufq8ThFfe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hamish Martin <hamish.martin@alliedtelesis.co.nz>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 5.4 107/123] i2c: gpio: suppress error on probe defer
Date:   Tue, 17 Mar 2020 11:55:34 +0100
Message-Id: <20200317103318.464725027@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hamish Martin <hamish.martin@alliedtelesis.co.nz>

commit 3747cd2efe7ecb9604972285ab3f60c96cb753a8 upstream.

If a GPIO we are trying to use is not available and we are deferring
the probe, don't output an error message.
This seems to have been the intent of commit 05c74778858d
("i2c: gpio: Add support for named gpios in DT") but the error was
still output due to not checking the updated 'retdesc'.

Fixes: 05c74778858d ("i2c: gpio: Add support for named gpios in DT")
Signed-off-by: Hamish Martin <hamish.martin@alliedtelesis.co.nz>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-gpio.c
+++ b/drivers/i2c/busses/i2c-gpio.c
@@ -348,7 +348,7 @@ static struct gpio_desc *i2c_gpio_get_de
 	if (ret == -ENOENT)
 		retdesc = ERR_PTR(-EPROBE_DEFER);
 
-	if (ret != -EPROBE_DEFER)
+	if (PTR_ERR(retdesc) != -EPROBE_DEFER)
 		dev_err(dev, "error trying to get descriptor: %d\n", ret);
 
 	return retdesc;


