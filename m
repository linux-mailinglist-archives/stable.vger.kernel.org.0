Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12BE72839D8
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbgJEP3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:29:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727433AbgJEP2p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:28:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91F7A2085B;
        Mon,  5 Oct 2020 15:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911724;
        bh=+lY72T++mi2yCqmDkAbpdLZPhicPGPe0qnP/BOHIv2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MAEabUQgPbNQrCS0d2pM1Wg46sNQ93aokJTY6/SNo+Ngi9hiwdkP+x4aIieBs432Q
         ZsOYXlNemFX6/cqcT7dMrP3oNcMgkJa6AFkfWXX4jBe8uKX3mtIB8Pl6qcIynud8WL
         pXj13tZpdeazVbiGNSlCNGsxuETF0qEVHB6Hjad0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, dillon min <dillon.minfei@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.4 06/57] gpio: tc35894: fix up tc35894 interrupt configuration
Date:   Mon,  5 Oct 2020 17:26:18 +0200
Message-Id: <20201005142110.113809458@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
User-Agent: quilt/0.66
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
@@ -209,7 +209,7 @@ static void tc3589x_gpio_irq_sync_unlock
 				continue;
 
 			tc3589x_gpio->oldregs[i][j] = new;
-			tc3589x_reg_write(tc3589x, regmap[i] + j * 8, new);
+			tc3589x_reg_write(tc3589x, regmap[i] + j, new);
 		}
 	}
 


