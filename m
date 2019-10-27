Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEAAE6851
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732127AbfJ0VWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:22:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732124AbfJ0VWW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:22:22 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A708208C0;
        Sun, 27 Oct 2019 21:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211340;
        bh=JdEx2XorxiF5emEMUubrlBRegU0owdRivo+wfot7gtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SREKlXSR8ei/2ayHuEl93qCcXIAdS9018bh/ucM9VQBgpdv+QRcTczQReTwQjtrpM
         QFYfpP4h/ACUHfylWsfiOgQP6mDkANfRJV0Eg2lSX+9/EQ/1AZe1c94HrW4KCvaGTj
         7xqp4D57QUo5HnFt0fAqebtKGbumlXHTV0Tdxcr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Green <evgreen@chromium.org>,
        Andrew Duggan <aduggan@synaptics.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.3 116/197] Input: synaptics-rmi4 - avoid processing unknown IRQs
Date:   Sun, 27 Oct 2019 22:00:34 +0100
Message-Id: <20191027203358.000247480@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
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
@@ -146,7 +146,7 @@ static int rmi_process_interrupt_request
 	}
 
 	mutex_lock(&data->irq_mutex);
-	bitmap_and(data->irq_status, data->irq_status, data->current_irq_mask,
+	bitmap_and(data->irq_status, data->irq_status, data->fn_irq_bits,
 	       data->irq_count);
 	/*
 	 * At this point, irq_status has all bits that are set in the
@@ -385,6 +385,8 @@ static int rmi_driver_set_irq_bits(struc
 	bitmap_copy(data->current_irq_mask, data->new_irq_mask,
 		    data->num_of_irq_regs);
 
+	bitmap_or(data->fn_irq_bits, data->fn_irq_bits, mask, data->irq_count);
+
 error_unlock:
 	mutex_unlock(&data->irq_mutex);
 	return error;
@@ -398,6 +400,8 @@ static int rmi_driver_clear_irq_bits(str
 	struct device *dev = &rmi_dev->dev;
 
 	mutex_lock(&data->irq_mutex);
+	bitmap_andnot(data->fn_irq_bits,
+		      data->fn_irq_bits, mask, data->irq_count);
 	bitmap_andnot(data->new_irq_mask,
 		  data->current_irq_mask, mask, data->irq_count);
 


