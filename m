Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2514F4F261B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbiDEHyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbiDEHyD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:54:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1C91FCED;
        Tue,  5 Apr 2022 00:49:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC5A4B81B9C;
        Tue,  5 Apr 2022 07:49:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234A8C340EE;
        Tue,  5 Apr 2022 07:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144959;
        bh=SjknEhECGb1fUja6ZVAmAJQKcOM/RZ1nOx6+Lr4wAFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u8S6zqGalXEvKhgM6N19o6YUO/gqWEY39JwuPC1gIlAbw6vciUGcSpKbPKO3pBbhN
         C9oE878v60az8EQdj3RZ5Tu9ndMU/sZvAC6NKCjgeGdED/erDTsHj+lkjrKgQTAljb
         ydBqtYddqdcoG3LO5T45hGsO2JBGednvhr/bnEcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Armin Wolf <W_Armin@gmx.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0234/1126] hwmon: (sch56xx-common) Replace WDOG_ACTIVE with WDOG_HW_RUNNING
Date:   Tue,  5 Apr 2022 09:16:21 +0200
Message-Id: <20220405070414.476504766@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 647d6f09bea7dacf4cdb6d4ea7e3051883955297 ]

If the watchdog was already enabled by the BIOS after booting, the
watchdog infrastructure needs to regularly send keepalives to
prevent a unexpected reset.
WDOG_ACTIVE only serves as an status indicator for userspace,
we want to use WDOG_HW_RUNNING instead.

Since my Fujitsu Esprimo P720 does not support the watchdog,
this change is compile-tested only.

Suggested-by: Guenter Roeck <linux@roeck-us.net>
Fixes: fb551405c0f8 (watchdog: sch56xx: Use watchdog core)
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20220131211935.3656-5-W_Armin@gmx.de
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sch56xx-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/sch56xx-common.c b/drivers/hwmon/sch56xx-common.c
index 40cdadad35e5..f85eede6d766 100644
--- a/drivers/hwmon/sch56xx-common.c
+++ b/drivers/hwmon/sch56xx-common.c
@@ -422,7 +422,7 @@ void sch56xx_watchdog_register(struct device *parent, u16 addr, u32 revision,
 	data->wddev.max_timeout = 255 * 60;
 	watchdog_set_nowayout(&data->wddev, nowayout);
 	if (output_enable & SCH56XX_WDOG_OUTPUT_ENABLE)
-		set_bit(WDOG_ACTIVE, &data->wddev.status);
+		set_bit(WDOG_HW_RUNNING, &data->wddev.status);
 
 	/* Since the watchdog uses a downcounter there is no register to read
 	   the BIOS set timeout from (if any was set at all) ->
-- 
2.34.1



