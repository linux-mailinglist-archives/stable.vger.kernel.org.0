Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6B64A4566
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350503AbiAaLk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377608AbiAaLgo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:36:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AFBC08C5FE;
        Mon, 31 Jan 2022 03:24:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A3C8B82A61;
        Mon, 31 Jan 2022 11:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD802C36AE3;
        Mon, 31 Jan 2022 11:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628297;
        bh=rYGaHByqYJDUZ44c0fnl0gDVIASjO25cAfhwqHt8L6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mfn1d0Bgjde62UjGJXEl2GIrVyVONiiv8TpwIva7Z+OgwLkX/RJIF26+Q7P4B4QJ6
         f5rd1ct8xhZd+40o0v4UJiYmNF812ByKyooy52Q3wTtjG6795CJLmJ5J6VDGfoNUXT
         76eOXVwVvmVz/LWJyxC6n0Qb+1yIhwlI0N/4rT38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sander Vanheule <sander@svanheule.net>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 187/200] irqchip/realtek-rtl: Map control data to virq
Date:   Mon, 31 Jan 2022 11:57:30 +0100
Message-Id: <20220131105239.828805478@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
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


