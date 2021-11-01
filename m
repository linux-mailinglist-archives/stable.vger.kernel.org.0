Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A8D44179E
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233228AbhKAJiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:38:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233281AbhKAJf7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:35:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC8A9611C0;
        Mon,  1 Nov 2021 09:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758777;
        bh=JA/Hy1hpfPf7wnT5E4+pX4LGsaySt6Qf6WS3/GHh638=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z8eYl/ai/rZQPwr71Xe2BN2ffl/jDLn8AIXJGlkOrmw4iMxcF7jTtaj9oAGMU1D/8
         dwH/v0bKBQEutGLDnWTHzdjzv3YqSJHByTvumkLVNm1oTKTM/y/3whkuTVIcCpVfNh
         /DyAPnGonucCgrrlI04GTtjArH+bKAmqcG8GkNpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonas Gorski <jonas.gorski@gmail.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 5.10 54/77] gpio: xgs-iproc: fix parsing of ngpios property
Date:   Mon,  1 Nov 2021 10:17:42 +0100
Message-Id: <20211101082523.035810837@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Gorski <jonas.gorski@gmail.com>

commit 85fe6415c146d5d42ce300c12f1ecf4d4af47d40 upstream.

of_property_read_u32 returns 0 on success, not true, so we need to
invert the check to actually take over the provided ngpio value.

Fixes: 6a41b6c5fc20 ("gpio: Add xgs-iproc driver")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-xgs-iproc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-xgs-iproc.c
+++ b/drivers/gpio/gpio-xgs-iproc.c
@@ -224,7 +224,7 @@ static int iproc_gpio_probe(struct platf
 	}
 
 	chip->gc.label = dev_name(dev);
-	if (of_property_read_u32(dn, "ngpios", &num_gpios))
+	if (!of_property_read_u32(dn, "ngpios", &num_gpios))
 		chip->gc.ngpio = num_gpios;
 
 	irq = platform_get_irq(pdev, 0);


