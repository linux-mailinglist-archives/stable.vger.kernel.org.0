Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3605F549312
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380488AbiFMN7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380505AbiFMNyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:54:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE9D443E2;
        Mon, 13 Jun 2022 04:35:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 23B81CE1232;
        Mon, 13 Jun 2022 11:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B3EC36AFF;
        Mon, 13 Jun 2022 11:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120107;
        bh=4aYV3+qesPToYmG7/6BMlAecFB2vSBxvku6tOzoYkcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qnquiUfNFIyox0w45cE4n4y/FtbCT+xoi7Yo84gblPvEf3ojGVTHvp6JyHON5pBlz
         B8/Et8FvGNXkJUSl6snk4b+1yFiiQnYmGX3tHuDikjBNlj73A6OsnjbxpgPYnJwPat
         GLti8tFa65U4guobirfFIxSTWrHmEIhDuqxSGcgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Xinpeng <liuxp11@chinatelecom.cn>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 253/339] watchdog: wdat_wdt: Stop watchdog when rebooting the system
Date:   Mon, 13 Jun 2022 12:11:18 +0200
Message-Id: <20220613094934.325985974@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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



