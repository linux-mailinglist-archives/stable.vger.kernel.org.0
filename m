Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980211C4550
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730906AbgEDR77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 13:59:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730902AbgEDR76 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 13:59:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B69EC20663;
        Mon,  4 May 2020 17:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615197;
        bh=zpmXzaO6P1PeBJPtMvXhh7XEmu0fLIE1OTqr7nC/dcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0g/2xQG/HSd3Pf+/JlXJ/sZ0ZvRiAZGq8xa1+VwPp4MuPBnApFPcq/ls2d837MT0f
         aPSUJ3dcPP2i+KkBSBSdE5qcyuB0Awzr1ctEMZsog3Hsmqekk4LGC9VBm8wBJKkb/g
         kBzvOw2uBh3/3yICs4KR4Iq7RX3pAGpG4diVair0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.9 16/18] dmaengine: dmatest: Fix iteration non-stop logic
Date:   Mon,  4 May 2020 19:57:26 +0200
Message-Id: <20200504165445.574061312@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165442.028485341@linuxfoundation.org>
References: <20200504165442.028485341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit b9f960201249f20deea586b4ec814669b4c6b1c0 upstream.

Under some circumstances, i.e. when test is still running and about to
time out and user runs, for example,

	grep -H . /sys/module/dmatest/parameters/*

the iterations parameter is not respected and test is going on and on until
user gives

	echo 0 > /sys/module/dmatest/parameters/run

This is not what expected.

The history of this bug is interesting. I though that the commit
  2d88ce76eb98 ("dmatest: add a 'wait' parameter")
is a culprit, but looking closer to the code I think it simple revealed the
broken logic from the day one, i.e. in the commit
  0a2ff57d6fba ("dmaengine: dmatest: add a maximum number of test iterations")
which adds iterations parameter.

So, to the point, the conditional of checking the thread to be stopped being
first part of conjunction logic prevents to check iterations. Thus, we have to
always check both conditions to be able to stop after given iterations.

Since it wasn't visible before second commit appeared, I add a respective
Fixes tag.

Fixes: 2d88ce76eb98 ("dmatest: add a 'wait' parameter")
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20200424161147.16895-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/dmatest.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -505,8 +505,8 @@ static int dmatest_func(void *data)
 	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
 
 	ktime = ktime_get();
-	while (!kthread_should_stop()
-	       && !(params->iterations && total_tests >= params->iterations)) {
+	while (!(kthread_should_stop() ||
+	       (params->iterations && total_tests >= params->iterations))) {
 		struct dma_async_tx_descriptor *tx = NULL;
 		struct dmaengine_unmap_data *um;
 		dma_addr_t srcs[src_cnt];


