Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9962B3E81F2
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbhHJSED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:04:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231851AbhHJSCG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 14:02:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABC8361401;
        Tue, 10 Aug 2021 17:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617655;
        bh=zILbFbF7vvh0NgWjAhiAvYXcYKWEkYI+SFBkisgX2K0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SlQ/ioJT6MNOWm+6FGfBfAtl7R68xVA8luB1CRIjhTAMsyb24x77bGHkwXAaQJHpl
         Rp8Tbk58i6qpi1IlXeLLHnKJjUHtjvXq14/WxLUEYtdeN5dtQiTuYoa4ydJF4Au+He
         tgtPzSWgUR5+bSFkqi2eKPt3o4F/G/kFso3/QVYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pawel Laszczak <pawell@cadence.com>,
        Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.13 154/175] usb: cdnsp: Fix incorrect supported maximum speed
Date:   Tue, 10 Aug 2021 19:31:02 +0200
Message-Id: <20210810173006.049967476@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

commit aa82f94e869edd72f4fadb08c6ffca8927e4934e upstream.

Driver had hardcoded in initialization maximum supported speed
to USB_SPEED_SUPER_PLUS but it should consider the speed
returned from usb_get_maximum_speed function.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20210625102502.26336-1-pawell@gli-login.cadence.com
Signed-off-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-gadget.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -1881,7 +1881,7 @@ static int __cdnsp_gadget_init(struct cd
 	pdev->gadget.name = "cdnsp-gadget";
 	pdev->gadget.speed = USB_SPEED_UNKNOWN;
 	pdev->gadget.sg_supported = 1;
-	pdev->gadget.max_speed = USB_SPEED_SUPER_PLUS;
+	pdev->gadget.max_speed = max_speed;
 	pdev->gadget.lpm_capable = 1;
 
 	pdev->setup_buf = kzalloc(CDNSP_EP0_SETUP_SIZE, GFP_KERNEL);


