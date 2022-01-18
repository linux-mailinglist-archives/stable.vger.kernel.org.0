Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4604917B9
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347756AbiARCmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:42:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344155AbiARCf7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:35:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315A9C061252;
        Mon, 17 Jan 2022 18:33:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 831D861286;
        Tue, 18 Jan 2022 02:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0458C36AE3;
        Tue, 18 Jan 2022 02:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473200;
        bh=K/eWSfljgcMu7/mLCM+m/uhl8K632G9yFcOz1ichPVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7fipkdQsPLElndn3GhViAXJPNV6UXoGrZWCwvLFCP2abS885WRNLf/y/B0co++S3
         4ChJmivh+5Roamkuakz4pebPc0kfO1s6NeJEYBQTXFr8fKLahX/+uWH9jEMjpglOoS
         178GUTJlE02hrXVIuHdfUl0EjGKn1lMn+mu4XF6WSU/l3QuJtW2skrEvH5b7CMnwBm
         JfFa4cL2Rf3viuqs24Jn2Qv4kZlBFRHqt8304B9IXG4KwJ+Syo/qlOAAO1EIeKsr68
         53+Sl+MGnUlmTYUuXuQr+ocpn1eM8uzUQwRrOOPvBdbNQF5a1oiDPOS/3Q72C1KelQ
         iqkJFpRiezznw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haimin Zhang <tcs.kernel@gmail.com>,
        TCS Robot <tcs_robot@tencent.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, alcooperx@gmail.com,
        linux-usb@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Subject: [PATCH AUTOSEL 5.15 024/188] USB: ehci_brcm_hub_control: Improve port index sanitizing
Date:   Mon, 17 Jan 2022 21:29:08 -0500
Message-Id: <20220118023152.1948105-24-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

