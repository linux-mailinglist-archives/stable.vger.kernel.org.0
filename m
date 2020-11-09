Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DFD2AB8C6
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 13:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729874AbgKIM4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 07:56:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:51398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729542AbgKIM4o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 07:56:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FB3220684;
        Mon,  9 Nov 2020 12:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926604;
        bh=T4o0DXs6wtfVp+UjtIlSWtuCUVCA119VN3WbpaeLBak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cSVuF5HRrNLKSwgpQwGACGKBa9Iuq+vvNc4IWLIvppyDzJoVu9b+SCG5oSM7H1kcd
         qohld8+pz5vACJJETdpt03DpU/8LiID1+kZX3vcCQKYeanzap1ElMosbtHXzWBMTn9
         zxUqnVnED1CsZs+Z+jSlFGxaQIz0oiprfgoXxGOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 27/86] drivers: watchdog: rdc321x_wdt: Fix race condition bugs
Date:   Mon,  9 Nov 2020 13:54:34 +0100
Message-Id: <20201109125022.165363242@linuxfoundation.org>
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

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

[ Upstream commit 4b2e7f99cdd314263c9d172bc17193b8b6bba463 ]

In rdc321x_wdt_probe(), rdc321x_wdt_device.queue is initialized
after misc_register(), hence if ioctl is called before its
initialization which can call rdc321x_wdt_start() function,
it will see an uninitialized value of rdc321x_wdt_device.queue,
hence initialize it before misc_register().
Also, rdc321x_wdt_device.default_ticks is accessed in reset()
function called from write callback, thus initialize it before
misc_register().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20200807112902.28764-1-madhuparnabhowmik10@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/rdc321x_wdt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/rdc321x_wdt.c b/drivers/watchdog/rdc321x_wdt.c
index 47a8f1b1087d4..4568af9a165be 100644
--- a/drivers/watchdog/rdc321x_wdt.c
+++ b/drivers/watchdog/rdc321x_wdt.c
@@ -244,6 +244,8 @@ static int rdc321x_wdt_probe(struct platform_device *pdev)
 
 	rdc321x_wdt_device.sb_pdev = pdata->sb_pdev;
 	rdc321x_wdt_device.base_reg = r->start;
+	rdc321x_wdt_device.queue = 0;
+	rdc321x_wdt_device.default_ticks = ticks;
 
 	err = misc_register(&rdc321x_wdt_misc);
 	if (err < 0) {
@@ -258,14 +260,11 @@ static int rdc321x_wdt_probe(struct platform_device *pdev)
 				rdc321x_wdt_device.base_reg, RDC_WDT_RST);
 
 	init_completion(&rdc321x_wdt_device.stop);
-	rdc321x_wdt_device.queue = 0;
 
 	clear_bit(0, &rdc321x_wdt_device.inuse);
 
 	setup_timer(&rdc321x_wdt_device.timer, rdc321x_wdt_trigger, 0);
 
-	rdc321x_wdt_device.default_ticks = ticks;
-
 	dev_info(&pdev->dev, "watchdog init success\n");
 
 	return 0;
-- 
2.27.0



