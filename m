Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE6F5511CD
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 09:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239524AbiFTHus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 03:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239558AbiFTHus (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 20 Jun 2022 03:50:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71E5101EA
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 00:50:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73792B80EAC
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 07:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C68C341C4;
        Mon, 20 Jun 2022 07:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655711445;
        bh=tS5MqbiKAS2jdJ7NqkHRaM5WPoav7+UAaSqoKV82AvA=;
        h=Subject:To:From:Date:From;
        b=dijrVBinFFQJK2Kiz8QcZmBxN4Bo7eLIkAL5ieeowtkV1I25jD+gGiBtMKw4vNnht
         ZeLyJpBCnvD05JN/gYg1GjsXsW4QugXqKNMPjp3UG0its8Bzw59f7YDFimZDTlOM0+
         QV8gBxS8p3dLB77yzkvjZBZ+RFsMCNcu9MVy1pxE=
Subject: patch "iio: adc: axp288: Override TS pin bias current for some models" added to char-misc-linus
To:     hdegoede@redhat.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jun 2022 09:50:36 +0200
Message-ID: <165571143618236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: axp288: Override TS pin bias current for some models

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 048058399f19d43cf21de9f5d36cd8144337d004 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Fri, 6 May 2022 11:50:40 +0200
Subject: iio: adc: axp288: Override TS pin bias current for some models
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since commit 9bcf15f75cac ("iio: adc: axp288: Fix TS-pin handling") we
preserve the bias current set by the firmware at boot. This fixes issues
we were seeing on various models.

Some models like the Nuvision Solo 10 Draw tablet actually need the
old hardcoded 80ųA bias current for battery temperature monitoring
to work properly.

Add a quirk entry for the Nuvision Solo 10 Draw to the DMI quirk table
to restore setting the bias current to 80ųA on this model.

Fixes: 9bcf15f75cac ("iio: adc: axp288: Fix TS-pin handling")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215882
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220506095040.21008-1-hdegoede@redhat.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/axp288_adc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iio/adc/axp288_adc.c b/drivers/iio/adc/axp288_adc.c
index a4b8be5b8f88..580361bd9849 100644
--- a/drivers/iio/adc/axp288_adc.c
+++ b/drivers/iio/adc/axp288_adc.c
@@ -196,6 +196,14 @@ static const struct dmi_system_id axp288_adc_ts_bias_override[] = {
 		},
 		.driver_data = (void *)(uintptr_t)AXP288_ADC_TS_BIAS_80UA,
 	},
+	{
+		/* Nuvision Solo 10 Draw */
+		.matches = {
+		  DMI_MATCH(DMI_SYS_VENDOR, "TMAX"),
+		  DMI_MATCH(DMI_PRODUCT_NAME, "TM101W610L"),
+		},
+		.driver_data = (void *)(uintptr_t)AXP288_ADC_TS_BIAS_80UA,
+	},
 	{}
 };
 
-- 
2.36.1


