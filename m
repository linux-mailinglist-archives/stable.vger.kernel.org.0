Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D492B60A6
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgKQNLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:11:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:40896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729616AbgKQNLT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:11:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C42492468F;
        Tue, 17 Nov 2020 13:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618679;
        bh=IF1+o75ZbOaKYN6cnXpp0kuY4VhZp4Y3AhUdekGb76U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mNIY9cL5+hlBva6qdRSGgA6ek0JM69sKjjZrbRaAKXY3K6z4LQyG9f78FhwOLQ2iT
         ay8r+cF2zVSlHrtmG4jsYU8+SvZU5wbSFw1NYvHROWNe63R1ZF/upsNmjTBXij/9mL
         tnRpXuOMKled1giwvxPB3PRuL3ZqjcbgplgFceMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.9 50/78] pinctrl: amd: use higher precision for 512 RtcClk
Date:   Tue, 17 Nov 2020 14:05:16 +0100
Message-Id: <20201117122111.562547424@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122109.116890262@linuxfoundation.org>
References: <20201117122109.116890262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coiby Xu <coiby.xu@gmail.com>

commit c64a6a0d4a928c63e5bc3b485552a8903a506c36 upstream.

RTC is 32.768kHz thus 512 RtcClk equals 15625 usec. The documentation
likely has dropped precision and that's why the driver mistakenly took
the slightly deviated value.

Cc: stable@vger.kernel.org
Reported-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Suggested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/linux-gpio/2f4706a1-502f-75f0-9596-cc25b4933b6c@redhat.com/
Link: https://lore.kernel.org/r/20201105231912.69527-3-coiby.xu@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/pinctrl-amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -140,7 +140,7 @@ static int amd_gpio_set_debounce(struct
 			pin_reg |= BIT(DB_TMR_OUT_UNIT_OFF);
 			pin_reg &= ~BIT(DB_TMR_LARGE_OFF);
 		} else if (debounce < 250000) {
-			time = debounce / 15600;
+			time = debounce / 15625;
 			pin_reg |= time & DB_TMR_OUT_MASK;
 			pin_reg &= ~BIT(DB_TMR_OUT_UNIT_OFF);
 			pin_reg |= BIT(DB_TMR_LARGE_OFF);


