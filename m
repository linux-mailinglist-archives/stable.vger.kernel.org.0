Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FB038A823
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238163AbhETKql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:46:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238229AbhETKok (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:44:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 263C861CA2;
        Thu, 20 May 2021 09:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504648;
        bh=oqj5jMs5YhLaha4osWK8+xN6xe3zOcpuQVD8PVpNb/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gosKLHr233r76J+pFiuv1G0EZAtqoAgOGcrRfGE+4gV1CKOgHtLLsjvw8Gde263yY
         Q97OT1fd6tb63a48KdZFTBJwKUi5qi+RRGd6pe7LD89+Ouc+jltv10HumqPXmMEPKF
         BfFdt5ouRdkcP3tjBh+GIoyB7Zf4sQAV6pj1+jhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wesley Cheng <wcheng@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 018/240] usb: dwc3: gadget: Ignore EP queue requests during bus reset
Date:   Thu, 20 May 2021 11:20:10 +0200
Message-Id: <20210520092109.237915739@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <wcheng@codeaurora.org>

[ Upstream commit 71ca43f30df9c642970f9dc9b2d6f463f4967e7b ]

The current dwc3_gadget_reset_interrupt() will stop any active
transfers, but only addresses blocking of EP queuing for while we are
coming from a disconnected scenario, i.e. after receiving the disconnect
event.  If the host decides to issue a bus reset on the device, the
connected parameter will still be set to true, allowing for EP queuing
to continue while we are disabling the functions.  To avoid this, set the
connected flag to false until the stop active transfers is complete.

Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Link: https://lore.kernel.org/r/1616146285-19149-3-git-send-email-wcheng@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index e0fb7b3723c5..cca51553e0fb 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2409,6 +2409,15 @@ static void dwc3_gadget_reset_interrupt(struct dwc3 *dwc)
 
 	dwc->connected = true;
 
+	/*
+	 * Ideally, dwc3_reset_gadget() would trigger the function
+	 * drivers to stop any active transfers through ep disable.
+	 * However, for functions which defer ep disable, such as mass
+	 * storage, we will need to rely on the call to stop active
+	 * transfers here, and avoid allowing of request queuing.
+	 */
+	dwc->connected = false;
+
 	/*
 	 * WORKAROUND: DWC3 revisions <1.88a have an issue which
 	 * would cause a missing Disconnect Event if there's a
-- 
2.30.2



