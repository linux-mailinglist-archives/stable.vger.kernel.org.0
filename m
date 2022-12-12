Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7499649FB0
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbiLLNN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbiLLNNs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:13:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6717C0E
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:13:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8512EB80D3A
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB01C433EF;
        Mon, 12 Dec 2022 13:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850823;
        bh=A+pYCCIR+jqQjjWqXwTz+xHS3OUV/Tan83oWN7FrWSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oftRfNwgwrcz4h3GOk58fpzJT6lMGsma84HmRvjVXlHppdkbv5VBMYgV4kgBkyJTP
         j5j5jRJPLjyLaWofy+Kz/yv+5SafnpsVHyx9+mPQ346NsQL7DXertTRFQ6AJxlO0cd
         gkG9s/wa4AwJ/OGWSliXaFHo6WmfHGDiDxcv7xHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/106] rtc: mc146818-lib: extract mc146818_avoid_UIP
Date:   Mon, 12 Dec 2022 14:09:40 +0100
Message-Id: <20221212130926.484504161@linuxfoundation.org>
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

From: Mateusz Jończyk <mat.jonczyk@o2.pl>

[ Upstream commit ec5895c0f2d87b9bf4185db1915e40fa6fcfc0ac ]

Function mc146818_get_time() contains an elaborate mechanism of reading
the RTC time while no RTC update is in progress. It turns out that
reading the RTC alarm clock also requires avoiding the RTC update.
Therefore, the mechanism in mc146818_get_time() should be reused - so
extract it into a separate function.

The logic in mc146818_avoid_UIP() is same as in mc146818_get_time()
except that after every

        if (CMOS_READ(RTC_FREQ_SELECT) & RTC_UIP) {

there is now "mdelay(1)".

To avoid producing a very unreadable patch, mc146818_get_time() will be
refactored to use mc146818_avoid_UIP() in the next patch.

Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20211210200131.153887-6-mat.jonczyk@o2.pl
Stable-dep-of: cd17420ebea5 ("rtc: cmos: avoid UIP when writing alarm time")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mc146818-lib.c | 70 ++++++++++++++++++++++++++++++++++
 include/linux/mc146818rtc.h    |  3 ++
 2 files changed, 73 insertions(+)

diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
index 94df6056c5c0..46527a5d3912 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -8,6 +8,76 @@
 #include <linux/acpi.h>
 #endif
 
+/*
+ * Execute a function while the UIP (Update-in-progress) bit of the RTC is
+ * unset.
+ *
+ * Warning: callback may be executed more then once.
+ */
+bool mc146818_avoid_UIP(void (*callback)(unsigned char seconds, void *param),
+			void *param)
+{
+	int i;
+	unsigned long flags;
+	unsigned char seconds;
+
+	for (i = 0; i < 10; i++) {
+		spin_lock_irqsave(&rtc_lock, flags);
+
+		/*
+		 * Check whether there is an update in progress during which the
+		 * readout is unspecified. The maximum update time is ~2ms. Poll
+		 * every msec for completion.
+		 *
+		 * Store the second value before checking UIP so a long lasting
+		 * NMI which happens to hit after the UIP check cannot make
+		 * an update cycle invisible.
+		 */
+		seconds = CMOS_READ(RTC_SECONDS);
+
+		if (CMOS_READ(RTC_FREQ_SELECT) & RTC_UIP) {
+			spin_unlock_irqrestore(&rtc_lock, flags);
+			mdelay(1);
+			continue;
+		}
+
+		/* Revalidate the above readout */
+		if (seconds != CMOS_READ(RTC_SECONDS)) {
+			spin_unlock_irqrestore(&rtc_lock, flags);
+			continue;
+		}
+
+		if (callback)
+			callback(seconds, param);
+
+		/*
+		 * Check for the UIP bit again. If it is set now then
+		 * the above values may contain garbage.
+		 */
+		if (CMOS_READ(RTC_FREQ_SELECT) & RTC_UIP) {
+			spin_unlock_irqrestore(&rtc_lock, flags);
+			mdelay(1);
+			continue;
+		}
+
+		/*
+		 * A NMI might have interrupted the above sequence so check
+		 * whether the seconds value has changed which indicates that
+		 * the NMI took longer than the UIP bit was set. Unlikely, but
+		 * possible and there is also virt...
+		 */
+		if (seconds != CMOS_READ(RTC_SECONDS)) {
+			spin_unlock_irqrestore(&rtc_lock, flags);
+			continue;
+		}
+		spin_unlock_irqrestore(&rtc_lock, flags);
+
+		return true;
+	}
+	return false;
+}
+EXPORT_SYMBOL_GPL(mc146818_avoid_UIP);
+
 /*
  * If the UIP (Update-in-progress) bit of the RTC is set for more then
  * 10ms, the RTC is apparently broken or not present.
diff --git a/include/linux/mc146818rtc.h b/include/linux/mc146818rtc.h
index c246ce191915..fb042e0e7d76 100644
--- a/include/linux/mc146818rtc.h
+++ b/include/linux/mc146818rtc.h
@@ -129,4 +129,7 @@ bool mc146818_does_rtc_work(void);
 unsigned int mc146818_get_time(struct rtc_time *time);
 int mc146818_set_time(struct rtc_time *time);
 
+bool mc146818_avoid_UIP(void (*callback)(unsigned char seconds, void *param),
+			void *param);
+
 #endif /* _MC146818RTC_H */
-- 
2.35.1



