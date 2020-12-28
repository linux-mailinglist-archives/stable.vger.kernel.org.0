Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51F42E3AFC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391978AbgL1NoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:44:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391971AbgL1NoP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:44:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0367A206D4;
        Mon, 28 Dec 2020 13:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163015;
        bh=SouEUD5BJ3gnnq7AZxzqRsHZ8/JhO+UC3LcNUvWcgog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zNmn+s24blikvq67CgUfodeeJKQowONqSPUA6LW8p7E+1ieudiOUlybkEtuXdKZD0
         Ju+PAdxG0NxFs/V1e8BCPteKt+pc3cssedI5dNGPlPi8kHot+GESUykUvfQJ9vSQmN
         fCBQrz6im2cVbWNqsjiUV1zHe9XrDHrL0OIB+7kA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaehoon Chung <jh80.chung@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 109/453] brcmfmac: Fix memory leak for unpaired brcmf_{alloc/free}
Date:   Mon, 28 Dec 2020 13:45:45 +0100
Message-Id: <20201228124942.457670010@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Seung-Woo Kim <sw0312.kim@samsung.com>

[ Upstream commit 9db946284e07bb27309dd546b7fee528664ba82a ]

There are missig brcmf_free() for brcmf_alloc(). Fix memory leak
by adding missed brcmf_free().

Reported-by: Jaehoon Chung <jh80.chung@samsung.com>
Fixes: a1f5aac1765a ("brcmfmac: don't realloc wiphy during PCIe reset")
Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1603849967-22817-1-git-send-email-sw0312.kim@samsung.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 6 ++++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 3be60aef54650..cb68f54a9c56e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1936,16 +1936,18 @@ brcmf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	fwreq = brcmf_pcie_prepare_fw_request(devinfo);
 	if (!fwreq) {
 		ret = -ENOMEM;
-		goto fail_bus;
+		goto fail_brcmf;
 	}
 
 	ret = brcmf_fw_get_firmwares(bus->dev, fwreq, brcmf_pcie_setup);
 	if (ret < 0) {
 		kfree(fwreq);
-		goto fail_bus;
+		goto fail_brcmf;
 	}
 	return 0;
 
+fail_brcmf:
+	brcmf_free(&devinfo->pdev->dev);
 fail_bus:
 	kfree(bus->msgbuf);
 	kfree(bus);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 38e6809f16c75..ef5521b9b3577 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4433,6 +4433,7 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 		brcmf_sdiod_intr_unregister(bus->sdiodev);
 
 		brcmf_detach(bus->sdiodev->dev);
+		brcmf_free(bus->sdiodev->dev);
 
 		cancel_work_sync(&bus->datawork);
 		if (bus->brcmf_wq)
-- 
2.27.0



