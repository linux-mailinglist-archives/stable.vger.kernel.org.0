Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18984522E4
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378120AbhKPBQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:16:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:44636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244824AbhKOTRh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:17:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35AFC634D4;
        Mon, 15 Nov 2021 18:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000673;
        bh=MvtaSTWNlsXCYO+Jb+/rr9qRdR5iiEXz0guJDQX95wY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKokxMKj0PlJjIvMgUyQ5ooOcEaJDIm7V5KQrvpEi5/0ESVEzfIicwj5AKCx5C8e3
         nCKEn+cpqACDf3bT4CeSoBx4H06bcKMzGvVhMn8FAYu2hB/+NEyZOC3foqmgHZ8wpz
         ceMbjeKdP1C/6nL//Fa0uFuxkNQ3nCQ7BTZTtnsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sander Vanheule <sander@svanheule.net>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 715/849] gpio: realtek-otto: fix GPIO line IRQ offset
Date:   Mon, 15 Nov 2021 18:03:18 +0100
Message-Id: <20211115165444.443809662@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sander Vanheule <sander@svanheule.net>

[ Upstream commit 585a07079909ba9061ddd88214c36653e1aef71a ]

The irqchip uses one domain for all GPIO lines, so the line offset
should be determined w.r.t. the first line of the first port, not the
first line of the triggered port.

Fixes: 0d82fb1127fb ("gpio: Add Realtek Otto GPIO support")
Signed-off-by: Sander Vanheule <sander@svanheule.net>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-realtek-otto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-realtek-otto.c b/drivers/gpio/gpio-realtek-otto.c
index cb64fb5a51aa1..e0cbaa1ea22ec 100644
--- a/drivers/gpio/gpio-realtek-otto.c
+++ b/drivers/gpio/gpio-realtek-otto.c
@@ -206,7 +206,7 @@ static void realtek_gpio_irq_handler(struct irq_desc *desc)
 		status = realtek_gpio_read_isr(ctrl, lines_done / 8);
 		port_pin_count = min(gc->ngpio - lines_done, 8U);
 		for_each_set_bit(offset, &status, port_pin_count) {
-			irq = irq_find_mapping(gc->irq.domain, offset);
+			irq = irq_find_mapping(gc->irq.domain, offset + lines_done);
 			generic_handle_irq(irq);
 		}
 	}
-- 
2.33.0



