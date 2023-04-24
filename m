Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8B56ED484
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 20:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbjDXSgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 14:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbjDXSfy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 14:35:54 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CD2FA
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 11:35:40 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id ca18e2360f4ac-760f4dcfdf4so441795239f.2
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 11:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1682361339; x=1684953339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W3YFkBTvx/8yf/DL61qAWgGHmF1jfeQ1FYKFH2hf9Ws=;
        b=c04pCqpLx2M0fJGRkOgpUE9IyrfEs9mcIuNv+DWLTHmA60LhyQOYijhPAgKhSZ3AnQ
         Q2yyxnnK5QNxsGFCUrBTYYQVBwh3zFDq5e3vaWcdyb0Dd6HIu2zDFP2I+HnMerOPvuVy
         DrgIr2ShmvzvjmFRLplVQwJ8U5iYpgoJLdK5E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682361339; x=1684953339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W3YFkBTvx/8yf/DL61qAWgGHmF1jfeQ1FYKFH2hf9Ws=;
        b=YXLOTgDtcAhE3HwPRgI+9/nURzVAKJeBShiYKTEeaqyzYfvJML6Lo7hortX5lX8opb
         zeZq4sLtKBf3qhqWe2ULwX6mLjvyfDPtotoe3h7v2WbrkGaueUXFFOnM+zdW/X8Uwaf+
         1lCkj0Q2IvbDTgi1f8/TvdqDM4u5R1gZ+9doZ6/C0lWhf+iTFeplIw2m1+O2yPlyYQHV
         9uHJvef+5WjrOu0COsw1XhdPJqpvru4si3QiMKTjWXCZqnWx42q+fb3g9CqSjzMwBJ+T
         9mnjm7Tmd8DaMxtV6IYO7cyNrMX/9rAvTklsEqhRwTMrbt8/OkIwjxpXhEsn3YWC6Jfe
         Rnzg==
X-Gm-Message-State: AAQBX9ds6TwCawt7+1IWBGXB4toSBLJhBPJFrNWJ+55tIQB8FIbWR0/f
        WoYCUUu/J1EygM0cW/Wv4vHCMg==
X-Google-Smtp-Source: AKy350ZBlomLjScHo56dHQQVQSaBFtfsCeAl51g20YKdsyDSYA7I37nP6ngCtOYqn7KuKh84Qx7bLA==
X-Received: by 2002:a6b:f315:0:b0:74c:ae72:dc16 with SMTP id m21-20020a6bf315000000b0074cae72dc16mr6318274ioh.5.1682361339501;
        Mon, 24 Apr 2023 11:35:39 -0700 (PDT)
Received: from markhas1.lan (71-218-48-220.hlrn.qwest.net. [71.218.48.220])
        by smtp.gmail.com with ESMTPSA id y22-20020a056638229600b0040611a31d5fsm3529096jas.80.2023.04.24.11.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 11:35:39 -0700 (PDT)
From:   Mark Hasemeyer <markhas@chromium.org>
To:     gregkh@linuxfoundation.org
Cc:     bhelgaas@google.com, kai.heng.feng@canonical.com,
        stable@vger.kernel.org, Mark Hasemeyer <markhas@chromium.org>
Subject: Re: [PATCH] PCI:ASPM: Remove pcie_aspm_pm_state_change()
Date:   Mon, 24 Apr 2023 12:35:36 -0600
Message-ID: <20230424183536.808003-1-markhas@chromium.org>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
In-Reply-To: <2023042354-enjoyment-promoter-9d54@gregkh>
References: <2023042354-enjoyment-promoter-9d54@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Odd, it does not apply cleanly, so how was this tested?  Can you please
> send the tested backport that you have so we know to get it correct?

Sorry about that. I had to apply a trivial backport as
`pci_set_low_power_state` does not exist in v5.15.  It was tested by using an
RTC wake in combination with using the sysfs to trigger a suspend:
```
echo +5 > /sys/class/rtc/rtc0/wakealarm && echo freeze > /sys/power/state
```

Patch below.
------------------------------------
From 5ca368f6918710bf491feee54e09a060de835d3f Mon Sep 17 00:00:00 2001
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date: Mon, 11 Jul 2022 18:07:01 -0500
Subject: [PATCH] PCI/ASPM: Remove pcie_aspm_pm_state_change()

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
Signed-off-by: Mark Hasemeyer <markhas@chromium.org>
---
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
2.39.2

