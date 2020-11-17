Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9662B63C1
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733070AbgKQNlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:41:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732752AbgKQNlR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:41:17 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8526E207BC;
        Tue, 17 Nov 2020 13:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620477;
        bh=w5oqsv+YkQpDMwFwPV/4REFGsh4hZkUjm1dPBXykcRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nGLZBk2nM7tGRbynZyz3xt4lyw6QtFSB0Pn56cPKqJzrc+bv0bZnlzvy5DX677qtN
         VNWtV75irwF8udZA5sIUpzq0qzwlV5HJJ63H8qQeM5Xyu/OFNL3QFBT9FPimGtfBF8
         h/VBo5j9qXismdjlUahDnsMJyJl7UoQj2gClGJqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@vger.kerne.org,
        Coiby Xu <coiby.xu@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.9 233/255] pinctrl: amd: fix incorrect way to disable debounce filter
Date:   Tue, 17 Nov 2020 14:06:13 +0100
Message-Id: <20201117122150.278474832@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
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
@@ -166,14 +166,14 @@ static int amd_gpio_set_debounce(struct
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


