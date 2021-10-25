Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC7443A1B2
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235244AbhJYTlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:41:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235684AbhJYTi7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:38:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DFE961163;
        Mon, 25 Oct 2021 19:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190512;
        bh=/X01LOUD1dPdcjHdPWSDPKQaXLtregIRRilZO4YHnqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IocDomZLT9OuqtMQCDxkgvILdsp+HaaM+LnrzhCKOyvyKx4fCOcAiZfJeVdkKhas+
         lV5vV5+MwUvXsXoZpT8+w//R0bPH32bEvJzAc47J2cM9UXXRm4fuQ+8/sIDw7nYivZ
         6xQk0lO13/37//UgOFIqbpYyno5VUmwB/NM9tIIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fabien Dessenne <fabien.dessenne@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.10 95/95] pinctrl: stm32: use valid pin identifier in stm32_pinctrl_resume()
Date:   Mon, 25 Oct 2021 21:15:32 +0200
Message-Id: <20211025191010.419680432@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabien Dessenne <fabien.dessenne@foss.st.com>

commit c370bb474016ab9edfdabd7c08a88dd13a71ddbd upstream.

When resuming from low power, the driver attempts to restore the
configuration of some pins. This is done by a call to:
  stm32_pinctrl_restore_gpio_regs(struct stm32_pinctrl *pctl, u32 pin)
where 'pin' must be a valid pin value (i.e. matching some 'groups->pin').
Fix the current implementation which uses some wrong 'pin' value.

Fixes: e2f3cf18c3e2 ("pinctrl: stm32: add suspend/resume management")
Signed-off-by: Fabien Dessenne <fabien.dessenne@foss.st.com>
Link: https://lore.kernel.org/r/20211008122517.617633-1-fabien.dessenne@foss.st.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1645,8 +1645,8 @@ int __maybe_unused stm32_pinctrl_resume(
 	struct stm32_pinctrl_group *g = pctl->groups;
 	int i;
 
-	for (i = g->pin; i < g->pin + pctl->ngroups; i++)
-		stm32_pinctrl_restore_gpio_regs(pctl, i);
+	for (i = 0; i < pctl->ngroups; i++, g++)
+		stm32_pinctrl_restore_gpio_regs(pctl, g->pin);
 
 	return 0;
 }


