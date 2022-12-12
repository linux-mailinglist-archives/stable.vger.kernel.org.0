Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10581649FAB
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbiLLNNy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbiLLNNZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:13:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAE6BF9
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:13:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFC0B61049
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B6DC433EF;
        Mon, 12 Dec 2022 13:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850798;
        bh=DqKM849x7gt3PjeNUUtRJHZ1GNC+B3dQOWwls24FMt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sQBP716JQSWb2ddwpI0WQf9prmu4X+aSUiEb+ZIby19M9epLXWFV81qWWzU8bOv//
         GIXesncXazYOpodC3+EByh0UEdy3SEhHgLRT0cahJClj2J7i5HYvsfUjF+tGJBHAew
         hyx8p+wqkbPhEPN2G/7Hj5/67dA9xd0uva1xD83g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/106] rtc: mc146818: Detect and handle broken RTCs
Date:   Mon, 12 Dec 2022 14:09:34 +0100
Message-Id: <20221212130926.209972761@linuxfoundation.org>
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

[ Upstream commit 211e5db19d15a721b2953ea54b8f26c2963720eb ]

The recent fix for handling the UIP bit unearthed another issue in the RTC
code. If the RTC is advertised but the readout is straight 0xFF because
it's not available, the old code just proceeded with crappy values, but the
new code hangs because it waits for the UIP bit to become low.

Add a sanity check in the RTC CMOS probe function which reads the RTC_VALID
register (Register D) which should have bit 0-6 cleared. If that's not the
case then fail to register the CMOS.

Add the same check to mc146818_get_time(), warn once when the condition
is true and invalidate the rtc_time data.

Reported-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Mickaël Salaün <mic@linux.microsoft.com>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/87tur3fx7w.fsf@nanos.tec.linutronix.de
Stable-dep-of: cd17420ebea5 ("rtc: cmos: avoid UIP when writing alarm time")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c         | 8 ++++++++
 drivers/rtc/rtc-mc146818-lib.c | 7 +++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 58c6382a2807..cce4b62ffdd0 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -808,6 +808,14 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 
 	spin_lock_irq(&rtc_lock);
 
+	/* Ensure that the RTC is accessible. Bit 0-6 must be 0! */
+	if ((CMOS_READ(RTC_VALID) & 0x7f) != 0) {
+		spin_unlock_irq(&rtc_lock);
+		dev_warn(dev, "not accessible\n");
+		retval = -ENXIO;
+		goto cleanup1;
+	}
+
 	if (!(flags & CMOS_RTC_FLAGS_NOFREQ)) {
 		/* force periodic irq to CMOS reset default of 1024Hz;
 		 *
diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
index 8364e4141670..7f01dc41271d 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -21,6 +21,13 @@ unsigned int mc146818_get_time(struct rtc_time *time)
 
 again:
 	spin_lock_irqsave(&rtc_lock, flags);
+	/* Ensure that the RTC is accessible. Bit 0-6 must be 0! */
+	if (WARN_ON_ONCE((CMOS_READ(RTC_VALID) & 0x7f) != 0)) {
+		spin_unlock_irqrestore(&rtc_lock, flags);
+		memset(time, 0xff, sizeof(*time));
+		return 0;
+	}
+
 	/*
 	 * Check whether there is an update in progress during which the
 	 * readout is unspecified. The maximum update time is ~2ms. Poll
-- 
2.35.1



