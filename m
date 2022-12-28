Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 712376575CC
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 12:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbiL1LRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 06:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiL1LRw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 06:17:52 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D970AC5F;
        Wed, 28 Dec 2022 03:17:50 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 34C221EC052A;
        Wed, 28 Dec 2022 12:17:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1672226269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=y5u+/GNCy9XsEJ4ePBnmhuNYi+fgmq9Ww8t8DYoY55c=;
        b=XMSu/5JvFCBZG+XCKti567h2bTowDJRBgPgQuuooq3qzmHccVtWwPjpp92qjW/JdK7H2r/
        QD7XqPZPXAW5rErIn0HFntcm3RErZfmd4J/GR89TlDv2U0+R/jp+Xsjd8J39D7jwj7aCiu
        AhKl6iZq+7kM6AilAxvDfUXSAAZb+ig=
Date:   Wed, 28 Dec 2022 12:17:45 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, tony.luck@intel.com,
        quic_saipraka@quicinc.com, konrad.dybcio@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        james.morse@arm.com, mchehab@kernel.org, rric@kernel.org,
        linux-edac@vger.kernel.org, quic_ppareek@quicinc.com,
        luca.weiss@fairphone.com, ahalaney@redhat.com, steev@kali.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v5 01/17] EDAC/device: Make use of poll_msec value in
 edac_device_ctl_info struct
Message-ID: <Y6wl2fhbg3emlyKd@zn.tnic>
References: <20221228084028.46528-1-manivannan.sadhasivam@linaro.org>
 <20221228084028.46528-2-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221228084028.46528-2-manivannan.sadhasivam@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 28, 2022 at 02:10:12PM +0530, Manivannan Sadhasivam wrote:
> The EDAC drivers may optionally pass the poll_msec value. Use that value if
> available, else fall back to 1000ms.

Use this version for your next submission pls:

---
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Date: Wed, 28 Dec 2022 14:10:12 +0530
Subject: [PATCH] EDAC/device: Respect any driver-supplied workqueue polling value

The EDAC drivers may optionally pass the poll_msec value. Use that value
if available, else fall back to 1000ms.

  [ bp: Touchups. ]

Fixes: e27e3dac6517 ("drivers/edac: add edac_device class")
Reported-by: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Steev Klimaszewski <steev@kali.org> # Thinkpad X13s
Tested-by: Andrew Halaney <ahalaney@redhat.com> # sa8540p-ride
Cc: <stable@vger.kernel.org> # 4.9
Link: https://lore.kernel.org/r/COZYL8MWN97H.MROQ391BGA09@otso
---
 drivers/edac/edac_device.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
index 19522c568aa5..a50b7bcfb731 100644
--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -34,6 +34,9 @@
 static DEFINE_MUTEX(device_ctls_mutex);
 static LIST_HEAD(edac_device_list);
 
+/* Default workqueue processing interval on this instance, in msecs */
+#define DEFAULT_POLL_INTERVAL 1000
+
 #ifdef CONFIG_EDAC_DEBUG
 static void edac_device_dump_device(struct edac_device_ctl_info *edac_dev)
 {
@@ -336,7 +339,7 @@ static void edac_device_workq_function(struct work_struct *work_req)
 	 * whole one second to save timers firing all over the period
 	 * between integral seconds
 	 */
-	if (edac_dev->poll_msec == 1000)
+	if (edac_dev->poll_msec == DEFAULT_POLL_INTERVAL)
 		edac_queue_work(&edac_dev->work, round_jiffies_relative(edac_dev->delay));
 	else
 		edac_queue_work(&edac_dev->work, edac_dev->delay);
@@ -366,7 +369,7 @@ static void edac_device_workq_setup(struct edac_device_ctl_info *edac_dev,
 	 * timers firing on sub-second basis, while they are happy
 	 * to fire together on the 1 second exactly
 	 */
-	if (edac_dev->poll_msec == 1000)
+	if (edac_dev->poll_msec == DEFAULT_POLL_INTERVAL)
 		edac_queue_work(&edac_dev->work, round_jiffies_relative(edac_dev->delay));
 	else
 		edac_queue_work(&edac_dev->work, edac_dev->delay);
@@ -398,7 +401,7 @@ void edac_device_reset_delay_period(struct edac_device_ctl_info *edac_dev,
 {
 	unsigned long jiffs = msecs_to_jiffies(value);
 
-	if (value == 1000)
+	if (value == DEFAULT_POLL_INTERVAL)
 		jiffs = round_jiffies_relative(value);
 
 	edac_dev->poll_msec = value;
@@ -443,11 +446,7 @@ int edac_device_add_device(struct edac_device_ctl_info *edac_dev)
 		/* This instance is NOW RUNNING */
 		edac_dev->op_state = OP_RUNNING_POLL;
 
-		/*
-		 * enable workq processing on this instance,
-		 * default = 1000 msec
-		 */
-		edac_device_workq_setup(edac_dev, 1000);
+		edac_device_workq_setup(edac_dev, edac_dev->poll_msec ?: DEFAULT_POLL_INTERVAL);
 	} else {
 		edac_dev->op_state = OP_RUNNING_INTERRUPT;
 	}
-- 
2.35.1

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
