Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6BF52C9B8C
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388690AbgLAJJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:09:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:47048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389517AbgLAJJd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:09:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCC7C20770;
        Tue,  1 Dec 2020 09:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813733;
        bh=9NQSs2pV/lw8jVG7ThGGPQaP3xQQuuedXNb07Ko2Bpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJ38f/lrCYuN07lJz86rI5HQr3DuhpVuklaDYa2pIf57o483pjxjd1LlLcW1ebraD
         vkWTE60dsjKW+PNfI4WrLJrQjX4whouoFnaflOz0ULoFynqJgUUezGarPElqUroWQa
         NVI1hiISJCIRN+a+v/f3MU+XR6OEdDgeLdGBqXG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biwen Li <biwen.li@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH 5.9 013/152] rtc: pcf2127: fix a bug when not specify interrupts property
Date:   Tue,  1 Dec 2020 09:52:08 +0100
Message-Id: <20201201084713.610715337@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biwen Li <biwen.li@nxp.com>

commit 35425bafc772ee189e3c3790d7c672b80ba65909 upstream.

Fix a bug when not specify interrupts property in dts
as follows,
    rtc-pcf2127-i2c 1-0051: failed to request alarm irq
    rtc-pcf2127-i2c: probe of 1-0051 failed with error -22

Signed-off-by: Biwen Li <biwen.li@nxp.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20200915073213.12779-1-biwen.li@oss.nxp.com
Cc: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-pcf2127.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/rtc/rtc-pcf2127.c
+++ b/drivers/rtc/rtc-pcf2127.c
@@ -559,7 +559,7 @@ static int pcf2127_probe(struct device *
 	pcf2127->rtc->set_start_time = true; /* Sets actual start to 1970 */
 	pcf2127->rtc->uie_unsupported = 1;
 
-	if (alarm_irq >= 0) {
+	if (alarm_irq > 0) {
 		ret = devm_request_threaded_irq(dev, alarm_irq, NULL,
 						pcf2127_rtc_irq,
 						IRQF_TRIGGER_LOW | IRQF_ONESHOT,
@@ -570,7 +570,7 @@ static int pcf2127_probe(struct device *
 		}
 	}
 
-	if (alarm_irq >= 0 || device_property_read_bool(dev, "wakeup-source")) {
+	if (alarm_irq > 0 || device_property_read_bool(dev, "wakeup-source")) {
 		device_init_wakeup(dev, true);
 		pcf2127->rtc->ops = &pcf2127_rtc_alrm_ops;
 	}


