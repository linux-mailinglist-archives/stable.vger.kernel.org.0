Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3CD499B60
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575237AbiAXVvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:51:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53240 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378618AbiAXVoA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:44:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18B40B8123A;
        Mon, 24 Jan 2022 21:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6C0C340E4;
        Mon, 24 Jan 2022 21:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060637;
        bh=t36Qf7OqaHp5mhLh63Ejubt/7CRwFd48SoJJMeaqkEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VwzbQcLF2W87QpR//XjxHNw7jM9G8kGeHB772m3LI9cB/0N8QSGfqipduRA1ncehP
         JAXxL1vRaPm2MFDw+tZz35gKUeSjdbT198exSxvM0YRjYSH2YFyjZCLIypjwi2Tmld
         gu3OxcuIgOzOsYiakuK7ULCGX+BBzdsWiUAkTPao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurence de Bruxelles <lfdebrux@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.16 0981/1039] rtc: pxa: fix null pointer dereference
Date:   Mon, 24 Jan 2022 19:46:10 +0100
Message-Id: <20220124184158.258239040@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurence de Bruxelles <lfdebrux@gmail.com>

commit 34127b3632b21e5c391756e724b1198eb9917981 upstream.

With the latest stable kernel versions the rtc on the PXA based
Zaurus does not work, when booting I see the following kernel messages:

pxa-rtc pxa-rtc: failed to find rtc clock source
pxa-rtc pxa-rtc: Unable to init SA1100 RTC sub-device
pxa-rtc: probe of pxa-rtc failed with error -2
hctosys: unable to open rtc device (rtc0)

I think this is because commit f2997775b111 ("rtc: sa1100: fix possible
race condition") moved the allocation of the rtc_device struct out of
sa1100_rtc_init and into sa1100_rtc_probe. This means that pxa_rtc_probe
also needs to do allocation for the rtc_device struct, otherwise
sa1100_rtc_init will try to dereference a null pointer. This patch adds
that allocation by copying how sa1100_rtc_probe in
drivers/rtc/rtc-sa1100.c does it; after the IRQs are set up a managed
rtc_device is allocated.

I've tested this patch with `qemu-system-arm -machine akita` and with a
real Zaurus SL-C1000 applied to 4.19, 5.4, and 5.10.

Signed-off-by: Laurence de Bruxelles <lfdebrux@gmail.com>
Fixes: f2997775b111 ("rtc: sa1100: fix possible race condition")
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220101154149.12026-1-lfdebrux@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-pxa.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/rtc/rtc-pxa.c
+++ b/drivers/rtc/rtc-pxa.c
@@ -330,6 +330,10 @@ static int __init pxa_rtc_probe(struct p
 	if (sa1100_rtc->irq_alarm < 0)
 		return -ENXIO;
 
+	sa1100_rtc->rtc = devm_rtc_allocate_device(&pdev->dev);
+	if (IS_ERR(sa1100_rtc->rtc))
+		return PTR_ERR(sa1100_rtc->rtc);
+
 	pxa_rtc->base = devm_ioremap(dev, pxa_rtc->ress->start,
 				resource_size(pxa_rtc->ress));
 	if (!pxa_rtc->base) {


