Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1010147AE38
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238718AbhLTO7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:59:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35496 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238231AbhLTO5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:57:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53349B80EE5;
        Mon, 20 Dec 2021 14:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA79C36AE7;
        Mon, 20 Dec 2021 14:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012223;
        bh=CuuKSRg/JYkZd33NoWaZeo3AFR/qBEdycMddkGm/h+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=geMzUFAPTJVv6ereNR9Aw60/RWl37ZgdvbOuGVYRFydaDPcEx7FXnWAvMTQvQsBvs
         mgq2AVuXHqNIC1wbJSvu72MlKH5wJhWVNWeE623w3394bnWvr1sZb7ZdOUFApj6tBw
         uEKP1MLXKnbbb0G/SZRCZZpWI12LbhYxFBPK/vZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 5.15 124/177] usb: cdnsp: Fix incorrect calling of cdnsp_died function
Date:   Mon, 20 Dec 2021 15:34:34 +0100
Message-Id: <20211220143044.252292056@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

commit 16f00d969afe60e233c1a91af7ac840df60d3536 upstream.

Patch restrict calling of cdnsp_died function during removing modules
or software disconnect.
This function was called because after transition controller to HALT
state the driver starts handling the deferred interrupt.
In this case such interrupt can be simple ignored.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
cc: <stable@vger.kernel.org>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20211210112945.660-1-pawell@gli-login.cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-ring.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -1525,7 +1525,14 @@ irqreturn_t cdnsp_thread_irq_handler(int
 	spin_lock_irqsave(&pdev->lock, flags);
 
 	if (pdev->cdnsp_state & (CDNSP_STATE_HALTED | CDNSP_STATE_DYING)) {
-		cdnsp_died(pdev);
+		/*
+		 * While removing or stopping driver there may still be deferred
+		 * not handled interrupt which should not be treated as error.
+		 * Driver should simply ignore it.
+		 */
+		if (pdev->gadget_driver)
+			cdnsp_died(pdev);
+
 		spin_unlock_irqrestore(&pdev->lock, flags);
 		return IRQ_HANDLED;
 	}


