Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496942B6111
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729733AbgKQNPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:15:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:46992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729022AbgKQNPb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:15:31 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEF952225B;
        Tue, 17 Nov 2020 13:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618930;
        bh=aXUGh1UxMukFxGGR6UQY36C2S57jrM7cADPoatME4Nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aT3xsNg+VyKF+FtRjvsdJYWcYB8H+vdVdlM6Bc367+jDjtIv2zNpbd04fBad0xIcz
         bcSCDr4dx9djtKU/xQZupVvY5+dI56rcl3YH7JgrrlzIJsvZJnhQnpmi0wlsbERRQq
         2XfXFY5YdUqZQWnYCI3/y4//t7WFIWFFMh0O9LGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@vger.kerne.org,
        Coiby Xu <coiby.xu@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.14 56/85] pinctrl: amd: fix incorrect way to disable debounce filter
Date:   Tue, 17 Nov 2020 14:05:25 +0100
Message-Id: <20201117122113.774287792@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122111.018425544@linuxfoundation.org>
References: <20201117122111.018425544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coiby Xu <coiby.xu@gmail.com>

commit 06abe8291bc31839950f7d0362d9979edc88a666 upstream.

The correct way to disable debounce filter is to clear bit 5 and 6
of the register.

Cc: stable@vger.kerne.org
Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/linux-gpio/df2c008b-e7b5-4fdd-42ea-4d1c62b52139@redhat.com/
Link: https://lore.kernel.org/r/20201105231912.69527-2-coiby.xu@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/pinctrl-amd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -154,14 +154,14 @@ static int amd_gpio_set_debounce(struct
 			pin_reg |= BIT(DB_TMR_OUT_UNIT_OFF);
 			pin_reg |= BIT(DB_TMR_LARGE_OFF);
 		} else {
-			pin_reg &= ~DB_CNTRl_MASK;
+			pin_reg &= ~(DB_CNTRl_MASK << DB_CNTRL_OFF);
 			ret = -EINVAL;
 		}
 	} else {
 		pin_reg &= ~BIT(DB_TMR_OUT_UNIT_OFF);
 		pin_reg &= ~BIT(DB_TMR_LARGE_OFF);
 		pin_reg &= ~DB_TMR_OUT_MASK;
-		pin_reg &= ~DB_CNTRl_MASK;
+		pin_reg &= ~(DB_CNTRl_MASK << DB_CNTRL_OFF);
 	}
 	writel(pin_reg, gpio_dev->base + offset * 4);
 	raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);


