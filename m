Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1902D047C
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729614AbgLFLqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:46:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:46534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727936AbgLFLqB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:46:01 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Andre=20M=C3=BCller?= <andre.muller@web.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.9 42/46] Input: atmel_mxt_ts - fix lost interrupts
Date:   Sun,  6 Dec 2020 12:17:50 +0100
Message-Id: <20201206111558.487534010@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111556.455533723@linuxfoundation.org>
References: <20201206111556.455533723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit 8c3b55a299c325830a987de21dab6a89ecb71164 upstream.

After commit 74d905d2d38a devices requiring the workaround for edge
triggered interrupts stopped working.

The hardware needs the quirk to be used before even proceeding to
check if the quirk is needed because mxt_acquire_irq() is called
before mxt_check_retrigen() is called and at this point pending IRQs
need to be checked, and if the workaround is not active, all
interrupts will be lost from this point.

Solve this by switching the calls around.

Reported-by: Andre Müller <andre.muller@web.de>
Tested-by: Andre Müller <andre.muller@web.de>
Suggested-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Fixes: 74d905d2d38a ("Input: atmel_mxt_ts - only read messages in mxt_acquire_irq() when necessary")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201201123026.1416743-1-linus.walleij@linaro.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/touchscreen/atmel_mxt_ts.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -2183,11 +2183,11 @@ static int mxt_initialize(struct mxt_dat
 		msleep(MXT_FW_RESET_TIME);
 	}
 
-	error = mxt_acquire_irq(data);
+	error = mxt_check_retrigen(data);
 	if (error)
 		return error;
 
-	error = mxt_check_retrigen(data);
+	error = mxt_acquire_irq(data);
 	if (error)
 		return error;
 


