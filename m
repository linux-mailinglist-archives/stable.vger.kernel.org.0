Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606F8246A11
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729827AbgHQP3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:29:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729695AbgHQP3r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:29:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 025AF23BC7;
        Mon, 17 Aug 2020 15:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678186;
        bh=oX7lTzGgeXonwrNUvKojEuRglaFg/4flqmCnB8GgwlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sofXjED3GGAUJlAwDzfLwuZhtwAMJ0IGLEKJGoxq+/rdWESjlKPkcHKLDuGIyeLRW
         KOYHCqQhgT7AjXtG39pX5vkOiYzFiwoPIG6b4zytSxHg4cmZV+93E3z6xodezwNh82
         dnoMRt5nVTCNjlC7wUVp2CevPkU1AQ2NQ/+Mls+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 220/464] leds: core: Flush scheduled work for system suspend
Date:   Mon, 17 Aug 2020 17:12:53 +0200
Message-Id: <20200817143844.342356105@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 302a085c20194bfa7df52e0fe684ee0c41da02e6 ]

Sometimes LED won't be turned off by LED_CORE_SUSPENDRESUME flag upon
system suspend.

led_set_brightness_nopm() uses schedule_work() to set LED brightness.
However, there's no guarantee that the scheduled work gets executed
because no one flushes the work.

So flush the scheduled work to make sure LED gets turned off.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Acked-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Fixes: 81fe8e5b73e3 ("leds: core: Add led_set_brightness_nosleep{nopm} functions")
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-class.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 3363a6551a708..cc3929f858b68 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -173,6 +173,7 @@ void led_classdev_suspend(struct led_classdev *led_cdev)
 {
 	led_cdev->flags |= LED_SUSPENDED;
 	led_set_brightness_nopm(led_cdev, 0);
+	flush_work(&led_cdev->set_brightness_work);
 }
 EXPORT_SYMBOL_GPL(led_classdev_suspend);
 
-- 
2.25.1



