Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520D12B626D
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730886AbgKQN2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:28:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:36634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731334AbgKQN22 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:28:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FCE620781;
        Tue, 17 Nov 2020 13:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619708;
        bh=VtZqPqHdulf/Dbcc2C0lldB/XlyVF4+MLKNHmpJAyE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IAy+sdCotpIhCZI4HKoP9rGZH6/rWM6hRMRt+KxsEFoih1WBt4NbHbY1E7A9Y6bZ+
         6I88+GsyXuWmWDvDhEaGfp5fVsllw4HndWDTcagoKnV9iNQuK40NfGG3wFGxzvEHfb
         DqIG433uWBokYqBOGlYJfz291e0mC7yrpuYrgK14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnaud de Turckheim <quarium@gmail.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.4 129/151] gpio: pcie-idio-24: Fix IRQ Enable Register value
Date:   Tue, 17 Nov 2020 14:05:59 +0100
Message-Id: <20201117122127.700920114@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaud de Turckheim <quarium@gmail.com>

commit 23a7fdc06ebcc334fa667f0550676b035510b70b upstream.

This fixes the COS Enable Register value for enabling/disabling the
corresponding IRQs bank.

Fixes: 585562046628 ("gpio: Add GPIO support for the ACCES PCIe-IDIO-24 family")
Cc: stable@vger.kernel.org
Signed-off-by: Arnaud de Turckheim <quarium@gmail.com>
Reviewed-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-pcie-idio-24.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpio/gpio-pcie-idio-24.c
+++ b/drivers/gpio/gpio-pcie-idio-24.c
@@ -360,13 +360,13 @@ static void idio_24_irq_mask(struct irq_
 	unsigned long flags;
 	const unsigned long bit_offset = irqd_to_hwirq(data) - 24;
 	unsigned char new_irq_mask;
-	const unsigned long bank_offset = bit_offset/8 * 8;
+	const unsigned long bank_offset = bit_offset / 8;
 	unsigned char cos_enable_state;
 
 	raw_spin_lock_irqsave(&idio24gpio->lock, flags);
 
 	idio24gpio->irq_mask &= ~BIT(bit_offset);
-	new_irq_mask = idio24gpio->irq_mask >> bank_offset;
+	new_irq_mask = idio24gpio->irq_mask >> bank_offset * 8;
 
 	if (!new_irq_mask) {
 		cos_enable_state = ioread8(&idio24gpio->reg->cos_enable);
@@ -389,12 +389,12 @@ static void idio_24_irq_unmask(struct ir
 	unsigned long flags;
 	unsigned char prev_irq_mask;
 	const unsigned long bit_offset = irqd_to_hwirq(data) - 24;
-	const unsigned long bank_offset = bit_offset/8 * 8;
+	const unsigned long bank_offset = bit_offset / 8;
 	unsigned char cos_enable_state;
 
 	raw_spin_lock_irqsave(&idio24gpio->lock, flags);
 
-	prev_irq_mask = idio24gpio->irq_mask >> bank_offset;
+	prev_irq_mask = idio24gpio->irq_mask >> bank_offset * 8;
 	idio24gpio->irq_mask |= BIT(bit_offset);
 
 	if (!prev_irq_mask) {


