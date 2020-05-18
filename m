Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A3F1D8559
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732131AbgERSST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:18:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731564AbgERRz6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:55:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1494320715;
        Mon, 18 May 2020 17:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824557;
        bh=6qEfNNkLVo3e/tdOgZTRkyRE14rmewna/2ALEwdJ98Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oGsBA8fUVRPan8J7Sf0Zke3hGzgNOQhXnkJ+2WfqO2m2i//ae8z4BjUOsVpwnznSq
         rWVBhqai/yB++vE7sbNvVSDZ9AGTUdaldjFe7wqyTmdRbBHM50jjmXRDHd8wqY6ge9
         TQ4zztMqux+XchECha4qUdALaT53uzZB4BxC0REE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Grace Kao <grace.kao@intel.com>,
        Brian Norris <briannorris@chromium.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/147] pinctrl: cherryview: Add missing spinlock usage in chv_gpio_irq_handler
Date:   Mon, 18 May 2020 19:36:22 +0200
Message-Id: <20200518173521.334712282@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grace Kao <grace.kao@intel.com>

[ Upstream commit 69388e15f5078c961b9e5319e22baea4c57deff1 ]

According to Braswell NDA Specification Update (#557593),
concurrent read accesses may result in returning 0xffffffff and write
instructions may be dropped. We have an established format for the
commit references, i.e.
cdca06e4e859 ("pinctrl: baytrail: Add missing spinlock usage in
byt_gpio_irq_handler")

Fixes: 0bd50d719b00 ("pinctrl: cherryview: prevent concurrent access to GPIO controllers")
Signed-off-by: Grace Kao <grace.kao@intel.com>
Reported-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-cherryview.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pinctrl/intel/pinctrl-cherryview.c b/drivers/pinctrl/intel/pinctrl-cherryview.c
index 2c419fa5d1c1b..8f06445a8e39c 100644
--- a/drivers/pinctrl/intel/pinctrl-cherryview.c
+++ b/drivers/pinctrl/intel/pinctrl-cherryview.c
@@ -1474,11 +1474,15 @@ static void chv_gpio_irq_handler(struct irq_desc *desc)
 	struct chv_pinctrl *pctrl = gpiochip_get_data(gc);
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 	unsigned long pending;
+	unsigned long flags;
 	u32 intr_line;
 
 	chained_irq_enter(chip, desc);
 
+	raw_spin_lock_irqsave(&chv_lock, flags);
 	pending = readl(pctrl->regs + CHV_INTSTAT);
+	raw_spin_unlock_irqrestore(&chv_lock, flags);
+
 	for_each_set_bit(intr_line, &pending, pctrl->community->nirqs) {
 		unsigned irq, offset;
 
-- 
2.20.1



