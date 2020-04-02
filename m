Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1632819C9A0
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388892AbgDBTN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:26 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44220 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389422AbgDBTNZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:25 -0400
Received: by mail-wr1-f67.google.com with SMTP id m17so5541539wrw.11
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1aVRqB/VAz75UKZIp52ExAu2DukK4fgEMw659Zq5hiU=;
        b=zLA0KLLQz4Vu2yLaK+WNl5dAfEte2iPjLD4kGg/WdsZNY6Qi+eX2aAuv/XzF7xh2BE
         rjoqFhmo+xSZG8rcJL69ddSqt3BAFZYqCQCQi3ksWLAEnLikJ8zSQjEEuxU+pMctE41O
         bVrVm1VbWQWPJEgzpzhcbJu0udMBZSz1Df92miRF5gih/0XDKq70izvNEULV4+yiB/AH
         yhsh1RG2xd3Z5Dve2iX29TPYaiayzNOoySi+hGXK1XEqSpBr8/u7lBJelsjN/c8+gFq8
         L2sOlRBQcN467jTTBn2ofYjhDI+BmiMjI/NcImn3/15FwLYdoymnepFYgJQDMF9ov5ll
         +n5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1aVRqB/VAz75UKZIp52ExAu2DukK4fgEMw659Zq5hiU=;
        b=Tqfxa9pIAYxoECFrKWpAjMHuN7TRnXeUidCn8OkqTJkCCng1Am0EQEfPsmrAnyYZrh
         VH03ycFdSCHLTUKz7Nj+rBYMTYavQHKc2I2BXcM+wJLjESeWhQXzCRU+n+8yYf1Lhlnh
         jjrkXpzrWdrxZoLA49tndK4eOslwkgSzNtCjX76vJcstFmoQoGIRdQ0QBquKUJi/6VQE
         f4VmFIW2sheI0P5eMOjVmyd7ehVmILC7zqOdqeHP3cFeDM7fiyY5fxTlOBg+UAcrnn1V
         Pq9kGv6FPm6aChTJzZXkeDrPCW+LkIT5eAdIoQtctmadTowYmcckkQEmy7KJjniWGke6
         OXDQ==
X-Gm-Message-State: AGi0Puaqy+fnnBZnkswMVGnGG+Jhw7p3h5ieZ+ZxdM9HIzK305fogWFX
        oTpdUfP0czwf1zNd4KiaZf2/b0cqUdHiaQ==
X-Google-Smtp-Source: APiQypJKWj4g5+QperZ7/uiFJzYjUgW6c2E6LxTGkLe+Ss3mCgHJ/DMc5Nex+jTNeHEd1/KvzatmjQ==
X-Received: by 2002:adf:e6c8:: with SMTP id y8mr4728709wrm.279.1585854802826;
        Thu, 02 Apr 2020 12:13:22 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:22 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 24/33] wil6210: fix PCIe bus mastering in case of interface down
Date:   Thu,  2 Apr 2020 20:13:44 +0100
Message-Id: <20200402191353.787836-24-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lazar Alexei <qca_ailizaro@qca.qualcomm.com>

[ Upstream commit 680c242dc25e036265793edc7d755cfc15afd231 ]

In case of interface down, radio is turned off but PCIe mastering is
not cleared.
This can cause unexpected PCIe access to the shutdown device.
Fix this by clearing PCIe mastering also in case interface is down

Signed-off-by: Lazar Alexei <qca_ailizaro@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 24 +++++++++++++--------
 drivers/net/wireless/ath/wil6210/pm.c       | 10 ++-------
 drivers/net/wireless/ath/wil6210/wil6210.h  |  4 ++--
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 6a3ab4bf916dd..b2c3cf6db8814 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -393,6 +393,9 @@ static int wil6210_suspend(struct device *dev, bool is_runtime)
 	int rc = 0;
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct wil6210_priv *wil = pci_get_drvdata(pdev);
+	struct net_device *ndev = wil_to_ndev(wil);
+	bool keep_radio_on = ndev->flags & IFF_UP &&
+			     wil->keep_radio_on_during_sleep;
 
 	wil_dbg_pm(wil, "suspend: %s\n", is_runtime ? "runtime" : "system");
 
@@ -400,14 +403,14 @@ static int wil6210_suspend(struct device *dev, bool is_runtime)
 	if (rc)
 		goto out;
 
