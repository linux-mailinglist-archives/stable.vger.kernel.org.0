Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2015228B638
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgJLNb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:31:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726724AbgJLNb5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:31:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B651204EA;
        Mon, 12 Oct 2020 13:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509516;
        bh=/ngqEW/vsmhMDLi44tJJDbJfbYHofzdjf8TSrjQVgng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mm6/D/l55XpPloeI2WqY+HQ4arCm3Qn3t8jspqlVOuJV3aaMMvf5Sc2RY8aBSowuA
         bZwlMW1mxylKwmH2/Uc9+6YTWCs7Ha0sjfA9K0FVf4GOlAAcUxsTBVm6zKdSZC4VMY
         nyZ2SoavEO95mjf0udvJrHIlFhaBo9CARrA9UhlY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, dillon min <dillon.minfei@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 4.4 01/39] gpio: tc35894: fix up tc35894 interrupt configuration
Date:   Mon, 12 Oct 2020 15:26:31 +0200
Message-Id: <20201012132628.209157557@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132628.130632267@linuxfoundation.org>
References: <20201012132628.130632267@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: dillon min <dillon.minfei@gmail.com>

commit 214b0e1ad01abf4c1f6d8d28fa096bf167e47cef upstream.

The offset of regmap is incorrect, j * 8 is move to the
wrong register.

for example:

asume i = 0, j = 1. we want to set KPY5 as interrupt
falling edge mode, regmap[0][1] should be TC3589x_GPIOIBE1 0xcd
but, regmap[i] + j * 8 = TC3589x_GPIOIBE0 + 8 ,point to 0xd4,
this is TC3589x_GPIOIE2 not TC3589x_GPIOIBE1.

Fixes: d88b25be3584 ("gpio: Add TC35892 GPIO driver")
Cc: Cc: stable@vger.kernel.org
Signed-off-by: dillon min <dillon.minfei@gmail.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-tc3589x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-tc3589x.c
+++ b/drivers/gpio/gpio-tc3589x.c
@@ -157,7 +157,7 @@ static void tc3589x_gpio_irq_sync_unlock
 				continue;
 
 			tc3589x_gpio->oldregs[i][j] = new;
-			tc3589x_reg_write(tc3589x, regmap[i] + j * 8, new);
+			tc3589x_reg_write(tc3589x, regmap[i] + j, new);
 		}
 	}
 


