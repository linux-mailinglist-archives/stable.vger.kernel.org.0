Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B7B38A22B
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbhETJir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:38:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232177AbhETJgu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:36:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B720D6140E;
        Thu, 20 May 2021 09:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503011;
        bh=w9591fGVC5JVawAIStz3BWOnN9vNdV3PcZforyawNXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q8MzQkPvDtaMKn3j6beOc+JKy0qNMqRU7UE6NWadjRtw6phsNfeWzqPKyRqHZQJux
         rXUKOakvYUC4dy60ycJjAPVojRug8Pg2jhRMWK6+PR0lmReZlhlE5ebL3xJcVqrVbl
         Gg+VAH467UwyGULFEiX7tAaA0I2A+b/j3GiW0VAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wesley Cheng <wcheng@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 028/425] usb: dwc3: gadget: Ignore EP queue requests during bus reset
Date:   Thu, 20 May 2021 11:16:37 +0200
Message-Id: <20210520092132.320300884@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
index a0806dca3de9..f28eb541fad3 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2717,6 +2717,15 @@ static void dwc3_gadget_reset_interrupt(struct dwc3 *dwc)
 
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



