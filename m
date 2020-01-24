Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88A2E148486
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732464AbgAXLL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:11:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:47336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387621AbgAXLL1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:11:27 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 033E02075D;
        Fri, 24 Jan 2020 11:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864286;
        bh=A2VtvgBGwinZJGuqt+W1zTJyz8M9bihwlos2OX8OKeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hVgy5te8nmjMIsSmxs3bEpEPAZeAZsNm1oijDthOG+qviQBBLusRXBSQh45WtEOyP
         /PXUmIrDh2aW0L5c5n6C65Or9ZZamBbXSLV57qcvR3tUVD0IhjJTnIkVL0sp0SYl6M
         6HPXf1P+6aFdd5/xu+706f8G0+NyNPMWrf/3I0h4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russel King <linux@armlinux.org.uk>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 212/639] brcmfmac: create debugfs files for bus-specific layer
Date:   Fri, 24 Jan 2020 10:26:22 +0100
Message-Id: <20200124093113.542375721@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arend van Spriel <arend.vanspriel@broadcom.com>

[ Upstream commit aaf6a5e86e36766abbeedf220462bde8031f9a72 ]

Since we moved the drivers debugfs directory under ieee80211 debugfs the
debugfs entries need to be added after wiphy_register() has been called.
For most part that has been done accordingly, but for the debugfs entries
added by SDIO it was not and failed silently. This patch fixes that by
adding a bus-layer callback for it.

Fixes: 856d5a011c86 ("brcmfmac: allocate struct brcmf_pub instance using wiphy_new()")
Reported-by: Russel King <linux@armlinux.org.uk>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h   | 10 ++++++++++
 .../net/wireless/broadcom/brcm80211/brcmfmac/core.c  |  1 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/sdio.c  | 12 +++++++-----
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index c4965184cdf37..3d441c5c745cc 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -90,6 +90,7 @@ struct brcmf_bus_ops {
 	int (*get_memdump)(struct device *dev, void *data, size_t len);
 	int (*get_fwname)(struct device *dev, const char *ext,
 			  unsigned char *fw_name);
+	void (*debugfs_create)(struct device *dev);
 };
 
 
@@ -235,6 +236,15 @@ int brcmf_bus_get_fwname(struct brcmf_bus *bus, const char *ext,
 	return bus->ops->get_fwname(bus->dev, ext, fw_name);
 }
 
+static inline
+void brcmf_bus_debugfs_create(struct brcmf_bus *bus)
+{
+	if (!bus->ops->debugfs_create)
+		return;
+
+	return bus->ops->debugfs_create(bus->dev);
+}
+
 /*
  * interface functions from common layer
  */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 584e05fdca6ad..9d7b8834b8545 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1105,6 +1105,7 @@ static int brcmf_bus_started(struct brcmf_pub *drvr, struct cfg80211_ops *ops)
 	brcmf_debugfs_add_entry(drvr, "revinfo", brcmf_revinfo_read);
 	brcmf_feat_debugfs_create(drvr);
 	brcmf_proto_debugfs_create(drvr);
+	brcmf_bus_debugfs_create(bus_if);
 
 	return 0;
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index abaed2fa2defd..5c3b62e619807 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3131,9 +3131,12 @@ static int brcmf_debugfs_sdio_count_read(struct seq_file *seq, void *data)
 	return 0;
 }
 
-static void brcmf_sdio_debugfs_create(struct brcmf_sdio *bus)
+static void brcmf_sdio_debugfs_create(struct device *dev)
 {
-	struct brcmf_pub *drvr = bus->sdiodev->bus_if->drvr;
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_pub *drvr = bus_if->drvr;
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
+	struct brcmf_sdio *bus = sdiodev->bus;
 	struct dentry *dentry = brcmf_debugfs_get_devdir(drvr);
 
 	if (IS_ERR_OR_NULL(dentry))
@@ -3153,7 +3156,7 @@ static int brcmf_sdio_checkdied(struct brcmf_sdio *bus)
 	return 0;
 }
 
-static void brcmf_sdio_debugfs_create(struct brcmf_sdio *bus)
+static void brcmf_sdio_debugfs_create(struct device *dev)
 {
 }
 #endif /* DEBUG */
@@ -3438,8 +3441,6 @@ static int brcmf_sdio_bus_preinit(struct device *dev)
 	if (bus->rxbuf)
 		bus->rxblen = value;
 
-	brcmf_sdio_debugfs_create(bus);
-
 	/* the commands below use the terms tx and rx from
 	 * a device perspective, ie. bus:txglom affects the
 	 * bus transfers from device to host.
@@ -4050,6 +4051,7 @@ static const struct brcmf_bus_ops brcmf_sdio_bus_ops = {
 	.get_ramsize = brcmf_sdio_bus_get_ramsize,
 	.get_memdump = brcmf_sdio_bus_get_memdump,
 	.get_fwname = brcmf_sdio_get_fwname,
+	.debugfs_create = brcmf_sdio_debugfs_create
 };
 
 #define BRCMF_SDIO_FW_CODE	0
-- 
2.20.1



