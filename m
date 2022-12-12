Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBE4649FBB
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbiLLNO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbiLLNOC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:14:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85ADAB56
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:14:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 255F761049
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125A2C433EF;
        Mon, 12 Dec 2022 13:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850840;
        bh=dgsijJgaHVGvAYNCfDVc6PBaCvK6D43P76YGC9hB6oQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSr99bvCehWHDyeP5bDry0K0i3wgNx5ac8ByZt8u+Te9kGR6FV4fk9eoe2mm7xcNM
         OATP+S6QoEDUokV9gu4D5P/CD1wbH2wG+dXYXWAQZPmslXtbb2jngSAklpAlfVsWn9
         ZlzrFCnZmrxvGvB4XnJgTlGsTA39VAFfyaw05fzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/106] rtc: mc146818: Reduce spinlock section in mc146818_set_time()
Date:   Mon, 12 Dec 2022 14:09:44 +0100
Message-Id: <20221212130926.653734354@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit dcf257e92622ba0e25fdc4b6699683e7ae67e2a1 ]

No need to hold the lock and disable interrupts for doing math.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20201206220541.709243630@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mc146818-lib.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
index 46527a5d3912..1ca866461d10 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -249,7 +249,6 @@ int mc146818_set_time(struct rtc_time *time)
 	if (yrs > 255)	/* They are unsigned */
 		return -EINVAL;
 
-	spin_lock_irqsave(&rtc_lock, flags);
 #ifdef CONFIG_MACH_DECSTATION
 	real_yrs = yrs;
 	leap_yr = ((!((yrs + 1900) % 4) && ((yrs + 1900) % 100)) ||
@@ -278,10 +277,8 @@ int mc146818_set_time(struct rtc_time *time)
 	/* These limits and adjustments are independent of
 	 * whether the chip is in binary mode or not.
 	 */
-	if (yrs > 169) {
-		spin_unlock_irqrestore(&rtc_lock, flags);
+	if (yrs > 169)
 		return -EINVAL;
-	}
 
 	if (yrs >= 100)
 		yrs -= 100;
@@ -297,6 +294,7 @@ int mc146818_set_time(struct rtc_time *time)
 		century = bin2bcd(century);
 	}
 
+	spin_lock_irqsave(&rtc_lock, flags);
 	save_control = CMOS_READ(RTC_CONTROL);
 	CMOS_WRITE((save_control|RTC_SET), RTC_CONTROL);
 	save_freq_select = CMOS_READ(RTC_FREQ_SELECT);
-- 
2.35.1



