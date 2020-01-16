Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCD613FE59
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391246AbgAPXej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:34:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:43296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404292AbgAPXdL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:33:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8822B2072B;
        Thu, 16 Jan 2020 23:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217591;
        bh=zUwbC1w2zhbHABY8M4rwoXqvkrgONGKbYDP+0nH1LKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m7Y4IkSBJvoIz4bSnW12QveE+P6tlNbDR1IFQtgr81EM1a1PcR/eGObGnj0VuDiZz
         Gz9HWNo+Y0ZQ7TKpDW249sSAyru9uuN+vbgfbil/cIi595VVnmfH83AxY4MAAk3iU/
         jsUTSS6Djaf5bpwigYhH5v1qHMO3RwY7toYxhHMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Swapna Manupati <swapna.manupati@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Srinivas Neeli <srinivas.neeli@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.14 24/71] gpio: zynq: Fix for bug in zynq_gpio_restore_context API
Date:   Fri, 17 Jan 2020 00:18:22 +0100
Message-Id: <20200116231712.900067453@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Swapna Manupati <swapna.manupati@xilinx.com>

commit 36f2e7207f21a83ca0054116191f119ac64583ab upstream.

This patch writes the inverse value of Interrupt Mask Status
register into the Interrupt Enable register in
zynq_gpio_restore_context API to fix the bug.

Fixes: e11de4de28c0 ("gpio: zynq: Add support for suspend resume")
Signed-off-by: Swapna Manupati <swapna.manupati@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
Link: https://lore.kernel.org/r/1577362338-28744-2-git-send-email-srinivas.neeli@xilinx.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-zynq.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpio/gpio-zynq.c
+++ b/drivers/gpio/gpio-zynq.c
@@ -639,6 +639,8 @@ static void zynq_gpio_restore_context(st
 	unsigned int bank_num;
 
 	for (bank_num = 0; bank_num < gpio->p_data->max_bank; bank_num++) {
+		writel_relaxed(ZYNQ_GPIO_IXR_DISABLE_ALL, gpio->base_addr +
+				ZYNQ_GPIO_INTDIS_OFFSET(bank_num));
 		writel_relaxed(gpio->context.datalsw[bank_num],
 			       gpio->base_addr +
 			       ZYNQ_GPIO_DATA_LSW_OFFSET(bank_num));
@@ -648,9 +650,6 @@ static void zynq_gpio_restore_context(st
 		writel_relaxed(gpio->context.dirm[bank_num],
 			       gpio->base_addr +
 			       ZYNQ_GPIO_DIRM_OFFSET(bank_num));
-		writel_relaxed(gpio->context.int_en[bank_num],
-			       gpio->base_addr +
-			       ZYNQ_GPIO_INTEN_OFFSET(bank_num));
 		writel_relaxed(gpio->context.int_type[bank_num],
 			       gpio->base_addr +
 			       ZYNQ_GPIO_INTTYPE_OFFSET(bank_num));
@@ -660,6 +659,9 @@ static void zynq_gpio_restore_context(st
 		writel_relaxed(gpio->context.int_any[bank_num],
 			       gpio->base_addr +
 			       ZYNQ_GPIO_INTANY_OFFSET(bank_num));
+		writel_relaxed(~(gpio->context.int_en[bank_num]),
+			       gpio->base_addr +
+			       ZYNQ_GPIO_INTEN_OFFSET(bank_num));
 	}
 }
 


