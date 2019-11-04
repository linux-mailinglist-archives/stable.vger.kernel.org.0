Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60B52EF030
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbfKDW0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:26:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730459AbfKDVvO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:51:14 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E13DB2190F;
        Mon,  4 Nov 2019 21:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904274;
        bh=6YTxUo/vV96WT4vAvISg0yT5ieDjpadh9376XMiWhpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aMF5ALdM8GruoG4wdi3lQfnLfGzPuD0xCg88o7mUdkcYqa+lgvAkReW9VbZXim05z
         neYTviVtq8jeoiRcdDVjhm0aJT2zN598HwueaDB8424NyTs/Pbz1rCB5nH0jPETans
         6ewphMpv0fIJ5WrJlFmx3IDaWkoRBs6w2kONefe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Yegor Yefremov <yegorslists@googlemail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 20/62] serial: mctrl_gpio: Check for NULL pointer
Date:   Mon,  4 Nov 2019 22:44:42 +0100
Message-Id: <20191104211920.945305962@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104211901.387893698@linuxfoundation.org>
References: <20191104211901.387893698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 37e3ab00e4734acc15d96b2926aab55c894f4d9c ]

When using mctrl_gpio_to_gpiod, it dereferences gpios into a single
requested GPIO.  This dereferencing can break if gpios is NULL,
so this patch adds a NULL check before dereferencing it.  If
gpios is NULL, this function will also return NULL.

Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Yegor Yefremov <yegorslists@googlemail.com>
Link: https://lore.kernel.org/r/20191006163314.23191-1-aford173@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_mctrl_gpio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/serial_mctrl_gpio.c b/drivers/tty/serial/serial_mctrl_gpio.c
index d2da6aa7f27d0..1bb15edcf1e77 100644
--- a/drivers/tty/serial/serial_mctrl_gpio.c
+++ b/drivers/tty/serial/serial_mctrl_gpio.c
@@ -68,6 +68,9 @@ EXPORT_SYMBOL_GPL(mctrl_gpio_set);
 struct gpio_desc *mctrl_gpio_to_gpiod(struct mctrl_gpios *gpios,
 				      enum mctrl_gpio_idx gidx)
 {
+	if (gpios == NULL)
+		return NULL;
+
 	return gpios->gpio[gidx];
 }
 EXPORT_SYMBOL_GPL(mctrl_gpio_to_gpiod);
-- 
2.20.1



