Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A817D370BDD
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbhEBOEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:04:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232335AbhEBOEd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:04:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAE36613AC;
        Sun,  2 May 2021 14:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964221;
        bh=tz5RB0z7552h7RSYAP5Z7CuPrIQcRa54T/DM7im2pHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A+OTuUPhJ6wDNy7WWcH59L6hYxSP4ehyZOeeu6aM/FoQOigfUvD0L7ONStXlB1IS8
         7yNHXFnyftXo2z8SGr2r52NlODZlB9Zk6zcNBGInpwrdOf2dnEkqPF5mzkwEouHIi5
         7mLwVki1CMiqr2vZk8jUt4O6oTXmdMMcnlzlQ9s/u2wMmEOMaUvsVVgDO0VM5M+gPd
         Q2P8rWftS5A0z/KVkVVbVdYTEM7fPf3M54Xq2JGgv6DpxgqvVAeiu5P/HxYsPTtPsF
         fiAJ3r6iss4zfXBt44usYfeW+YiPdMmWRNPAfpOoPgYEoqeEkoWJ440nJKp2JD7//l
         AGQrJiDEqe+CQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wesley Cheng <wcheng@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 19/79] usb: dwc3: gadget: Ignore EP queue requests during bus reset
Date:   Sun,  2 May 2021 10:02:16 -0400
Message-Id: <20210502140316.2718705-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140316.2718705-1-sashal@kernel.org>
References: <20210502140316.2718705-1-sashal@kernel.org>
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
index 04950ac0704b..73f4ce63f4b2 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3319,6 +3319,15 @@ static void dwc3_gadget_reset_interrupt(struct dwc3 *dwc)
 {
 	u32			reg;
 
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

