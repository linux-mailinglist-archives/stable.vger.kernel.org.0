Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F44A6EE6E8
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 19:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbjDYRgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 13:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbjDYRgv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 13:36:51 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A507672A2
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 10:36:50 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e9e14a558f8ab-32a7770f7d1so60587695ab.1
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 10:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1682444210; x=1685036210;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7xMza7Z0Omi0jIrMpUKGLp6mE11ISCcMcel4DNlLoYE=;
        b=iAcqwIuuJQMVa7QTrYMC/QrRneRDSGEjDWRCQjA+wvU1F2Pzvk0PMxYaDq+MjcyHUV
         cJH4DW8c306VXBNbmWQ6q3iQb3RzE9aQ9eURfPA8aU4JjjEpeLEGdbgHcr6tnXlaJ2ss
         A6QfWQzwei/1vk7DQOSnODONIEKApfgyydXlc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682444210; x=1685036210;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7xMza7Z0Omi0jIrMpUKGLp6mE11ISCcMcel4DNlLoYE=;
        b=icSKXKjDMGwW1yDPCFZ9iMSVlIytnfSlEps46+M8bZ4PvWyh3E+84CyWn4P+ANpeEf
         9fZDy9YS3Pokdl00tpTk7pVlmyLdPRcG0efB9ewSHoOjuXoH4zQG8BI3n3AfG03E5G04
         kOc+5USt/m5mmbxFcfEVOiGyARWbB4+w09xqZ6arc1/YHnOcvj7AJFm+Lk+63u/vWoXT
         vZ8wuvrGnTUv2ckDjxzWL7EXZ4PQGJVVkfgq4UdJGnPgJEcO1D/Wo25frKVvYpEYo0O5
         NVVaxtMzYkB1qMPXnIfyQKVa8LcIXa84Yi9K/1arBLTBu2oasHyEs2JMiS5nC5E7Vu5X
         lcmg==
X-Gm-Message-State: AAQBX9d1Oc7jbNZJ/o5XaWoRdL153LMGZntPvJGHfrv+ZGsQVPVZHWvE
        zTaBZ35vk6kzbP9Gl0OjTmAuphw7R7FCHVqlcSI=
X-Google-Smtp-Source: AKy350bDVblGYphddfDRwu+sXvvpOr/eFTk2TTG64/ZYVqT5W4h0ARdMS/R7afJSjQGN9tdA2VBsWQ==
X-Received: by 2002:a92:cacd:0:b0:328:5525:26b5 with SMTP id m13-20020a92cacd000000b00328552526b5mr8418820ilq.10.1682444209873;
        Tue, 25 Apr 2023 10:36:49 -0700 (PDT)
Received: from markhas1.corp.google.com ([100.107.108.205])
        by smtp.gmail.com with ESMTPSA id o17-20020a92c051000000b0032867b9427esm3702208ilf.38.2023.04.25.10.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 10:36:49 -0700 (PDT)
From:   Mark Hasemeyer <markhas@chromium.org>
To:     stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mark Hasemeyer <markhas@chromium.org>
Subject: [PATCH] PCI/ASPM: Remove pcie_aspm_pm_state_change()
Date:   Tue, 25 Apr 2023 11:36:28 -0600
Message-ID: <20230425173628.1243713-1-markhas@chromium.org>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 08d0cc5f34265d1a1e3031f319f594bd1970976c upstream.

pcie_aspm_pm_state_change() was introduced at the inception of PCIe ASPM
code, but it can cause some issues. For instance, when ASPM config is
changed via sysfs, those changes won't persist across power state change
because pcie_aspm_pm_state_change() overwrites them.

Also, if the driver restores L1SS [1] after system resume, the restored
state will also be overwritten by pcie_aspm_pm_state_change().

Remove pcie_aspm_pm_state_change().  If there's any hardware that really
needs it to function, a quirk can be used instead.

