Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2918C101755
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbfKSFpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:45:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:40936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730299AbfKSFpS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:45:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDB9B2071B;
        Tue, 19 Nov 2019 05:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142317;
        bh=W9hljRTPfD9xTRTujr2m9ZfS2Reoa3BMcfnnVV8pCEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2k4jNrrke0khBjaiw102jSXWBIsWjs8mOiDc2ki0OzN92LJaxVH/yiv7GY8ZjV7u
         GEleq4UlejRZmeNFGRJ62hldnHg+m9aT2JjbNNE2xN8pQxy7fWwsqMkv0T2pgeebdB
         kF24Y1eggr13ux0ci7pVfRj8TgZ6Ct/3uDHiDrhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Green <evgreen@chromium.org>
Subject: [PATCH 4.14 005/239] Revert "Input: synaptics-rmi4 - avoid processing unknown IRQs"
Date:   Tue, 19 Nov 2019 06:16:45 +0100
Message-Id: <20191119051257.800659852@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Green <evgreen@chromium.org>

This reverts commit 7b9f7a928255a232012be55cb95db30e963b83a7.

That change should have had a fixes tag for
commit 24d28e4f1271 ("Input: synaptics-rmi4 - convert irq distribution to
irq_domain"). The conversion to irq_domain introduced the issue being
fixed by this commit.

In older kernels the bitmap IRQ accounting is done differently, and
it doesn't suffer from the same issue of calling handle_nested_irq(0).
Keeping this commit on kernels 4.14 and older causes problems with
touchpads due to the different semantics of the IRQ bitmasks.

Signed-off-by: Evan Green <evgreen@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/rmi4/rmi_driver.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -165,7 +165,7 @@ static int rmi_process_interrupt_request
 	}
 
 	mutex_lock(&data->irq_mutex);
-	bitmap_and(data->irq_status, data->irq_status, data->fn_irq_bits,
+	bitmap_and(data->irq_status, data->irq_status, data->current_irq_mask,
 	       data->irq_count);
 	/*
 	 * At this point, irq_status has all bits that are set in the
@@ -412,8 +412,6 @@ static int rmi_driver_set_irq_bits(struc
 	bitmap_copy(data->current_irq_mask, data->new_irq_mask,
 		    data->num_of_irq_regs);
 
-	bitmap_or(data->fn_irq_bits, data->fn_irq_bits, mask, data->irq_count);
-
 error_unlock:
 	mutex_unlock(&data->irq_mutex);
 	return error;
@@ -427,8 +425,6 @@ static int rmi_driver_clear_irq_bits(str
 	struct device *dev = &rmi_dev->dev;
 
 	mutex_lock(&data->irq_mutex);
-	bitmap_andnot(data->fn_irq_bits,
-		      data->fn_irq_bits, mask, data->irq_count);
 	bitmap_andnot(data->new_irq_mask,
 		  data->current_irq_mask, mask, data->irq_count);
 


