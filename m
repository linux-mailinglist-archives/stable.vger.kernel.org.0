Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D835D2A54F1
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388964AbgKCVMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:12:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:54286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388525AbgKCVMH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:12:07 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 982BC21534;
        Tue,  3 Nov 2020 21:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437927;
        bh=iGi1A/HIjlPZYD+2SeqNGeJAXliQ5RfNBdSLrnNyclk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WpaJjmDBqXIMR42HRD463JrcFS0hkiWUkDxRuXpkJ8OfX26XwgX7er/76YbEyRtE/
         GBjcdaZWxLSUuEkrsgeD7zkfY6YxjBT+MKAVgKPdEStsi8NM5rPf5H7N83Eb15qm5e
         UFCAuz1NoS+HAGeMytm0MtaDpnHxE1A1W/9SDHDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Kevin Cernekee <cernekee@gmail.com>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, stable@kernel.org
Subject: [PATCH 4.14 064/125] leds: bcm6328, bcm6358: use devres LED registering function
Date:   Tue,  3 Nov 2020 21:37:21 +0100
Message-Id: <20201103203206.192851985@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <marek.behun@nic.cz>

commit ff5c89d44453e7ad99502b04bf798a3fc32c758b upstream.

These two drivers do not provide remove method and use devres for
allocation of other resources, yet they use led_classdev_register
instead of the devres variant, devm_led_classdev_register.

Fix this.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Cc: Álvaro Fernández Rojas <noltari@gmail.com>
Cc: Kevin Cernekee <cernekee@gmail.com>
Cc: Jaedon Shin <jaedon.shin@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/leds/leds-bcm6328.c |    2 +-
 drivers/leds/leds-bcm6358.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/leds/leds-bcm6328.c
+++ b/drivers/leds/leds-bcm6328.c
@@ -336,7 +336,7 @@ static int bcm6328_led(struct device *de
 	led->cdev.brightness_set = bcm6328_led_set;
 	led->cdev.blink_set = bcm6328_blink_set;
 
-	rc = led_classdev_register(dev, &led->cdev);
+	rc = devm_led_classdev_register(dev, &led->cdev);
 	if (rc < 0)
 		return rc;
 
--- a/drivers/leds/leds-bcm6358.c
+++ b/drivers/leds/leds-bcm6358.c
@@ -141,7 +141,7 @@ static int bcm6358_led(struct device *de
 
 	led->cdev.brightness_set = bcm6358_led_set;
 
-	rc = led_classdev_register(dev, &led->cdev);
+	rc = devm_led_classdev_register(dev, &led->cdev);
 	if (rc < 0)
 		return rc;
 