-	rc = wil_suspend(wil, is_runtime);
+	rc = wil_suspend(wil, is_runtime, keep_radio_on);
 	if (!rc) {
 		wil->suspend_stats.successful_suspends++;
 
-		/* If platform device supports keep_radio_on_during_sleep
-		 * it will control PCIe master
+		/* In case radio stays on, platform device will control
+		 * PCIe master
 		 */
-		if (!wil->keep_radio_on_during_sleep)
+		if (!keep_radio_on)
 			/* disable bus mastering */
 			pci_clear_master(pdev);
 	}
@@ -420,20 +423,23 @@ static int wil6210_resume(struct device *dev, bool is_runtime)
 	int rc = 0;
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct wil6210_priv *wil = pci_get_drvdata(pdev);
+	struct net_device *ndev = wil_to_ndev(wil);
+	bool keep_radio_on = ndev->flags & IFF_UP &&
+			     wil->keep_radio_on_during_sleep;
 
 	wil_dbg_pm(wil, "resume: %s\n", is_runtime ? "runtime" : "system");
 
-	/* If platform device supports keep_radio_on_during_sleep it will
-	 * control PCIe master
+	/* In case radio stays on, platform device will control
+	 * PCIe master
 	 */
-	if (!wil->keep_radio_on_during_sleep)
+	if (!keep_radio_on)
 		/* allow master */
 		pci_set_master(pdev);
-	rc = wil_resume(wil, is_runtime);
+	rc = wil_resume(wil, is_runtime, keep_radio_on);
 	if (rc) {
 		wil_err(wil, "device failed to resume (%d)\n", rc);
 		wil->suspend_stats.failed_resumes++;
-		if (!wil->keep_radio_on_during_sleep)
+		if (!keep_radio_on)
 			pci_clear_master(pdev);
 	} else {
 		wil->suspend_stats.successful_resumes++;
diff --git a/drivers/net/wireless/ath/wil6210/pm.c b/drivers/net/wireless/ath/wil6210/pm.c
index 8f5d1b447aaa2..8378742ecd49d 100644
--- a/drivers/net/wireless/ath/wil6210/pm.c
+++ b/drivers/net/wireless/ath/wil6210/pm.c
@@ -279,12 +279,9 @@ static int wil_resume_radio_off(struct wil6210_priv *wil)
 	return rc;
 }
 
-int wil_suspend(struct wil6210_priv *wil, bool is_runtime)
+int wil_suspend(struct wil6210_priv *wil, bool is_runtime, bool keep_radio_on)
 {
 	int rc = 0;
-	struct net_device *ndev = wil_to_ndev(wil);
-	bool keep_radio_on = ndev->flags & IFF_UP &&
-			     wil->keep_radio_on_during_sleep;
 
 	wil_dbg_pm(wil, "suspend: %s\n", is_runtime ? "runtime" : "system");
 
@@ -307,12 +304,9 @@ int wil_suspend(struct wil6210_priv *wil, bool is_runtime)
 	return rc;
 }
 
-int wil_resume(struct wil6210_priv *wil, bool is_runtime)
+int wil_resume(struct wil6210_priv *wil, bool is_runtime, bool keep_radio_on)
 {
 	int rc = 0;
-	struct net_device *ndev = wil_to_ndev(wil);
-	bool keep_radio_on = ndev->flags & IFF_UP &&
-			     wil->keep_radio_on_during_sleep;
 	unsigned long long suspend_time_usec = 0;
 
 	wil_dbg_pm(wil, "resume: %s\n", is_runtime ? "runtime" : "system");
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 315ec8b596628..c5b6b783100aa 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -1000,8 +1000,8 @@ int wil_request_firmware(struct wil6210_priv *wil, const char *name,
 bool wil_fw_verify_file_exists(struct wil6210_priv *wil, const char *name);
 
 int wil_can_suspend(struct wil6210_priv *wil, bool is_runtime);
-int wil_suspend(struct wil6210_priv *wil, bool is_runtime);
-int wil_resume(struct wil6210_priv *wil, bool is_runtime);
+int wil_suspend(struct wil6210_priv *wil, bool is_runtime, bool keep_radio_on);
+int wil_resume(struct wil6210_priv *wil, bool is_runtime, bool keep_radio_on);
 bool wil_is_wmi_idle(struct wil6210_priv *wil);
 int wmi_resume(struct wil6210_priv *wil);
 int wmi_suspend(struct wil6210_priv *wil);
-- 
2.25.1

