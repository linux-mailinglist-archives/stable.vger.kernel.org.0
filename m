Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F369D61E491
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbiKFRMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbiKFRLo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:11:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF5513FB8;
        Sun,  6 Nov 2022 09:07:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D09D360D24;
        Sun,  6 Nov 2022 17:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90678C4347C;
        Sun,  6 Nov 2022 17:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754449;
        bh=8wkmgLIUz/8ONLcdxFh5UBQs2mnb8QbTZn5857tQxEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AO96oGDF8322xajuUwXtg+00axarcJgVRdLMHqLX8XS8NR+ETBjeQjRpwM6oMEF04
         tE9yUJ69R4REqhx+LPXLjNPS/G0+DGweeWhZN9OuhS6036NptXj0LpQ7QDSyXXMtRd
         BIfJMxkpft4n4UXdqYr/9hhz5aq44OhA+J7wbYQUITWXQWeDOwIK+43NHZuAzo9DtM
         X7BkJDLElOC4s4pEJ2FMENxArgUNGtTcPYKPR+4K7VQU4SfMoq5l97I9QQU2QbPnGZ
         P0W3F3WE8cgoL2oSiuooqKddexbtnzZTbCAII7X28JZt9+QbejlB5oldgRhWfn66BC
         yjdATy75fMBTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>, a.zummo@towertech.it,
        linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 2/2] rtc: cmos: fix build on non-ACPI platforms
Date:   Sun,  6 Nov 2022 12:07:23 -0500
Message-Id: <20221106170724.1581086-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221106170724.1581086-1-sashal@kernel.org>
References: <20221106170724.1581086-1-sashal@kernel.org>
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
index 5e2ee430b3f8..655caf2cf1e6 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1189,6 +1189,9 @@ static void cmos_check_acpi_rtc_status(struct device *dev,
 {
 }
 
+static void rtc_wake_setup(struct device *dev)
+{
+}
 #endif
 
 #ifdef	CONFIG_PNP
-- 
2.35.1

