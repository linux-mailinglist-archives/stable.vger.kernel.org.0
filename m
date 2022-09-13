Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F4A5B735D
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235605AbiIMPMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235592AbiIMPLL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:11:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE1B78201;
        Tue, 13 Sep 2022 07:32:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66C49614D6;
        Tue, 13 Sep 2022 14:21:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756D3C433C1;
        Tue, 13 Sep 2022 14:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078870;
        bh=Ub0H7ekBZDKAkZoPxqK8g/mcsM4a1qn/rveg23RwycA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ZtG1/xx7KM5kC3PqLfWxuT6H80IQ31yVAvpMMhPtk8KGwsMnyUZSv5iOuIzxDd6o
         Qu0rrPhWE6Eb4qIhc3ZVkcIC2tdo/jZmY9qsoZBYrqiyx5im9Ehavj8/UDaBcXOzny
         g58uh2wRPgV+Yd9Y2dQjL3KyOmQYQ/K7mUNFQvy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eliav Farber <farbere@amazon.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/121] hwmon: (mr75203) enable polling for all VM channels
Date:   Tue, 13 Sep 2022 16:05:05 +0200
Message-Id: <20220913140402.253144037@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eliav Farber <farbere@amazon.com>

[ Upstream commit e43212e0f55dc2d6b15d6c174cc0a64b25fab5e7 ]

Configure ip-polling register to enable polling for all voltage monitor
channels.
This enables reading the voltage values for all inputs other than just
input 0.

Fixes: 9d823351a337 ("hwmon: Add hardware monitoring driver for Moortec MR75203 PVT controller")
Signed-off-by: Eliav Farber <farbere@amazon.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220908152449.35457-7-farbere@amazon.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/mr75203.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/hwmon/mr75203.c b/drivers/hwmon/mr75203.c
index e62fae1491c85..05da83841536f 100644
--- a/drivers/hwmon/mr75203.c
+++ b/drivers/hwmon/mr75203.c
@@ -398,6 +398,19 @@ static int pvt_init(struct pvt_device *pvt)
 		if (ret)
 			return ret;
 
+		val = (BIT(pvt->c_num) - 1) | VM_CH_INIT |
+		      IP_POLL << SDIF_ADDR_SFT | SDIF_WRN_W | SDIF_PROG;
+		ret = regmap_write(v_map, SDIF_W, val);
+		if (ret < 0)
+			return ret;
+
+		ret = regmap_read_poll_timeout(v_map, SDIF_STAT,
+					       val, !(val & SDIF_BUSY),
+					       PVT_POLL_DELAY_US,
+					       PVT_POLL_TIMEOUT_US);
+		if (ret)
+			return ret;
+
 		val = CFG1_VOL_MEAS_MODE | CFG1_PARALLEL_OUT |
 		      CFG1_14_BIT | IP_CFG << SDIF_ADDR_SFT |
 		      SDIF_WRN_W | SDIF_PROG;
-- 
2.35.1



