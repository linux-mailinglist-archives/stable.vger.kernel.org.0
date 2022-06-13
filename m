Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42B05492F1
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381676AbiFMOQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381127AbiFMOMU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:12:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B6B9A99D;
        Mon, 13 Jun 2022 04:42:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A9F0B80ECD;
        Mon, 13 Jun 2022 11:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0092C34114;
        Mon, 13 Jun 2022 11:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120527;
        bh=rCSIA7RsX1fxH+QSFK64nbPN6ho0+M4zZF4daOD5wXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R8Xzv5sdGj6qIKKK6o5IY63jpvJ2ok1Qf8K8jAFdshVqpwJ9W3N0O+HD9zUpuAAdP
         7j6/zao2GTBJeF4ZQniSro+OtXcP2VEUdDVPwpzPOuyz1ebKacVLlQDIIpUWamVeh6
         mrYxzTLBOvXi5IxQXE0FK2e4b9gMqkEGQOjUFszw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 041/298] watchdog: rzg2l_wdt: Fix 32bit overflow issue
Date:   Mon, 13 Jun 2022 12:08:55 +0200
Message-Id: <20220613094926.184858976@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit ea2949df22a533cdf75e4583c00b1ce94cd5a83b ]

The value of timer_cycle_us can be 0 due to 32bit overflow.
For eg:- If we assign the counter value "0xfff" for computing
maxval.

This patch fixes this issue by appending ULL to 1024, so that
it is promoted to 64bit.

This patch also fixes the warning message, 'watchdog: Invalid min and
max timeout values, resetting to 0!'.

Fixes: 2cbc5cd0b55fa2 ("watchdog: Add Watchdog Timer driver for RZ/G2L")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20220225175320.11041-2-biju.das.jz@bp.renesas.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/rzg2l_wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/rzg2l_wdt.c b/drivers/watchdog/rzg2l_wdt.c
index 6b426df34fd6..96f2a018ab62 100644
--- a/drivers/watchdog/rzg2l_wdt.c
+++ b/drivers/watchdog/rzg2l_wdt.c
@@ -53,7 +53,7 @@ static void rzg2l_wdt_wait_delay(struct rzg2l_wdt_priv *priv)
 
 static u32 rzg2l_wdt_get_cycle_usec(unsigned long cycle, u32 wdttime)
 {
-	u64 timer_cycle_us = 1024 * 1024 * (wdttime + 1) * MICRO;
+	u64 timer_cycle_us = 1024 * 1024ULL * (wdttime + 1) * MICRO;
 
 	return div64_ul(timer_cycle_us, cycle);
 }
-- 
2.35.1



