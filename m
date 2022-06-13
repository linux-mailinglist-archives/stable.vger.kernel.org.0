Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7558C548C07
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350889AbiFMMld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356996AbiFMMji (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:39:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139515DD2D;
        Mon, 13 Jun 2022 04:10:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8D5A60B79;
        Mon, 13 Jun 2022 11:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFD0C34114;
        Mon, 13 Jun 2022 11:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118599;
        bh=BZmku8ynkgmOkGRaWD1uCFlINFlU+hWhNKDr32It42w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=frfmhGW1x/KUNZoAKklgWvBC/4H+XVF7D9JSjtlefRjmCJQYXRp9wYHF6RSkrRdkV
         MYzsmKYNmlMSuVgdx0rDjzHUeyz3O5FO5NtMsHM0E/6qGYof0AxSCzEGpkM0W9fNXd
         h6Mb2LFM7yX7ueHhLC8l9Pjcp2uslzoyWbRqRftI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Xinpeng <liuxp11@chinatelecom.cn>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/172] watchdog: wdat_wdt: Stop watchdog when rebooting the system
Date:   Mon, 13 Jun 2022 12:11:34 +0200
Message-Id: <20220613094921.474024787@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 3065dd670a18..c60723f5ed99 100644
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



