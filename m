Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB3E2E3C6E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436960AbgL1OCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:02:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:36430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436953AbgL1OCn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:02:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1869C206D4;
        Mon, 28 Dec 2020 14:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164122;
        bh=4MGHoEv84Ba7fJbw5MLd8o0IbZKXfUu6u+TPGm3kb1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQIQCWw6bgctzAEY3WFdsiWhR1+3OYVaOFa5xd2BhNlAvRAfKGPokE3KADGg1e2e1
         PjMxOv6+UHGCezAEERFxT8fsNc9qdDRwMKa8VvbWnGDhTn8XnALjHzn7S2zX8xZi3r
         Henwz3Kp+7hWmUAdtiev/ykcXKX6z7Z+8Q9LajPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaehoon Chung <jh80.chung@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/717] brcmfmac: Fix memory leak for unpaired brcmf_{alloc/free}
Date:   Mon, 28 Dec 2020 13:41:06 +0100
Message-Id: <20201228125024.254098971@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index 39381cbde89e6..d8db0dbcfe091 100644
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
index 99987a789e7e3..59c2b2b6027da 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4541,6 +4541,7 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 		brcmf_sdiod_intr_unregister(bus->sdiodev);
 
 		brcmf_detach(bus->sdiodev->dev);
+		brcmf_free(bus->sdiodev->dev);
 
 		cancel_work_sync(&bus->datawork);
 		if (bus->brcmf_wq)
-- 
2.27.0



