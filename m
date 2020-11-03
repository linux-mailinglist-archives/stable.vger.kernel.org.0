Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739F62A5949
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbgKCUlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:41:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:53180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730323AbgKCUlX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:41:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA1602224E;
        Tue,  3 Nov 2020 20:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436082;
        bh=ESHlznezKFsYurk1Fpv9iSGrP+kA1qEmFSqEeIypMC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=okBzJM9W9315/Bh5wpV0y7LOMJGiF9eIa9oWXialbZczCTdz7bTF+J07CaJ4oliS9
         9LOtTLIrlpEPTmjLuoF7yDZNab5uEIefoEuZGWCggzncCaFuESOsqzER8BkD/oSo+a
         Uu9F7XbgZYxWbOH9qssxp56rovd9WwxEpBNrHz88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 094/391] brcmfmac: increase F2 watermark for BCM4329
Date:   Tue,  3 Nov 2020 21:32:25 +0100
Message-Id: <20201103203353.253418593@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 317da69d10b0247c4042354eb90c75b81620ce9d ]

This patch fixes SDHCI CRC errors during of RX throughput testing on
BCM4329 chip if SDIO BUS is clocked above 25MHz. In particular the
checksum problem is observed on NVIDIA Tegra20 SoCs. The good watermark
value is borrowed from downstream BCMDHD driver and it's matching to the
value that is already used for the BCM4339 chip, hence let's re-use it
for BCM4329.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200830191439.10017-2-digetx@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 3c07d1bbe1c6e..ac3ee93a23780 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4278,6 +4278,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 			brcmf_sdiod_writeb(sdiod, SBSDIO_FUNC1_MESBUSYCTRL,
 					   CY_43012_MESBUSYCTRL, &err);
 			break;
+		case SDIO_DEVICE_ID_BROADCOM_4329:
 		case SDIO_DEVICE_ID_BROADCOM_4339:
 			brcmf_dbg(INFO, "set F2 watermark to 0x%x*4 bytes for 4339\n",
 				  CY_4339_F2_WATERMARK);
-- 
2.27.0



