Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36622ABD97
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbgKINrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:47:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729956AbgKIM5G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 07:57:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59F6D2076E;
        Mon,  9 Nov 2020 12:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926626;
        bh=l9HSeZUjS80DOowO4TnmG0zYTDW27BeAkkJ4o2kg1rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rH36tU2X3JV2xIVrw5VBJPvhUa0qlhNSzLWTEiQyic3s4FtHW3LDpU+jvStszrcg1
         Uqt8kQlhUXYNVvXj9Es55SkbUdJWdLvZO4Tvc2z+UyMOJ33ZluYjPTt9ujtjXUvOVA
         NvRJjHPJjQdwCq7TGX6Ik7ohRxW5SCGSB7LHeQlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Kevin Cernekee <cernekee@gmail.com>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, stable@kernel.org
Subject: [PATCH 4.4 34/86] leds: bcm6328, bcm6358: use devres LED registering function
Date:   Mon,  9 Nov 2020 13:54:41 +0100
Message-Id: <20201109125022.494520725@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
References: <20201109125020.852643676@linuxfoundation.org>
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
@@ -325,7 +325,7 @@ static int bcm6328_led(struct device *de
 	led->cdev.brightness_set = bcm6328_led_set;
 	led->cdev.blink_set = bcm6328_blink_set;
 
-	rc = led_classdev_register(dev, &led->cdev);
+	rc = devm_led_classdev_register(dev, &led->cdev);
 	if (rc < 0)
 		return rc;
 
--- a/drivers/leds/leds-bcm6358.c
+++ b/drivers/leds/leds-bcm6358.c
@@ -146,7 +146,7 @@ static int bcm6358_led(struct device *de
 
 	led->cdev.brightness_set = bcm6358_led_set;
 
-	rc = led_classdev_register(dev, &led->cdev);
+	rc = devm_led_classdev_register(dev, &led->cdev);
 	if (rc < 0)
 		return rc;
 


