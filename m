Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2058122A44
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 12:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfLQLim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 06:38:42 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37617 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbfLQLil (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 06:38:41 -0500
Received: by mail-lf1-f68.google.com with SMTP id b15so6733456lfc.4;
        Tue, 17 Dec 2019 03:38:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=vhAFFq+RTEj2TN4YdJhLies+9dkt86I4rjWAQmFbJVU=;
        b=UGjNMAxmMR/v6YOvbO90lm2X5XgcmJGgt/sAsYMMhj6/HdCRbKLr0zNADnNa1UCEoP
         Y0yVRmFw1CoRqZPMtC7NbI8jbFhrxt4KXAGW2dPFrD+ElD2jFuza2/TxOsDWhuO5uHFt
         bWMPCEQUjgbPkKneU86v3bZeHGxLj37OcsOH1JB94cKil0k4kD1lDopAC4YOhSIk4Dwh
         4603dCGbXz6e+USFIlghxmVSZPAHmeiA5ONdGWvhTrwqfucqkJiRVyQ4Lg7qO2ARCJFL
         8I5BaFmIsTDq6zH1MLpIdjMWbA2XAsrmIcwBfwAPS41ujm/ctmRFVSBeG+6kcjpRAZiG
         LfZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=vhAFFq+RTEj2TN4YdJhLies+9dkt86I4rjWAQmFbJVU=;
        b=s0XlWnHn/WWiXD7XXA16+2gQvVc+vorc21fEaUccliHfW93QED5e4IQDkMCLCbdI7X
         Ai4YtrZYxZyDOcG2RTxXKZgLmVTPrucTcLF8dyuXi4FacERO1zful8uXph02XaBe7DSi
         CqSsZ4IxSTvDVWhjJ56xqh8EwIUXa6LrHuroR8KdEU0z4k1Kn8iYqCPN6vRb5okGkuap
         AI9H8PGcfPe2xiVNx0v8k/3Y1ohR/0T4pI9errmwMJa6bxN+gks9ikgx2ITMbBF61HSM
         xbFKFczVdpIiSI8rpyEIzTZkUMy9x/6Ii56uNSjbJWX9rlGZCorAbGxM6lkkENwDrzGB
         9VSA==
X-Gm-Message-State: APjAAAUaAllMI7npOlZZsYIWQLf6in7o59SrYwQxlDEemSoe0eI7ZPUv
        jXZT2ciQezy4Qe+yKiYSh938TbGmVZs=
X-Google-Smtp-Source: APXvYqwrk2MYsuu/FULEnSswTsqabftj9fuo5tG5GJxe7AKURdtht0AL0b5d4PlWxHUktElJb6R9mA==
X-Received: by 2002:a05:6512:284:: with SMTP id j4mr2315512lfp.109.1576582719399;
        Tue, 17 Dec 2019 03:38:39 -0800 (PST)
Received: from monakov-y.xu ([81.222.243.34])
        by smtp.gmail.com with ESMTPSA id i197sm10774934lfi.56.2019.12.17.03.38.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 17 Dec 2019 03:38:39 -0800 (PST)
Date:   Tue, 17 Dec 2019 14:38:36 +0300
From:   Yurii Monakov <monakov.y@gmail.com>
To:     linux-pci@vger.kernel.org
Cc:     stable@vger.kernel.org, andrew.murray@arm.com, m-karicheri2@ti.com
Subject: [PATCH v2] PCI: keystone: Fix link training retries initiation
Message-ID: <20191217143836.3449cfe2@monakov-y.xu>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ks_pcie_stop_link() function does not clear LTSSM_EN_VAL bit so
link training was not triggered more than once after startup.
In configurations where link can be unstable during early boot,
for example, under low temperature, it will never be established.

Fixes: 0c4ffcfe1fbc ("PCI: keystone: Add TI Keystone PCIe driver")
Signed-off-by: Yurii Monakov <monakov.y@gmail.com>
CC:stable@vger.kernel.org
---
 drivers/pci/controller/dwc/pci-keystone.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pci-keystone.c b/drivers/pci/controller/dwc/pci-keystone.c
index af677254a072..d4de4f6cff8b 100644
--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -510,7 +510,7 @@ static void ks_pcie_stop_link(struct dw_pcie *pci)
 	/* Disable Link training */
 	val = ks_pcie_app_readl(ks_pcie, CMD_STATUS);
 	val &= ~LTSSM_EN_VAL;
-	ks_pcie_app_writel(ks_pcie, CMD_STATUS, LTSSM_EN_VAL | val);
+	ks_pcie_app_writel(ks_pcie, CMD_STATUS, val);
 }
 
 static int ks_pcie_start_link(struct dw_pcie *pci)
-- 
2.17.1
