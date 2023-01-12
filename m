Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4372A66764F
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236980AbjALOai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237216AbjALO3w (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:29:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FD55DE4E
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:21:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 261DE60A69
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33729C433D2;
        Thu, 12 Jan 2023 14:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533277;
        bh=l/IY952kC2n9rsb3NiaUcU1Z5muYzzJFl08mBiHqZyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0HfZUK68EcDKH83j5b5uRT6gJ4/rpJ5X170a78rpN/DzOEBp3vKzoTlXLLVFxbW3
         Cef1gM6gbhmCBQwuLLqkDs797YaHEBY/DJW5fqWJT4uj0NtH+vkKUn9B7lYvqV2Jh5
         eZGPr32O1CG4usBduoSVnYG6WLPKJI4C2qCjuJ8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Stefan Eichenberger <stefan.eichenberger@toradex.com>,
        Francesco Dolcini <francesco@dolcini.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 426/783] rtc: snvs: Allow a time difference on clock register read
Date:   Thu, 12 Jan 2023 14:52:22 +0100
Message-Id: <20230112135544.057468546@linuxfoundation.org>
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

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

[ Upstream commit 0462681e207ccc44778a77b3297af728b1cf5b9f ]

On an iMX6ULL the following message appears when a wakealarm is set:

echo 0 > /sys/class/rtc/rtc1/wakealarm
rtc rtc1: Timeout trying to get valid LPSRT Counter read

This does not always happen but is reproducible quite often (7 out of 10
times). The problem appears because the iMX6ULL is not able to read the
registers within one 32kHz clock cycle which is the base clock of the
RTC. Therefore, this patch allows a difference of up to 320 cycles
(10ms). 10ms was chosen to be big enough even on systems with less cpu
power (e.g. iMX6ULL). According to the reference manual a difference is
fine:
- If the two consecutive reads are similar, the value is correct.
The values have to be similar, not equal.

Fixes: cd7f3a249dbe ("rtc: snvs: Add timeouts to avoid kernel lockups")
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Signed-off-by: Francesco Dolcini <francesco@dolcini.it>
Link: https://lore.kernel.org/r/20221106115915.7930-1-francesco@dolcini.it
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-snvs.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-snvs.c b/drivers/rtc/rtc-snvs.c
index 0263d996b8a8..cc7f6c4216bc 100644
--- a/drivers/rtc/rtc-snvs.c
+++ b/drivers/rtc/rtc-snvs.c
@@ -32,6 +32,14 @@
 #define SNVS_LPPGDR_INIT	0x41736166
 #define CNTR_TO_SECS_SH		15
 
+/* The maximum RTC clock cycles that are allowed to pass between two
+ * consecutive clock counter register reads. If the values are corrupted a
+ * bigger difference is expected. The RTC frequency is 32kHz. With 320 cycles
+ * we end at 10ms which should be enough for most cases. If it once takes
+ * longer than expected we do a retry.
+ */
+#define MAX_RTC_READ_DIFF_CYCLES	320
+
 struct snvs_rtc_data {
 	struct rtc_device *rtc;
 	struct regmap *regmap;
@@ -56,6 +64,7 @@ static u64 rtc_read_lpsrt(struct snvs_rtc_data *data)
 static u32 rtc_read_lp_counter(struct snvs_rtc_data *data)
 {
 	u64 read1, read2;
+	s64 diff;
 	unsigned int timeout = 100;
 
 	/* As expected, the registers might update between the read of the LSB
@@ -66,7 +75,8 @@ static u32 rtc_read_lp_counter(struct snvs_rtc_data *data)
 	do {
 		read2 = read1;
 		read1 = rtc_read_lpsrt(data);
-	} while (read1 != read2 && --timeout);
+		diff = read1 - read2;
+	} while (((diff < 0) || (diff > MAX_RTC_READ_DIFF_CYCLES)) && --timeout);
 	if (!timeout)
 		dev_err(&data->rtc->dev, "Timeout trying to get valid LPSRT Counter read\n");
 
@@ -78,13 +88,15 @@ static u32 rtc_read_lp_counter(struct snvs_rtc_data *data)
 static int rtc_read_lp_counter_lsb(struct snvs_rtc_data *data, u32 *lsb)
 {
 	u32 count1, count2;
+	s32 diff;
 	unsigned int timeout = 100;
 
 	regmap_read(data->regmap, data->offset + SNVS_LPSRTCLR, &count1);
 	do {
 		count2 = count1;
 		regmap_read(data->regmap, data->offset + SNVS_LPSRTCLR, &count1);
-	} while (count1 != count2 && --timeout);
+		diff = count1 - count2;
+	} while (((diff < 0) || (diff > MAX_RTC_READ_DIFF_CYCLES)) && --timeout);
 	if (!timeout) {
 		dev_err(&data->rtc->dev, "Timeout trying to get valid LPSRT Counter read\n");
 		return -ETIMEDOUT;
-- 
2.35.1



