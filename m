Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F7847AE4B
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239129AbhLTPAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:00:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46056 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238318AbhLTO5K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:57:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D6AC6118E;
        Mon, 20 Dec 2021 14:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41316C36AE7;
        Mon, 20 Dec 2021 14:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012228;
        bh=Y/eRC54bCmGaQB6DaEvBt2IaSPSsdo4LFQ0qmDETO0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b6/sQkxK5IgQXz2Pmc+eoqw9IcMl7ar5EvdjFJ+yp0qXH4AUW9rIb14aySHPbbe6l
         LnZpNA8KTpBIBgJQslLZynshiXoitpxkIs4aSSnd6yORuE2e750WaRO0LUb1ufndDr
         SU4aaz1R2tzUFsniQPIuvIsMPsYJzS0+eko9ZnZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Ken (Jian) He" <jianhe@ambarella.com>,
        Pawel Laszczak <pawell@cadence.com>,
        Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.15 126/177] usb: cdnsp: Fix lack of spin_lock_irqsave/spin_lock_restore
Date:   Mon, 20 Dec 2021 15:34:36 +0100
Message-Id: <20211220143044.320969400@linuxfoundation.org>
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

commit 4c4e162d9cf38528c4f13df09d5755cbc06f6c77 upstream.

Patch puts content of cdnsp_gadget_pullup function inside
spin_lock_irqsave and spin_lock_restore section.
This construction is required here to keep the data consistency,
otherwise some data can be changed e.g. from interrupt context.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Reported-by: Ken (Jian) He <jianhe@ambarella.com>
cc: <stable@vger.kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20211214045527.26823-1-pawell@gli-login.cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-gadget.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -1541,15 +1541,27 @@ static int cdnsp_gadget_pullup(struct us
 {
 	struct cdnsp_device *pdev = gadget_to_cdnsp(gadget);
 	struct cdns *cdns = dev_get_drvdata(pdev->dev);
+	unsigned long flags;
 
 	trace_cdnsp_pullup(is_on);
 
+	/*
+	 * Disable events handling while controller is being
+	 * enabled/disabled.
+	 */
+	disable_irq(cdns->dev_irq);
+	spin_lock_irqsave(&pdev->lock, flags);
+
 	if (!is_on) {
 		cdnsp_reset_device(pdev);
 		cdns_clear_vbus(cdns);
 	} else {
 		cdns_set_vbus(cdns);
 	}
+
+	spin_unlock_irqrestore(&pdev->lock, flags);
+	enable_irq(cdns->dev_irq);
+
 	return 0;
 }
 


