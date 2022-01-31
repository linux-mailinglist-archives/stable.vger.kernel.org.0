Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35EB54A434E
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350010AbiAaLUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:20:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48140 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358648AbiAaLOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:14:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8C3461170;
        Mon, 31 Jan 2022 11:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC233C340E8;
        Mon, 31 Jan 2022 11:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627682;
        bh=rYGaHByqYJDUZ44c0fnl0gDVIASjO25cAfhwqHt8L6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KMqK607Lowi+btwr3Unmti4++uvGXNCVu9NK0uQ8dqZyTVWMtxMV+tkjUyyqY/ub5
         33+bqF8uxagN1fPiq+cFRlqDPcWfebai6mPHOJr7usDs+v2fuN8gPCWKGNH97U5qSX
         enUn5e4WtPEGlXO2pBq8gLboaZJd1IQCOvYHWHFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sander Vanheule <sander@svanheule.net>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/171] irqchip/realtek-rtl: Map control data to virq
Date:   Mon, 31 Jan 2022 11:57:07 +0100
Message-Id: <20220131105235.495433291@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sander Vanheule <sander@svanheule.net>

commit 291e79c7e2eb6fdc016453597b78482e06199d0f upstream.

The driver assigned the irqchip and irq handler to the hardware irq,
instead of the virq. This is incorrect, and only worked because these
irq numbers happened to be the same on the devices used for testing the
original driver.

Fixes: 9f3a0f34b84a ("irqchip: Add support for Realtek RTL838x/RTL839x interrupt controller")
Signed-off-by: Sander Vanheule <sander@svanheule.net>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/4b4936606480265db47df152f00bc2ed46340599.1641739718.git.sander@svanheule.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-realtek-rtl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/irqchip/irq-realtek-rtl.c
+++ b/drivers/irqchip/irq-realtek-rtl.c
@@ -62,7 +62,7 @@ static struct irq_chip realtek_ictl_irq
 
 static int intc_map(struct irq_domain *d, unsigned int irq, irq_hw_number_t hw)
 {
-	irq_set_chip_and_handler(hw, &realtek_ictl_irq, handle_level_irq);
+	irq_set_chip_and_handler(irq, &realtek_ictl_irq, handle_level_irq);
 
 	return 0;
 }


