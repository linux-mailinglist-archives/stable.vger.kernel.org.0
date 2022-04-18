Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76BD5505771
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244083AbiDRNzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240445AbiDRNyh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:54:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07C04969E;
        Mon, 18 Apr 2022 06:04:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70A56B80EE3;
        Mon, 18 Apr 2022 13:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C489CC385A1;
        Mon, 18 Apr 2022 13:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287056;
        bh=bHnvJd1/T2GkymnmYI0gnf1hvtn80eWyGRE2mvn2cUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xyu5rwfAOrVhlhfJ5Ren2zZ01oRoXdO438mFMx+JBdVm3hbzP7BAfU3RHFAFw7oci
         eVZtiodBCbNLkz0fbJ0SBZpguyHF2lSstRP6p3H6zEMtws5zT1QeomGiOTRiGdEXjv
         zCb+KjUmBIKxnAkx4N4jQWEJaR9LPKUXm0UtJwP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Armin Wolf <W_Armin@gmx.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 045/218] hwmon: (sch56xx-common) Replace WDOG_ACTIVE with WDOG_HW_RUNNING
Date:   Mon, 18 Apr 2022 14:11:51 +0200
Message-Id: <20220418121200.881839260@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 68c350c704fb..5fd9b6769d42 100644
--- a/drivers/hwmon/sch56xx-common.c
+++ b/drivers/hwmon/sch56xx-common.c
@@ -438,7 +438,7 @@ struct sch56xx_watchdog_data *sch56xx_watchdog_register(struct device *parent,
 	if (nowayout)
 		set_bit(WDOG_NO_WAY_OUT, &data->wddev.status);
 	if (output_enable & SCH56XX_WDOG_OUTPUT_ENABLE)
-		set_bit(WDOG_ACTIVE, &data->wddev.status);
+		set_bit(WDOG_HW_RUNNING, &data->wddev.status);
 
 	/* Since the watchdog uses a downcounter there is no register to read
 	   the BIOS set timeout from (if any was set at all) ->
-- 
2.34.1



