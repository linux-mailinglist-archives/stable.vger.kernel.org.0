Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807221B266F
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbgDUMlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728926AbgDUMlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:41:10 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7D6C061A10
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:09 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u16so3491100wmc.5
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1aVRqB/VAz75UKZIp52ExAu2DukK4fgEMw659Zq5hiU=;
        b=Vt8eivgS4tqwgtjQHWbmXq7uavG3ycAFEgkIdApuwVeekgChpQEJ0iT+G9XJoqe9Bi
         962wJSNqeN0Pe+CtiFf3TYo90OSUlRZteoVj0GESvjfStow7wdxFje5zaa9ChGXQA/IR
         yPSHbeMbH09+FBm5k5GqW23cK2kkeKzHPc4rFVzbJPewHwvdpO6mD16TRLc8GfGMXIl9
         kvW8+TKNXgPfyYh00buLqov4qgrF7I3rK53vD4DbJycDLhubTKSXvECVUBL14bFCUtNh
         5VHzHx60Yt9r4Iv6OqZqZtkXJQ7HZ8EbipylXEx4TsTbB3QgcilVusU73l1UyAHpjCzE
         Kq/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1aVRqB/VAz75UKZIp52ExAu2DukK4fgEMw659Zq5hiU=;
        b=KKHE32gjxg8stnr6H4E4rTGF/qov/HMTkTQ+3PNMnLH0MihQpmgnKfsKUqZQVPv5Vf
         MuPNgamQcQmFDT/zvxEDDvs1vgJMBU10FH11TwwD8TdJeJw6fQT1T6eCSqlWVdUBiVG+
         8kMXrjm1kJv1mcZCh8sDAnI9wiOA5sglN9X3MhiF+Vd9p4nHhFQ3TFYOY0Anc0+oLiC2
         AN9B9znFy1dUyJQYJLQ6fy2Yq++Di32/G7SRj7ZUKi7CdKpur/4OXTl05l3CWJ67+Dpb
         sCu61KYQx7xjIGQXmAs8fDK9NB1u71yM+yLZm/arr4Vixp4Aag6O/LYAwD73HyIVs0M4
         5SFw==
X-Gm-Message-State: AGi0PuZVNTaoqumdBYNeCOmXwfxlVlBur1sVTRxtRPovQYi7YSj2YmuR
        o+Qicb9Fv+hbsUXoxIXSvaT0Cztnbzc=
X-Google-Smtp-Source: APiQypJqkaO9eeOCmKWOW5CLQiAuFj/Znsuzvb8r5pZ9X8cciWMjZpEc3zVzBtQt7s2GD7sfvsqB5A==
X-Received: by 2002:a7b:cf2b:: with SMTP id m11mr4433553wmg.147.1587472868153;
        Tue, 21 Apr 2020 05:41:08 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:41:07 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Lazar Alexei <qca_ailizaro@qca.qualcomm.com>,
        Maya Erez <qca_merez@qca.qualcomm.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 18/24] wil6210: fix PCIe bus mastering in case of interface down
Date:   Tue, 21 Apr 2020 13:40:11 +0100
Message-Id: <20200421124017.272694-19-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
References: <20200421124017.272694-1-lee.jones@linaro.org>
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

