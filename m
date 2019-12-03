Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD278111CF8
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729510AbfLCWtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:49:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:39942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729532AbfLCWtF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:49:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0B3E20803;
        Tue,  3 Dec 2019 22:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413344;
        bh=i2TUQ1gesl9JwdNVYVse27uEquLrDG/YSkiLYku2988=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ush9cVmEfxP1XCCwaDM9HNHlcfmtToVNlTd/HucvtHrSxubc57Q1sst7r1etV3nXi
         mCPBd34hjXGWkIs2R+24rckunwiIeUI3r+rBRExp/dp+bKM7RI4Dc1jJnSZ2F+EpyV
         LALZMTHhdPWBpQCJzD2sN8rXbeejcbamM/GiMr2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Madhan Mohan R <madhanmohan.r@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 093/321] brcmfmac: set SDIO F1 MesBusyCtrl for CYW4373
Date:   Tue,  3 Dec 2019 23:32:39 +0100
Message-Id: <20191203223431.987493166@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madhan Mohan R <MadhanMohan.R@cypress.com>

[ Upstream commit 58e4bbea0c1d9b5ace11df968c5dc096ce052a73 ]

Along with F2 watermark (existing) configuration, F1 MesBusyCtrl
should be enabled & sdio device RX FIFO watermark should be
configured to avoid overflow errors.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Madhan Mohan R <madhanmohan.r@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 3 +++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h | 9 ++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index e487dd78cc024..abaed2fa2defd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4133,6 +4133,9 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 			devctl |= SBSDIO_DEVCTL_F2WM_ENAB;
 			brcmf_sdiod_writeb(sdiod, SBSDIO_DEVICE_CTL, devctl,
 					   &err);
+			brcmf_sdiod_writeb(sdiod, SBSDIO_FUNC1_MESBUSYCTRL,
+					   CY_4373_F2_WATERMARK |
+					   SBSDIO_MESBUSYCTRL_ENAB, &err);
 			break;
 		default:
 			brcmf_sdiod_writeb(sdiod, SBSDIO_WATERMARK,
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index 7faed831f07d5..34b031154da93 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -77,7 +77,7 @@
 #define SBSDIO_GPIO_OUT			0x10006
 /* gpio enable */
 #define SBSDIO_GPIO_EN			0x10007
-/* rev < 7, watermark for sdio device */
+/* rev < 7, watermark for sdio device TX path */
 #define SBSDIO_WATERMARK		0x10008
 /* control busy signal generation */
 #define SBSDIO_DEVICE_CTL		0x10009
@@ -104,6 +104,13 @@
 #define SBSDIO_FUNC1_RFRAMEBCHI		0x1001C
 /* MesBusyCtl (rev 11) */
 #define SBSDIO_FUNC1_MESBUSYCTRL	0x1001D
+/* Watermark for sdio device RX path */
+#define SBSDIO_MESBUSY_RXFIFO_WM_MASK	0x7F
+#define SBSDIO_MESBUSY_RXFIFO_WM_SHIFT	0
+/* Enable busy capability for MES access */
+#define SBSDIO_MESBUSYCTRL_ENAB		0x80
+#define SBSDIO_MESBUSYCTRL_ENAB_SHIFT	7
+
 /* Sdio Core Rev 12 */
 #define SBSDIO_FUNC1_WAKEUPCTRL		0x1001E
 #define SBSDIO_FUNC1_WCTRL_ALPWAIT_MASK		0x1
-- 
2.20.1



