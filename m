Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0AE61E4AC
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiKFRNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:13:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiKFRM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:12:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4E815A23;
        Sun,  6 Nov 2022 09:08:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEA3460CEC;
        Sun,  6 Nov 2022 17:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BF6C433D6;
        Sun,  6 Nov 2022 17:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754452;
        bh=geLjlRX1hPWYHmgjvQ/3Wez48+UVzCZUF9p71yPjmRw=;
        h=From:To:Cc:Subject:Date:From;
        b=i0NEn6VWXKED8o/IR9ZCzhjk1lXwT+gdR0u3mg+dnRkBx8uGHUlU974b7q7uCSw6C
         XLg3Fi1JoTuY8bY6VTrGehkg9WYXa2qndO39eeu5IDYk+m7Uubb9c6jgG8K01t+CLE
         YBbdgbIsgLO9DuhkDrGXGrICJ7oh65lw2XwOQbpFr4JmpQJ7z3gT1Is7ZZ08oWxUC8
         1x3SaxPPKMcDdzjcMldCZD/gpUe3588vKqKYU3s+MQ7wY6waenPiMkOpdy1AJ27lxw
         QqoPi3pCi6FeMSLlcOmoUcFfhdfRPl3Qv2nZmClDED3QQxV1HUMGpunghzsr56zQxT
         SS0ATBE56MV2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>, a.zummo@towertech.it,
        linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9] rtc: cmos: fix build on non-ACPI platforms
Date:   Sun,  6 Nov 2022 12:07:29 -0500
Message-Id: <20221106170729.1581125-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit db4e955ae333567dea02822624106c0b96a2f84f ]

Now that rtc_wake_setup is called outside of cmos_wake_setup, it also need
to be defined on non-ACPI platforms.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/20221018203512.2532407-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 1dbd8419df7d..2c3881bdf9bb 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1113,6 +1113,9 @@ static void cmos_check_acpi_rtc_status(struct device *dev,
 {
 }
 
+static void rtc_wake_setup(struct device *dev)
+{
+}
 #endif
 
 #ifdef	CONFIG_PNP
-- 
2.35.1

