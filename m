Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F49370CA1
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbhEBOGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233386AbhEBOGV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:06:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49F76613CF;
        Sun,  2 May 2021 14:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964326;
        bh=w9591fGVC5JVawAIStz3BWOnN9vNdV3PcZforyawNXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DG5+7Q+lO1isPIYElFKdxemtpQZfT/KuPn0th6p58QX5fNgIM1ZR5kFYdWAERT0mO
         gBshbXBOePFaGYyX50L4A4GGBPvDm3z405wcyGcEwcdKASuojMCcCkkcUnENQKIuhY
         uxGISaTtooSgCEgInesk9WwiyxyhvS5J6rPG1g9GZlLcNRApOknqKZB6KDdMXt0e2A
         FZGbBK+O4ZK0ZfHWZbWosP5Ft7ffM4uejGGxVP6h9Cp9LdRo5bs454zUV9L+wOTwTg
         UOp/nicKpuJdk9K6AoV501pwjFAFz6gCGuUfyr652Z1ch1pcc4YFQHInsXL0DFuYBO
         EASFy+JpT0K+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wesley Cheng <wcheng@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/21] usb: dwc3: gadget: Ignore EP queue requests during bus reset
Date:   Sun,  2 May 2021 10:05:02 -0400
Message-Id: <20210502140517.2719912-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140517.2719912-1-sashal@kernel.org>
References: <20210502140517.2719912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

