Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F1B1EAF1C
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729565AbgFAS7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:59:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728818AbgFAR5D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:57:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A063E2073B;
        Mon,  1 Jun 2020 17:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034223;
        bh=gTD9ZJmmQfukiKb2cBKcYkeLRNsmSehEVufbEHZPuM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ITBvb+5PfzUjF5ByDmPdZHTx6s0BfP8wNZqJvcicdgdQ6HT+/SGE91HYKzSZ6rAmU
         2FWX7iX5J//0kotM7AHbzsYC3tfeQauFqL2VJwupP1cFrhmEuo3QiO24WBeKnNG8Lv
         Xu6oAhjKFM4vHogrve3XqLPT7y23T9zvjyduSPHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 47/48] sc16is7xx: move label err_spi to correct section
Date:   Mon,  1 Jun 2020 19:53:57 +0200
Message-Id: <20200601174005.550471883@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601173952.175939894@linuxfoundation.org>
References: <20200601173952.175939894@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guoqing Jiang <gqjiang@suse.com>

commit e00164a0f000de893944981f41a568c981aca658 upstream.

err_spi is used when SERIAL_SC16IS7XX_SPI is enabled, so make
the label only available under SERIAL_SC16IS7XX_SPI option.
Otherwise, the below warning appears.

drivers/tty/serial/sc16is7xx.c:1523:1: warning: label ‘err_spi’ defined but not used [-Wunused-label]
 err_spi:
  ^~~~~~~

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
Fixes: ac0cdb3d9901 ("sc16is7xx: missing unregister/delete driver on error in sc16is7xx_init()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/sc16is7xx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1489,10 +1489,12 @@ static int __init sc16is7xx_init(void)
 #endif
 	return ret;
 
+#ifdef CONFIG_SERIAL_SC16IS7XX_SPI
 err_spi:
 #ifdef CONFIG_SERIAL_SC16IS7XX_I2C
 	i2c_del_driver(&sc16is7xx_i2c_uart_driver);
 #endif
+#endif
 err_i2c:
 	uart_unregister_driver(&sc16is7xx_uart);
 	return ret;


