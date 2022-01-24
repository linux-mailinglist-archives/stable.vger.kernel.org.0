Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B488D499BF9
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454784AbiAXV6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1575078AbiAXVvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:51:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C3FC08B4DD;
        Mon, 24 Jan 2022 12:33:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B272D6153C;
        Mon, 24 Jan 2022 20:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A48CC340E5;
        Mon, 24 Jan 2022 20:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056426;
        bh=K/eWSfljgcMu7/mLCM+m/uhl8K632G9yFcOz1ichPVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=09WhtZQakHh0ADM6I/tuhm2xdLPv0bbgffEb4b+2Mw79pz/psj9p/HarKM2hfRb4s
         y0fD2f/XZDe+O9P/6GWoMxZsxSx+eT3JJ1euHsbORYcKwxLMFT4S7XwfZMqtKZj+/L
         Dw0+7qitA/eA0nnqIRoALhNxoUuswMDzhf5WA2lo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TCS Robot <tcs_robot@tencent.com>,
        Haimin Zhang <tcs.kernel@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 481/846] USB: ehci_brcm_hub_control: Improve port index sanitizing
Date:   Mon, 24 Jan 2022 19:39:58 +0100
Message-Id: <20220124184117.607858250@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haimin Zhang <tcs.kernel@gmail.com>

[ Upstream commit 9933698f6119886c110750e67c10ac66f12b730f ]

Due to (wIndex & 0xff) - 1 can get an integer greater than 15, this
can cause array index to be out of bounds since the size of array
port_status is 15. This change prevents a possible out-of-bounds
pointer computation by forcing the use of a valid port number.

Reported-by: TCS Robot <tcs_robot@tencent.com>
Signed-off-by: Haimin Zhang <tcs.kernel@gmail.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20211113165320.GA59686@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ehci-brcm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-brcm.c b/drivers/usb/host/ehci-brcm.c
index d3626bfa966b4..6a0f64c9e5e88 100644
--- a/drivers/usb/host/ehci-brcm.c
+++ b/drivers/usb/host/ehci-brcm.c
@@ -62,8 +62,12 @@ static int ehci_brcm_hub_control(
 	u32 __iomem	*status_reg;
 	unsigned long flags;
 	int retval, irq_disabled = 0;
+	u32 temp;
 
-	status_reg = &ehci->regs->port_status[(wIndex & 0xff) - 1];
+	temp = (wIndex & 0xff) - 1;
+	if (temp >= HCS_N_PORTS_MAX)	/* Avoid index-out-of-bounds warning */
+		temp = 0;
+	status_reg = &ehci->regs->port_status[temp];
 
 	/*
 	 * RESUME is cleared when GetPortStatus() is called 20ms after start
-- 
2.34.1



