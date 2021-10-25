Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECB343A10E
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234739AbhJYThK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:37:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236178AbhJYTdl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:33:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D98260200;
        Mon, 25 Oct 2021 19:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190162;
        bh=0xsAHHJHjUVBcW/QgHeKPiQYyWZE+XY7c89wOQiUFeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H1jRCxYAqBM5oxoxOq5X1vCRrHfqh/O72+7oW78yUdlArFUAlIszZ9A+PKZVFjKeK
         DmLjvI3nOVxWjpIcMN8lVZaRDf6GvOOw+CBmmxYrqiAGmJ6PR4HDUsXRWgw25Vs0R0
         zQxmmITzssTH7w7xJHgug+jM7OaW7b+hu0GP4Tcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fabien Dessenne <fabien.dessenne@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 58/58] pinctrl: stm32: use valid pin identifier in stm32_pinctrl_resume()
Date:   Mon, 25 Oct 2021 21:15:15 +0200
Message-Id: <20211025190947.321499484@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190937.555108060@linuxfoundation.org>
References: <20211025190937.555108060@linuxfoundation.org>
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
@@ -1554,8 +1554,8 @@ int __maybe_unused stm32_pinctrl_resume(
 	struct stm32_pinctrl_group *g = pctl->groups;
 	int i;
 
-	for (i = g->pin; i < g->pin + pctl->ngroups; i++)
-		stm32_pinctrl_restore_gpio_regs(pctl, i);
+	for (i = 0; i < pctl->ngroups; i++, g++)
+		stm32_pinctrl_restore_gpio_regs(pctl, g->pin);
 
 	return 0;
 }


