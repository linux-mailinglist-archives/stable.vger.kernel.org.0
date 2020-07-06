Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0E7216258
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 01:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgGFXcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 19:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbgGFXcp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jul 2020 19:32:45 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B3AC08C5DF
        for <stable@vger.kernel.org>; Mon,  6 Jul 2020 16:32:45 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h2so22327568pgc.19
        for <stable@vger.kernel.org>; Mon, 06 Jul 2020 16:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=4fIH4GN6n6dAxulY3f2rwIOekdlU8y7grvtSAmvPzI8=;
        b=J9lTuX6BUejRFhEHNFaUM+EGnZQ/75bZdLy4iNsT5Hfg9e9Vp2ZjxgzbX6pUw+Lcpn
         tg1r43Kv4uTk2BFurA1fcOtde1w2S5Je2ywaJQQJWmwP1e8BwNtQBgUHZQNR3MaXk813
         KuuesbqVFVvSo/GTlZp2ModcBzp2zvzYYFI+7B3gCdZbgJX8NyUO1ctAA8jzvSYvoZ2S
         XjPbtdKmePRNKr5bdqJi4L7kLsiJO1NYgKJn8l9OGXLA+HENv1Ai/LM+1uZFkp7+mArP
         Lt24vuKQtog0Wr1766hzamg6DKROwdRAxNd37B1qvIDbC2ELunnN1EbkQ2Lt4eBKXH6n
         Gyyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=4fIH4GN6n6dAxulY3f2rwIOekdlU8y7grvtSAmvPzI8=;
        b=MPDP8h1/7xBIcfnSSbgDqRnBTPTSKriZw0mxgDvpuOAPZh/JJLNi/QOa8jLBNNiGAm
         ixSw5p13xp9LY5MvdJB5BROcP5yrC9PWZOZC/5vUbxpBGph9ppLZ4boq28fJnJ9OB4Tt
         bSYcFk8NuK4WdyAibvzaBei3kppjAecf4ZMDZY8rjsLxZrqIxh78SdOV893SxejGuUmf
         pGmWMW0ZCusnck55x8TWqJo00h5BshA+bD72ksyXp4WEVOzTMThEvdoRrFkkU6NK/JMo
         B9XuHD4DTpPSB8VXOwU4bM/ra3Ni6sYbyRXaWoItZdQMFIK/xemLk4kxdrY0qeuu4LMa
         2JCg==
X-Gm-Message-State: AOAM5331QcNMzgfdUZ3a0RPi8w9Hi+3qsUT/UbPp/a5npJSXLMVb4rKY
        9xCdD0hAp3bgDKv8dKlOOzP49xN2aDu3
X-Google-Smtp-Source: ABdhPJyzU+Syk8Z8h9GVkTKPHXiJJGlAsi/qdcYnGS/wnQmGjay+JpyjugMliaODOoNeHqqjGG/4eRSGb/8V
X-Received: by 2002:a17:902:8c8a:: with SMTP id t10mr40175484plo.153.1594078364821;
 Mon, 06 Jul 2020 16:32:44 -0700 (PDT)
Date:   Mon,  6 Jul 2020 16:32:40 -0700
Message-Id: <20200706233240.3245512-1-rajatja@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH RESEND v2] PCI: Add device even if driver attach failed
From:   Rajat Jain <rajatja@google.com>
To:     David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Raj Ashok <ashok.raj@intel.com>,
        lalithambika.krishnakumar@intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Prashant Malani <pmalani@google.com>,
        Benson Leung <bleung@google.com>,
        Todd Broch <tbroch@google.com>,
        Alex Levin <levinale@google.com>,
        Mattias Nissler <mnissler@google.com>,
        Rajat Jain <rajatxjain@gmail.com>,
        Bernie Keany <bernie.keany@intel.com>,
        Aaron Durbin <adurbin@google.com>,
        Diego Rivas <diegorivas@google.com>,
        Duncan Laurie <dlaurie@google.com>,
        Furquan Shaikh <furquan@google.com>,
        Jesse Barnes <jsbarnes@google.com>,
        Christian Kellner <christian@kellner.me>,
        Alex Williamson <alex.williamson@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        oohall@gmail.com, Saravana Kannan <saravanak@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        stable@vger.kernel.org
Cc:     Rajat Jain <rajatja@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

device_attach() returning failure indicates a driver error while trying to
probe the device. In such a scenario, the PCI device should still be added
in the system and be visible to the user.

This patch partially reverts:
commit ab1a187bba5c ("PCI: Check device_attach() return value always")

Signed-off-by: Rajat Jain <rajatja@google.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Resending to stable, independent from other patches per Greg's suggestion
v2: Add Greg's reviewed by, fix commit log

 drivers/pci/bus.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 8e40b3e6da77d..3cef835b375fd 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -322,12 +322,8 @@ void pci_bus_add_device(struct pci_dev *dev)
 
 	dev->match_driver = true;
 	retval = device_attach(&dev->dev);
-	if (retval < 0 && retval != -EPROBE_DEFER) {
+	if (retval < 0 && retval != -EPROBE_DEFER)
 		pci_warn(dev, "device attach failed (%d)\n", retval);
-		pci_proc_detach_device(dev);
-		pci_remove_sysfs_dev_files(dev);
-		return;
-	}
 
 	pci_dev_assign_added(dev, true);
 }
-- 
2.27.0.212.ge8ba1cc988-goog

