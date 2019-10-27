Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C763E68D1
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730533AbfJ0VO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:14:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730554AbfJ0VO4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:14:56 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 208C420B7C;
        Sun, 27 Oct 2019 21:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210895;
        bh=RMTPwH9mTVMahkesXUyfHYORn7X/vja4qlbJZCFtLN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FpcMRgSj2+OLlwojOOBpT/IOQFiH2/c2gjNZcZ2QtqtPEXOgxxyf1wIHdrPaC9dE/
         thevlXKvggxGAgBylpw0IRXY9kyDKYaEdWJjHMfDk3AnbSfXyL5xE8lwzAgxg58UNt
         ncOBQoCqvNP0WH3W+eC5YAD+Jhuo6nqH8CuiZoug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Green <evgreen@chromium.org>,
        Andrew Duggan <aduggan@synaptics.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.19 54/93] Input: synaptics-rmi4 - avoid processing unknown IRQs
Date:   Sun, 27 Oct 2019 22:01:06 +0100
Message-Id: <20191027203301.699819683@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Green <evgreen@chromium.org>

commit 363c53875aef8fce69d4a2d0873919ccc7d9e2ad upstream.

rmi_process_interrupt_requests() calls handle_nested_irq() for
each interrupt status bit it finds. If the irq domain mapping for
this bit had not yet been set up, then it ends up calling
handle_nested_irq(0), which causes a NULL pointer dereference.

There's already code that masks the irq_status bits coming out of the
hardware with current_irq_mask, presumably to avoid this situation.
However current_irq_mask seems to more reflect the actual mask set
in the hardware rather than the IRQs software has set up and registered
for. For example, in rmi_driver_reset_handler(), the current_irq_mask
is initialized based on what is read from the hardware. If the reset
value of this mask enables IRQs that Linux has not set up yet, then
we end up in this situation.

There appears to be a third unused bitmask that used to serve this
purpose, fn_irq_bits. Use that bitmask instead of current_irq_mask
to avoid calling handle_nested_irq() on IRQs that have not yet been
set up.

Signed-off-by: Evan Green <evgreen@chromium.org>
Reviewed-by: Andrew Duggan <aduggan@synaptics.com>
Link: https://lore.kernel.org/r/20191008223657.163366-1-evgreen@chromium.org
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/rmi4/rmi_driver.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -149,7 +149,7 @@ static int rmi_process_interrupt_request
 	}
 
 	mutex_lock(&data->irq_mutex);
-	bitmap_and(data->irq_status, data->irq_status, data->current_irq_mask,
+	bitmap_and(data->irq_status, data->irq_status, data->fn_irq_bits,
 	       data->irq_count);
 	/*
 	 * At this point, irq_status has all bits that are set in the
@@ -388,6 +388,8 @@ static int rmi_driver_set_irq_bits(struc
 	bitmap_copy(data->current_irq_mask, data->new_irq_mask,
 		    data->num_of_irq_regs);
 
+	bitmap_or(data->fn_irq_bits, data->fn_irq_bits, mask, data->irq_count);
+
 error_unlock:
 	mutex_unlock(&data->irq_mutex);
 	return error;
@@ -401,6 +403,8 @@ static int rmi_driver_clear_irq_bits(str
 	struct device *dev = &rmi_dev->dev;
 
 	mutex_lock(&data->irq_mutex);
+	bitmap_andnot(data->fn_irq_bits,
+		      data->fn_irq_bits, mask, data->irq_count);
 	bitmap_andnot(data->new_irq_mask,
 		  data->current_irq_mask, mask, data->irq_count);
 


