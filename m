Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3164EDD224
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388266AbfJRWIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:08:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388232AbfJRWIu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:08:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66F4A2245D;
        Fri, 18 Oct 2019 22:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436530;
        bh=7Hz5cFinExP0sQs8VQ/Osxg5CIeMdGKkH2cwpUXVmLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dyslc6VtSF0ite7QHOVoqMjp9L5zGuDnZQwHYu0qZnqvFP2MswXcCDFpTE9FlfmA0
         l9hZ+j8wg7YgGlPe+U9B46SL+WZEneU+5fn2uz2Haz/GJ2ZQvA5f3Dm3sJt//6NhQO
         BntINGQEAUR8W5ugneKWTT0aA6PhThfN3zjGxtXo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adam Ford <aford173@gmail.com>,
        Yegor Yefremov <yegorslists@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 36/56] serial: mctrl_gpio: Check for NULL pointer
Date:   Fri, 18 Oct 2019 18:07:33 -0400
Message-Id: <20191018220753.10002-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220753.10002-1-sashal@kernel.org>
References: <20191018220753.10002-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 42e42e3e7a6e6..388f710468490 100644
--- a/drivers/tty/serial/serial_mctrl_gpio.c
+++ b/drivers/tty/serial/serial_mctrl_gpio.c
@@ -69,6 +69,9 @@ EXPORT_SYMBOL_GPL(mctrl_gpio_set);
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

