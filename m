Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A62E5D65BD
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 17:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732862AbfJNPBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 11:01:30 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:48751 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732518AbfJNPBa (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 14 Oct 2019 11:01:30 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id A1320656;
        Mon, 14 Oct 2019 11:01:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 14 Oct 2019 11:01:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ZsUOQ4
        Bx3DyChETaCqoXNIZg4DMALO5dsnazGPmUQ1E=; b=scQfD1Oiez6DpUCwIpkUdC
        a32n9CT4v/1AUsaXzF89AkKQy87dq60CugHtyHqM68oiVn7l8mr5w9Y2JmrS85c1
        khXowMyeyn0d5ov15gKeZByU1UiOgOe/4UN3PjF1M09Q6fB6Kkov7qOwUkpwHBlB
        GoaGcot2ejEmdIssqeMKf/AsIjHFRU4OLlszn0lKvBV95qbHKJ8IyqTa1G7onXDU
        lt5bu5WmlMzP6PSp6tB1FN6VliabXeTnSD7dQk2ZyiBk6iiCL6ReHsqbBphV5QXQ
        u5wF7ylpTPb8YgzmfbVkfwBtqBrNVRimgXnce6qP/6dRsMLlgVC8tKHFCcJAlYYQ
        ==
X-ME-Sender: <xms:yI2kXaHiCRdQJ8t-lLR_oXWYh5SAK3Vf8IaaMFcimEhM0QV-sqd_8w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjedugdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeei
X-ME-Proxy: <xmx:yI2kXag_CQu5mJHHmKKFEJlDTf9QE2vOJdM8Qb8l7WMvr_S9D4_Ndw>
    <xmx:yI2kXW11Mh6608OSwF6uDz0vodoW5_qzAjdFq2iPKPeK7_98AsN24A>
    <xmx:yI2kXdcmyb_8jDXH_D4sq7WO_1zU6sDPcYaU_TMYgjWCXRwmCfrHjg>
    <xmx:yY2kXTKcMHq190iVPTETAk3BMScC1o3d2jzTBewevOePosBwqQ8YUg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0EF2480063;
        Mon, 14 Oct 2019 11:01:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: adc: hx711: fix bug in sampling of data" failed to apply to 4.14-stable tree
To:     ak@it-klinger.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Oct 2019 17:01:26 +0200
Message-ID: <15710652867196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4043ecfb5fc4355a090111e14faf7945ff0fdbd5 Mon Sep 17 00:00:00 2001
From: Andreas Klinger <ak@it-klinger.de>
Date: Mon, 9 Sep 2019 14:37:21 +0200
Subject: [PATCH] iio: adc: hx711: fix bug in sampling of data

Fix bug in sampling function hx711_cycle() when interrupt occures while
PD_SCK is high. If PD_SCK is high for at least 60 us power down mode of
the sensor is entered which in turn leads to a wrong measurement.

Switch off interrupts during a PD_SCK high period and move query of DOUT
to the latest point of time which is at the end of PD_SCK low period.

This bug exists in the driver since it's initial addition. The more
interrupts on the system the higher is the probability that it happens.

Fixes: c3b2fdd0ea7e ("iio: adc: hx711: Add IIO driver for AVIA HX711")
Signed-off-by: Andreas Klinger <ak@it-klinger.de>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/adc/hx711.c b/drivers/iio/adc/hx711.c
index 88c7fe15003b..62e6c8badd22 100644
--- a/drivers/iio/adc/hx711.c
+++ b/drivers/iio/adc/hx711.c
@@ -100,14 +100,14 @@ struct hx711_data {
 
 static int hx711_cycle(struct hx711_data *hx711_data)
 {
-	int val;
+	unsigned long flags;
 
 	/*
 	 * if preempted for more then 60us while PD_SCK is high:
 	 * hx711 is going in reset
 	 * ==> measuring is false
 	 */
-	preempt_disable();
+	local_irq_save(flags);
 	gpiod_set_value(hx711_data->gpiod_pd_sck, 1);
 
 	/*
@@ -117,7 +117,6 @@ static int hx711_cycle(struct hx711_data *hx711_data)
 	 */
 	ndelay(hx711_data->data_ready_delay_ns);
 
-	val = gpiod_get_value(hx711_data->gpiod_dout);
 	/*
 	 * here we are not waiting for 0.2 us as suggested by the datasheet,
 	 * because the oscilloscope showed in a test scenario
@@ -125,7 +124,7 @@ static int hx711_cycle(struct hx711_data *hx711_data)
 	 * and 0.56 us for PD_SCK low on TI Sitara with 800 MHz
 	 */
 	gpiod_set_value(hx711_data->gpiod_pd_sck, 0);
-	preempt_enable();
+	local_irq_restore(flags);
 
 	/*
 	 * make it a square wave for addressing cases with capacitance on
@@ -133,7 +132,8 @@ static int hx711_cycle(struct hx711_data *hx711_data)
 	 */
 	ndelay(hx711_data->data_ready_delay_ns);
 
-	return val;
+	/* sample as late as possible */
+	return gpiod_get_value(hx711_data->gpiod_dout);
 }
 
 static int hx711_read(struct hx711_data *hx711_data)

