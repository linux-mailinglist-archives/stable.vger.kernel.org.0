Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC522B63BF
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732721AbgKQNlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:41:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:53522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733074AbgKQNlP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:41:15 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A468D2465E;
        Tue, 17 Nov 2020 13:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620474;
        bh=2hFli2F8qleqEX+dFtao/0XpncWMqjycl453Jb+gQRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cg9402qh+SwQ2FIyAwx6X+JGMht0ANm7kePVWfVmeBAneZw7kpl/efacSe0V5InxQ
         LmwehNn400/4SO/BpMstMfw/P2cdW3SajrR6uPSyRRxGpa9VtKGUQH8KjFZfqZXLOt
         rh2c/7LbQctyVymkxcoTBJB/1XIlOaHPzevGDQuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.9 232/255] pinctrl: amd: use higher precision for 512 RtcClk
Date:   Tue, 17 Nov 2020 14:06:12 +0100
Message-Id: <20201117122150.230174115@linuxfoundation.org>
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
@@ -156,7 +156,7 @@ static int amd_gpio_set_debounce(struct
 			pin_reg |= BIT(DB_TMR_OUT_UNIT_OFF);
 			pin_reg &= ~BIT(DB_TMR_LARGE_OFF);
 		} else if (debounce < 250000) {
-			time = debounce / 15600;
+			time = debounce / 15625;
 			pin_reg |= time & DB_TMR_OUT_MASK;
 			pin_reg &= ~BIT(DB_TMR_OUT_UNIT_OFF);
 			pin_reg |= BIT(DB_TMR_LARGE_OFF);


