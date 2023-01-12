Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD82667644
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236621AbjALOac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236998AbjALO32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:29:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594D253721
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:20:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B7A5B81E6A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F2FC433EF;
        Thu, 12 Jan 2023 14:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533254;
        bh=Q3RRNW/4Y8IGb6JHUuP6QOaF/4nox5ULu15M35rdAYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rEVDp46pk9/T58LlYrPeXRb7P5YTwqqNhdLt46/7GQdUyASZ5p1ne38LseR+yysoP
         FGmtBpu1FfGkRGaQBgpiUlzlrsQ9JE1tbIG1RyuwxUj+ApP438Cj66ieDuLxudirwy
         kL+K1ym6vyUMTm50yfUmSAxU73KlLnd3Fn6cdfgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 420/783] rtc: cmos: fix build on non-ACPI platforms
Date:   Thu, 12 Jan 2023 14:52:16 +0100
Message-Id: <20230112135543.800605151@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Stable-dep-of: 83ebb7b3036d ("rtc: cmos: Disable ACPI RTC event on removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 426e6a67cc38..ff556a93a397 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1351,6 +1351,9 @@ static void cmos_check_acpi_rtc_status(struct device *dev,
 {
 }
 
+static void rtc_wake_setup(struct device *dev)
+{
+}
 #endif
 
 #ifdef	CONFIG_PNP
-- 
2.35.1