[1] https://lore.kernel.org/linux-pci/20220201123536.12962-1-vidyas@nvidia.com/
Link: https://lore.kernel.org/r/20220509073639.2048236-1-kai.heng.feng@canonical.com
[bhelgaas: remove additional pcie_aspm_pm_state_change() call in
pci_set_low_power_state(), added by
10aa5377fc8a ("PCI/PM: Split pci_raw_set_power_state()") and moved by
7957d201456f ("PCI/PM: Relocate pci_set_low_power_state()")]
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
[manual backport: pci_set_low_power_state does not exist in v5.15]
Signed-off-by: Mark Hasemeyer <markhas@chromium.org>
---
This change is intended for, and has been tested against 5.15.y.
It is desired because without it, it has been observed that re-applying
aspm settings can cause the system to crash with certain pci devices
(ie.  Genesys GL9755).

A manual backport was required as `pci_set_low_power_state` does not exist in
v5.15.

Tested by issuing 100 suspend/resume cycles on a symptomatic system running
5.15.107.

Test command:
```
echo +5 > /sys/class/rtc/rtc0/wakealarm && echo freeze > /sys/power/state

```

L1 settings looked identical before and after:
```
localhost ~ # lspci -vvv -d 0x17a0: | grep L1Sub
                L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
                L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1+ ASPM_L1.2- ASPM_L1.1+
                L1SubCtl2: T_PwrOn=3100us
```

 drivers/pci/pci.c       |  3 ---
 drivers/pci/pci.h       |  2 --
 drivers/pci/pcie/aspm.c | 19 -------------------
 3 files changed, 24 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 649df298869c..4aa2e655398c 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1140,9 +1140,6 @@ static int pci_raw_set_power_state(struct pci_dev *dev, pci_power_t state)
 	if (need_restore)
 		pci_restore_bars(dev);
 
-	if (dev->bus->self)
-		pcie_aspm_pm_state_change(dev->bus->self);
-
 	return 0;
 }
 
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 72280e9b23b2..e6ea6e950428 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -595,12 +595,10 @@ bool pcie_wait_for_link(struct pci_dev *pdev, bool active);
 #ifdef CONFIG_PCIEASPM
 void pcie_aspm_init_link_state(struct pci_dev *pdev);
 void pcie_aspm_exit_link_state(struct pci_dev *pdev);
-void pcie_aspm_pm_state_change(struct pci_dev *pdev);
 void pcie_aspm_powersave_config_link(struct pci_dev *pdev);
 #else
 static inline void pcie_aspm_init_link_state(struct pci_dev *pdev) { }
 static inline void pcie_aspm_exit_link_state(struct pci_dev *pdev) { }
-static inline void pcie_aspm_pm_state_change(struct pci_dev *pdev) { }
 static inline void pcie_aspm_powersave_config_link(struct pci_dev *pdev) { }
 #endif
 
diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 013a47f587ce..b3ad316418f1 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -1020,25 +1020,6 @@ void pcie_aspm_exit_link_state(struct pci_dev *pdev)
 	up_read(&pci_bus_sem);
 }
 
-/* @pdev: the root port or switch downstream port */
-void pcie_aspm_pm_state_change(struct pci_dev *pdev)
-{
-	struct pcie_link_state *link = pdev->link_state;
-
-	if (aspm_disabled || !link)
-		return;
-	/*
-	 * Devices changed PM state, we should recheck if latency
-	 * meets all functions' requirement
-	 */
-	down_read(&pci_bus_sem);
-	mutex_lock(&aspm_lock);
-	pcie_update_aspm_capable(link->root);
-	pcie_config_aspm_path(link);
-	mutex_unlock(&aspm_lock);
-	up_read(&pci_bus_sem);
-}
-
 void pcie_aspm_powersave_config_link(struct pci_dev *pdev)
 {
 	struct pcie_link_state *link = pdev->link_state;
-- 
2.40.0.634.g4ca3ef3211-goog

