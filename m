Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B284800CF
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239824AbhL0PvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:51:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43974 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239102AbhL0Ppn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:45:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19A5C61115;
        Mon, 27 Dec 2021 15:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2022C36AEA;
        Mon, 27 Dec 2021 15:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619942;
        bh=hFSjw5ICpZUIzB/BqxNilOlWOQ5FxinM08jq2UeaV24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=erNzKmFcS4EtcyZOfilST5zXF0ZotPOruhQnHsJwZebediqZtcUti9QRo8MjEmMLL
         vm8K95NjwaCbp3bx+qdcSlxlBHByOZxN49/xg7FfTUrUwMO2DE41ymV+Wu8z4httlj
         EQCPWpoKIH03pap17wtpTVv2vOGwrI1P/tCl0FdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Fritz <chf.fritz@googlemail.com>,
        Fabien Dessenne <fabien.dessenne@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.15 091/128] pinctrl: stm32: consider the GPIO offset to expose all the GPIO lines
Date:   Mon, 27 Dec 2021 16:31:06 +0100
Message-Id: <20211227151334.547763899@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabien Dessenne <fabien.dessenne@foss.st.com>

commit b67210cc217f9ca1c576909454d846970c13dfd4 upstream.

Consider the GPIO controller offset (from "gpio-ranges") to compute the
maximum GPIO line number.
This fixes an issue where gpio-ranges uses a non-null offset.
  e.g.: gpio-ranges = <&pinctrl 6 86 10>
        In that case the last valid GPIO line is not 9 but 15 (6 + 10 - 1)

Cc: stable@vger.kernel.org
Fixes: 67e2996f72c7 ("pinctrl: stm32: fix the reported number of GPIO lines per bank")
Reported-by: Christoph Fritz <chf.fritz@googlemail.com>
Signed-off-by: Fabien Dessenne <fabien.dessenne@foss.st.com>
Link: https://lore.kernel.org/r/20211215095808.621716-1-fabien.dessenne@foss.st.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1251,10 +1251,10 @@ static int stm32_gpiolib_register_bank(s
 		bank_nr = args.args[1] / STM32_GPIO_PINS_PER_BANK;
 		bank->gpio_chip.base = args.args[1];
 
-		npins = args.args[2];
-		while (!of_parse_phandle_with_fixed_args(np, "gpio-ranges", 3,
-							 ++i, &args))
-			npins += args.args[2];
+		/* get the last defined gpio line (offset + nb of pins) */
+		npins = args.args[0] + args.args[2];
+		while (!of_parse_phandle_with_fixed_args(np, "gpio-ranges", 3, ++i, &args))
+			npins = max(npins, (int)(args.args[0] + args.args[2]));
 	} else {
 		bank_nr = pctl->nbanks;
 		bank->gpio_chip.base = bank_nr * STM32_GPIO_PINS_PER_BANK;


