Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 960EB9E21C
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729818AbfH0IQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:16:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbfH0HxX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:53:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71CD3206BA;
        Tue, 27 Aug 2019 07:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892403;
        bh=Jie4Z5NXgR+SZsUsabxqaQqBZME0D+RudUPlaEOqIY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HJDLeGJ9vPvsM0M0kmxoLvzVNXFllYG1orTjOcbE79AkT6d/UU4rcTdgxwXlVRUaL
         VJ+GUFuPmCO/zhQuqIm7zbSv92j6N+9kanjsFrPLFcyHwASuHtW727SH6teyxChIhD
         n0EdQY64DvPSaKDUk8dxkpNs7Dpc2JhWJHqNAayc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.14 42/62] gpiolib: never report open-drain/source lines as input to user-space
Date:   Tue, 27 Aug 2019 09:50:47 +0200
Message-Id: <20190827072703.032244937@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072659.803647352@linuxfoundation.org>
References: <20190827072659.803647352@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

commit 2c60e6b5c9241b24b8b523fefd3e44fb85622cda upstream.

If the driver doesn't support open-drain/source config options, we
emulate this behavior when setting the direction by calling
gpiod_direction_input() if the default value is 0 (open-source) or
1 (open-drain), thus not actively driving the line in those cases.

This however clears the FLAG_IS_OUT bit for the GPIO line descriptor
and makes the LINEINFO ioctl() incorrectly report this line's mode as
'input' to user-space.

This commit modifies the ioctl() to always set the GPIOLINE_FLAG_IS_OUT
bit in the lineinfo structure's flags field. Since it's impossible to
use the input mode and open-drain/source options at the same time, we
can be sure the reported information will be correct.

Fixes: 521a2ad6f862 ("gpio: add userspace ABI for GPIO line information")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Link: https://lore.kernel.org/r/20190806114151.17652-1-brgl@bgdev.pl
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -971,9 +971,11 @@ static long gpio_ioctl(struct file *filp
 		if (test_bit(FLAG_ACTIVE_LOW, &desc->flags))
 			lineinfo.flags |= GPIOLINE_FLAG_ACTIVE_LOW;
 		if (test_bit(FLAG_OPEN_DRAIN, &desc->flags))
-			lineinfo.flags |= GPIOLINE_FLAG_OPEN_DRAIN;
+			lineinfo.flags |= (GPIOLINE_FLAG_OPEN_DRAIN |
+					   GPIOLINE_FLAG_IS_OUT);
 		if (test_bit(FLAG_OPEN_SOURCE, &desc->flags))
-			lineinfo.flags |= GPIOLINE_FLAG_OPEN_SOURCE;
+			lineinfo.flags |= (GPIOLINE_FLAG_OPEN_SOURCE |
+					   GPIOLINE_FLAG_IS_OUT);
 
 		if (copy_to_user(ip, &lineinfo, sizeof(lineinfo)))
 			return -EFAULT;


