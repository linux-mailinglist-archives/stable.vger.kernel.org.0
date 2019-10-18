Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03D36DD2B2
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389292AbfJRWJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:09:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389286AbfJRWJs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:09:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA1E222474;
        Fri, 18 Oct 2019 22:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436587;
        bh=6YTxUo/vV96WT4vAvISg0yT5ieDjpadh9376XMiWhpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZgQXJxNGCe4pQtVjuc1XMwi/hNkwqdlv3suHN/DS9pEYNQmRO2Qcsm/AMlNUCdz89
         2hiO5yQvqgGkYtmb71J80yZwTgCkQZ4j47yd4Zrj12MQAVcsrOf/EO3jx49V2udUg6
         dbs+TCZ9V6h52G5RkyiIspNmF0OkDzXPT4c9dU50=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adam Ford <aford173@gmail.com>,
        Yegor Yefremov <yegorslists@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 16/29] serial: mctrl_gpio: Check for NULL pointer
Date:   Fri, 18 Oct 2019 18:09:07 -0400
Message-Id: <20191018220920.10545-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220920.10545-1-sashal@kernel.org>
References: <20191018220920.10545-1-sashal@kernel.org>
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

