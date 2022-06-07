Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09ED4540B92
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351068AbiFGS3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351600AbiFGSYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:24:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30A2D4104;
        Tue,  7 Jun 2022 10:54:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67933B8236A;
        Tue,  7 Jun 2022 17:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E929C36AFE;
        Tue,  7 Jun 2022 17:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624462;
        bh=4aYV3+qesPToYmG7/6BMlAecFB2vSBxvku6tOzoYkcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mqAAsJpJqDPXUvoFJbdYh494KFrCq3IKikv1ZVpzC8O4oOIkbQwAKd+NXXIrcZSto
         ALRKCh4r/f9hm8ROWQJScinbKysYJjg+ZYx30oLMb7yeQEjox+IopzxrJw7TA16b8g
         yrCHp7dp26GfAO+GFVxhdrDhg1JdBka/ZcPA0PA7LUvRBGz1+6w+9ZLg4FE0XqhLpg
         pS4K6j0VvsuJOTfmm6SI+aNy6wPDSMQlGvE5M9DWGEL9ncMpBcojGeOOHphvLKNj4t
         vlkFJfjWZhF8RB3t+p9IIbnpbbwelGj1I8oAAL3qW/N0zR7dGtOu9/+B2UM8fnVPvX
         F8UpUrwnG1rkg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liu Xinpeng <liuxp11@chinatelecom.cn>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>, linux-watchdog@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 31/60] watchdog: wdat_wdt: Stop watchdog when rebooting the system
Date:   Tue,  7 Jun 2022 13:52:28 -0400
Message-Id: <20220607175259.478835-31-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175259.478835-1-sashal@kernel.org>
References: <20220607175259.478835-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Xinpeng <liuxp11@chinatelecom.cn>

[ Upstream commit 27fdf84510a1374748904db43f6755f912736d92 ]

Executing reboot command several times on the machine "Dell
PowerEdge R740", UEFI security detection stopped machine
with the following prompt:

UEFI0082: The system was reset due to a timeout from the watchdog
timer. Check the System Event Log (SEL) or crash dumps from
Operating Sysstem to identify the source that triggered the
watchdog timer reset. Update the firmware or driver for the
identified device.

iDRAC has warning event: "The watchdog timer reset the system".

This patch fixes this issue by adding the reboot notifier.

Signed-off-by: Liu Xinpeng <liuxp11@chinatelecom.cn>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/1650984810-6247-3-git-send-email-liuxp11@chinatelecom.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/wdat_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/wdat_wdt.c b/drivers/watchdog/wdat_wdt.c
index 195c8c004b69..4fac8148a8e6 100644
--- a/drivers/watchdog/wdat_wdt.c
+++ b/drivers/watchdog/wdat_wdt.c
@@ -462,6 +462,7 @@ static int wdat_wdt_probe(struct platform_device *pdev)
 		return ret;
 
 	watchdog_set_nowayout(&wdat->wdd, nowayout);
+	watchdog_stop_on_reboot(&wdat->wdd);
 	return devm_watchdog_register_device(dev, &wdat->wdd);
 }
 
-- 
2.35.1

