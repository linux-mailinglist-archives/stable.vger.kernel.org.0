Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18CF047FFD4
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238810AbhL0PlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239491AbhL0Pjx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:39:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AD0C061D7E;
        Mon, 27 Dec 2021 07:38:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5EAECCE10CC;
        Mon, 27 Dec 2021 15:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A80DC36AEA;
        Mon, 27 Dec 2021 15:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619511;
        bh=dgVMjO2OdeTtZetlH445MXROVfdSwgWAmjiLmMwT7/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t21v83SlC/Pv28n8Q/1AbOrsOnDmQeau52qZxm3JXKxwTlb53Q8d2YR7yGA0iPHCB
         lppfVzjy6BxMGKBef4PSbUDgg41GrPk6efF5mlb03NNWYz/H4hu8Fkdi5tUbVXWRBM
         vkpTNq0OKk0YwkuD5FzXVgO6C+zDNLbNgveASMIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Fritz <chf.fritz@googlemail.com>,
        Fabien Dessenne <fabien.dessenne@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.10 50/76] pinctrl: stm32: consider the GPIO offset to expose all the GPIO lines
Date:   Mon, 27 Dec 2021 16:31:05 +0100
Message-Id: <20211227151326.432257362@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
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
@@ -1255,10 +1255,10 @@ static int stm32_gpiolib_register_bank(s
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


