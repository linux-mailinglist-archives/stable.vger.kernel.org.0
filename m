Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604691B3ED1
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731096AbgDVKcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:32:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730569AbgDVKZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:25:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66F652075A;
        Wed, 22 Apr 2020 10:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551125;
        bh=WNjl3YMguWAoEvZRF+md9N2/nSrx4fqcpqzIGbtCVDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mG0kLSgahXQnNMdEB5nOZOxEQU30ZFzAauQid/vJdGC+633axLrKTO5o/fqA4JgfQ
         Xnhio1f6XNSpGVv1wOH8xCLc2GyAw16mEt+IY+zt59kV6qHnGOqdNdGMtJFxA8lf2b
         B7MH26f7UVmAl5iXxGtHtLUO0cTCLnq9aWZ6WJpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ricardo Ribalda Delgado <ribalda@kernel.org>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 109/166] leds: core: Fix warning message when init_data
Date:   Wed, 22 Apr 2020 11:57:16 +0200
Message-Id: <20200422095100.491642637@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda Delgado <ribalda@kernel.org>

[ Upstream commit 64ed6588c2ea618d3f9ca9d8b365ae4c19f76225 ]

The warning message when a led is renamed due to name collition can fail
to show proper original name if init_data is used. Eg:

[    9.073996] leds-gpio a0040000.leds_0: Led (null) renamed to red_led_1 due to name collision

Fixes: bb4e9af0348d ("leds: core: Add support for composing LED class device names")
Signed-off-by: Ricardo Ribalda Delgado <ribalda@kernel.org>
Acked-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-class.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 1fc40e8af75eb..3363a6551a708 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -376,7 +376,7 @@ int led_classdev_register_ext(struct device *parent,
 
 	if (ret)
 		dev_warn(parent, "Led %s renamed to %s due to name collision",
-				led_cdev->name, dev_name(led_cdev->dev));
+				proposed_name, dev_name(led_cdev->dev));
 
 	if (led_cdev->flags & LED_BRIGHT_HW_CHANGED) {
 		ret = led_add_brightness_hw_changed(led_cdev);
-- 
2.20.1



