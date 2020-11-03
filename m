Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256EC2A5711
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732818AbgKCVdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:33:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:58862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730614AbgKCU4u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:56:50 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FDF622226;
        Tue,  3 Nov 2020 20:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437009;
        bh=CyFb5VJgvERbUC354uy3tkiqj0u9ziVcYwZrsK2ObNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JZHzXQSsw4BYRlNi6KIZfvpvPhEe7zFNROlUv3o0LhQUUrZF68wly3GjH9LG+towD
         NVKiCrALjEBc1I6GAI4kfJh9cdotkYEygZTd8ciygUotNauCNDdtfwHMRDOhHnPmL0
         63apF8mY8nibPznzaBHkhQyDQpM5UUjcfV8DxXgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Kevin Cernekee <cernekee@gmail.com>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, stable@kernel.org
Subject: [PATCH 5.4 106/214] leds: bcm6328, bcm6358: use devres LED registering function
Date:   Tue,  3 Nov 2020 21:35:54 +0100
Message-Id: <20201103203300.955807997@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
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
@@ -332,7 +332,7 @@ static int bcm6328_led(struct device *de
 	led->cdev.brightness_set = bcm6328_led_set;
 	led->cdev.blink_set = bcm6328_blink_set;
 
-	rc = led_classdev_register(dev, &led->cdev);
+	rc = devm_led_classdev_register(dev, &led->cdev);
 	if (rc < 0)
 		return rc;
 
--- a/drivers/leds/leds-bcm6358.c
+++ b/drivers/leds/leds-bcm6358.c
@@ -137,7 +137,7 @@ static int bcm6358_led(struct device *de
 
 	led->cdev.brightness_set = bcm6358_led_set;
 
-	rc = led_classdev_register(dev, &led->cdev);
+	rc = devm_led_classdev_register(dev, &led->cdev);
 	if (rc < 0)
 		return rc;
 


