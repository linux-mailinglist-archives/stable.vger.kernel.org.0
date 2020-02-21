Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32F741676B3
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731358AbgBUIEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:04:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:37610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731649AbgBUIEa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:04:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 496B72465D;
        Fri, 21 Feb 2020 08:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272269;
        bh=a/JbiaU6A10GtmsEI/rx+V/8XXumfKNN7zGs8yipPCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DsQdeY14O8vsI9hcoTs95ziCYhDRrwb2qyfDnmlxTuIDyz0y5jawgfFz6TtmI2JYo
         cBqfoT/uzY0cxZrRF7hIOHiBrlJEpiS2F4jPY0vScdPcXs+HDfWzpVxMz1IFCWFj47
         2liec6uh+P32coxYZ/qdDGtfDE4hTOuMzSFI6Epc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/344] brcmfmac: sdio: Fix OOB interrupt initialization on brcm43362
Date:   Fri, 21 Feb 2020 08:37:59 +0100
Message-Id: <20200221072356.237166482@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

[ Upstream commit 8c8e60fb86a90a30721bbd797f58f96b3980dcc1 ]

Commit 262f2b53f679 ("brcmfmac: call brcmf_attach() just before calling
brcmf_bus_started()") changed the initialization order of the brcmfmac
SDIO driver. Unfortunately since brcmf_sdiod_intr_register() is now
called before the sdiodev->bus_if initialization, it reads the wrong
chip ID and fails to initialize the GPIO on brcm43362. Thus the chip
cannot send interrupts and fails to probe:

[   12.517023] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
[   12.531214] ieee80211 phy0: brcmf_bus_started: failed: -110
[   12.536976] ieee80211 phy0: brcmf_attach: dongle is not responding: err=-110
[   12.566467] brcmfmac: brcmf_sdio_firmware_callback: brcmf_attach failed

Initialize the bus interface earlier to ensure that
brcmf_sdiod_intr_register() properly sets up the OOB interrupt.

BugLink: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=908438
Fixes: 262f2b53f679 ("brcmfmac: call brcmf_attach() just before calling brcmf_bus_started()")
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/sdio.c  | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 1dea0178832ea..a935993a3c514 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4226,6 +4226,12 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	}
 
 	if (err == 0) {
+		/* Assign bus interface call back */
+		sdiod->bus_if->dev = sdiod->dev;
+		sdiod->bus_if->ops = &brcmf_sdio_bus_ops;
+		sdiod->bus_if->chip = bus->ci->chip;
+		sdiod->bus_if->chiprev = bus->ci->chiprev;
+
 		/* Allow full data communication using DPC from now on. */
 		brcmf_sdiod_change_state(bus->sdiodev, BRCMF_SDIOD_DATA);
 
@@ -4242,12 +4248,6 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 
 	sdio_release_host(sdiod->func1);
 
-	/* Assign bus interface call back */
-	sdiod->bus_if->dev = sdiod->dev;
-	sdiod->bus_if->ops = &brcmf_sdio_bus_ops;
-	sdiod->bus_if->chip = bus->ci->chip;
-	sdiod->bus_if->chiprev = bus->ci->chiprev;
-
 	err = brcmf_alloc(sdiod->dev, sdiod->settings);
 	if (err) {
 		brcmf_err("brcmf_alloc failed\n");
-- 
2.20.1



