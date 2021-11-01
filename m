Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7606E441898
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbhKAJtg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:49:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234054AbhKAJqb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:46:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82FC8613CF;
        Mon,  1 Nov 2021 09:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759022;
        bh=JA/Hy1hpfPf7wnT5E4+pX4LGsaySt6Qf6WS3/GHh638=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IAJeUxp7sQzaWjq4UQ6e09SQH5WWz4lHQ0QMR3BSYJHTKAFviYaX5rwgHn11VUaTO
         VRFB7x8LUyao7RVchQA9gR4N95nHJoHyaRU1CDJdO20TOCXy79KGJv9R5vig/MPb5W
         Y4JSSgeLgKtnItYvzN/iqXM1lFgyWs5tnI1dvtSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonas Gorski <jonas.gorski@gmail.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 5.14 082/125] gpio: xgs-iproc: fix parsing of ngpios property
Date:   Mon,  1 Nov 2021 10:17:35 +0100
Message-Id: <20211101082548.797499643@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
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


