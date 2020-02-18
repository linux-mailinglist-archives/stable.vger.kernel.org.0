Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76720163184
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbgBRUBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:01:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:40866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728744AbgBRUBT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:01:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 435CA2465D;
        Tue, 18 Feb 2020 20:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056078;
        bh=sxy4tI9unjHyXjtMuYgOqv37W4y7fCByf7CdtlFP7pI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hZpET6gJ/1b+ftlFJBos2EgwsznCkehMFsR1fiwoCX9FY34Jk6HBr+vqZl/WQT7tK
         yhgWlF9/HeU4nXV4P+pMVXawoQpMpZyuly2+EuTMskRoBefoK8gCdRPWyhy0rKyMoh
         ZkjdLk8pEuOb5ot2kLbwAzLfkSJuxKnOD5SsEwYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Thomas <pthomas8589@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.5 26/80] gpio: xilinx: Fix bug where the wrong GPIO register is written to
Date:   Tue, 18 Feb 2020 20:54:47 +0100
Message-Id: <20200218190434.913942539@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Thomas <pthomas8589@gmail.com>

commit c3afa804c58e5c30ac63858b527fffadc88bce82 upstream.

Care is taken with "index", however with the current version
the actual xgpio_writereg is using index for data but
xgpio_regoffset(chip, i) for the offset. And since i is already
incremented it is incorrect. This patch fixes it so that index
is used for the offset too.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Thomas <pthomas8589@gmail.com>
Link: https://lore.kernel.org/r/20200125221410.8022-1-pthomas8589@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-xilinx.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpio-xilinx.c
+++ b/drivers/gpio/gpio-xilinx.c
@@ -147,9 +147,10 @@ static void xgpio_set_multiple(struct gp
 	for (i = 0; i < gc->ngpio; i++) {
 		if (*mask == 0)
 			break;
+		/* Once finished with an index write it out to the register */
 		if (index !=  xgpio_index(chip, i)) {
 			xgpio_writereg(chip->regs + XGPIO_DATA_OFFSET +
-				       xgpio_regoffset(chip, i),
+				       index * XGPIO_CHANNEL_OFFSET,
 				       chip->gpio_state[index]);
 			spin_unlock_irqrestore(&chip->gpio_lock[index], flags);
 			index =  xgpio_index(chip, i);
@@ -165,7 +166,7 @@ static void xgpio_set_multiple(struct gp
 	}
 
 	xgpio_writereg(chip->regs + XGPIO_DATA_OFFSET +
-		       xgpio_regoffset(chip, i), chip->gpio_state[index]);
+		       index * XGPIO_CHANNEL_OFFSET, chip->gpio_state[index]);
 
 	spin_unlock_irqrestore(&chip->gpio_lock[index], flags);
 }


