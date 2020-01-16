Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B125140026
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387947AbgAPXsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:48:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:46320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390557AbgAPXUF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:20:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4425420684;
        Thu, 16 Jan 2020 23:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216804;
        bh=ckysY9VFPlutJpqEixPVARo8XPz0dfrhu8xT4lrUIk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sFXSap95MzF7ioYoHPKiRMGRSf1r/B5u6Az3bROSAQj/hyhb4OkWV+DJ2DIDfATD0
         Hr09HOymHrNg44qhSaRiAz+TcbycW++lsydPzk0t3GlSDPLhdpd72VokYV/EEnrnzP
         OA3SVDZFdhvJjLXrdZU0gshdu1fggNrOVNXCI0d0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 026/203] gpio: Fix error message on out-of-range GPIO in lookup table
Date:   Fri, 17 Jan 2020 00:15:43 +0100
Message-Id: <20200116231746.724719077@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit d935bd50dd14a7714cbdba9a76435dbb56edb1ae upstream.

When a GPIO offset in a lookup table is out-of-range, the printed error
message (1) does not include the actual out-of-range value, and (2)
contains an off-by-one error in the upper bound.

Avoid user confusion by also printing the actual GPIO offset, and
correcting the upper bound of the range.
While at it, use "%u" for unsigned int.

Sample impact:

    -requested GPIO 0 is out of range [0..32] for chip e6052000.gpio
    +requested GPIO 0 (45) is out of range [0..31] for chip e6052000.gpio

Fixes: 2a3cf6a3599e9015 ("gpiolib: return -ENOENT if no GPIO mapping exists")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20191127095919.4214-1-geert+renesas@glider.be
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -4328,8 +4328,9 @@ static struct gpio_desc *gpiod_find(stru
 
 		if (chip->ngpio <= p->chip_hwnum) {
 			dev_err(dev,
-				"requested GPIO %d is out of range [0..%d] for chip %s\n",
-				idx, chip->ngpio, chip->label);
+				"requested GPIO %u (%u) is out of range [0..%u] for chip %s\n",
+				idx, p->chip_hwnum, chip->ngpio - 1,
+				chip->label);
 			return ERR_PTR(-EINVAL);
 		}
 


