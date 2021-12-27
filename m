Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6FD47FEBE
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237951AbhL0PbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237575AbhL0Pal (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:30:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24362C061799;
        Mon, 27 Dec 2021 07:30:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C33D3B810CB;
        Mon, 27 Dec 2021 15:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16193C36AFA;
        Mon, 27 Dec 2021 15:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619028;
        bh=ej3DS8HwLddBqBz2WFTZlK/7p40vwxVn7l4hZEKVW4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UAk8w9A6hF1qOBzUZtC6jJCWSL3ZKfLdBvJYUCKiNFa2ZWyqKjmM6M5lZV/iR4HWt
         N3KlIWeeA7esjmqqaNTcjDPqIJz7qeHfXGWHnSK11w+aiFWQZVFtyxBnZ0Pel+DE1r
         /0twk6U4cI19y1K6aeNPk/HOTGkCbPtoUyG3NsSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Fritz <chf.fritz@googlemail.com>,
        Fabien Dessenne <fabien.dessenne@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.14 19/29] pinctrl: stm32: consider the GPIO offset to expose all the GPIO lines
Date:   Mon, 27 Dec 2021 16:27:29 +0100
Message-Id: <20211227151319.097823677@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151318.475251079@linuxfoundation.org>
References: <20211227151318.475251079@linuxfoundation.org>
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
@@ -989,10 +989,10 @@ static int stm32_gpiolib_register_bank(s
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


