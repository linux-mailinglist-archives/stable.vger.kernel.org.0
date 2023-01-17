Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E82D66D8B5
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 09:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235789AbjAQIxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 03:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236242AbjAQIwf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 03:52:35 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1BCC2BF05;
        Tue, 17 Jan 2023 00:52:09 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d9so32816179pll.9;
        Tue, 17 Jan 2023 00:52:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8J3QnLiWJRNwJkdXquw7vxE3Dsm52ATXYwWQhTUVO8c=;
        b=Bl+gDGnqswDyw6qfZ0HF18+wo4Aa7SIBN9p//53E6u7BZyXtc9iUWikIk82ZPFDbJl
         XEygtj0z95rlwixTGeLwtHMmL5zfhMkHjWI6O4JZoREOWMGDYzixkKKHQZb3/JZp27iX
         oIswJlo02KfBqaSbaX/seez8n/NpYByzFoJjaOtqaGyC9huAyx4/7pvM8x1GZu7eUgFE
         zdPAhri8sDpy8/ZWjd0LC4IxNAD7bLHStmL/sR9Z+vRQAd4w28bXc/3Z92id0V0HbS0h
         kfNHYKqFN3EpOw7PT44r+ycCe9IABUXDnvLcsBGTRZQzVeRmQEh7bkuBoJ2mbFOemqXz
         V/BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8J3QnLiWJRNwJkdXquw7vxE3Dsm52ATXYwWQhTUVO8c=;
        b=SZOX0XlfzDL66rThpAkT69E37VgWCMv8bXl6N8J8ZPdiYr4SN8BhChx0PhyKX5nCPj
         xJJzZF+PNk4bmJySJNCNLl4aZCXMnYAYj/YKxObiz+0oDkDbOfJf+G71c421oLvk8IFZ
         SIgqoQuVB1qf2a9ULy2gYkT3dB3B5fUx/5reqb4UpoFyz9q4wBztFrOwbvnC6WsvRZ4S
         +4b0Bn0cCmDTwUHB3PopBMLgr/ng4MajFxINtJsaNTzV+MddCZmpjwPCZv2K3fomhgKh
         bR4kD6gNPfUltlh0pbOW1YD0LcCwKCnS3MqiITqVnKWQVRItPLeCD//mrvffOL7ZtmuJ
         QSjA==
X-Gm-Message-State: AFqh2kqSDtjMEeBOXiB394+gaiiSchkoEIu7B6fFEaA+tpODEjQZ5nZH
        6i1viZp4sWOeENFnTU9mA/6Lp+23MPP0zrG3
X-Google-Smtp-Source: AMrXdXu1f42hiShWd/lx0vjS/9BedCzCxAqmoYgNHckdGotC9WFpG1Arrrij8HYCFtNQumT649ascA==
X-Received: by 2002:a17:902:e845:b0:192:f45e:4197 with SMTP id t5-20020a170902e84500b00192f45e4197mr3542885plg.31.1673945528684;
        Tue, 17 Jan 2023 00:52:08 -0800 (PST)
Received: from localhost.localdomain ([218.150.75.42])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902988700b00192d9b86318sm20533801plp.137.2023.01.17.00.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 00:52:08 -0800 (PST)
From:   Juhyung Park <qkrwngud825@gmail.com>
To:     linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        gregkh@linuxfoundation.org
Cc:     stern@rowland.harvard.edu, zenghongling@kylinos.cn,
        zhongling0719@126.com, Juhyung Park <qkrwngud825@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] usb-storage: apply IGNORE_UAS only for HIKSEMI MD202 on RTL9210
Date:   Tue, 17 Jan 2023 17:51:54 +0900
Message-Id: <20230117085154.123301-1-qkrwngud825@gmail.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The commit e00b488e813f ("usb-storage: Add Hiksemi USB3-FW to IGNORE_UAS")
blacklists UAS for all of RTL9210 enclosures.

The RTL9210 controller was advertised with UAS since its release back in
2019 and was shipped with a lot of enclosure products with different
firmware combinations.

Blacklist UAS only for HIKSEMI MD202.

This should hopefully be replaced with more robust method than just
comparing strings.  But with limited information [1] provided thus far
(dmesg when the device is plugged in, which includes manufacturer and
product, but no lsusb -v to compare against), this is the best we can do
for now.

[1] https://lore.kernel.org/all/20230109115550.71688-1-qkrwngud825@gmail.com

Fixes: e00b488e813f ("usb-storage: Add Hiksemi USB3-FW to IGNORE_UAS")
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Hongling Zeng <zenghongling@kylinos.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Juhyung Park <qkrwngud825@gmail.com>
---
 drivers/usb/storage/uas-detect.h  | 13 +++++++++++++
 drivers/usb/storage/unusual_uas.h |  7 -------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/storage/uas-detect.h b/drivers/usb/storage/uas-detect.h
index 3f720faa6f97..d73282c0ec50 100644
--- a/drivers/usb/storage/uas-detect.h
+++ b/drivers/usb/storage/uas-detect.h
@@ -116,6 +116,19 @@ static int uas_use_uas_driver(struct usb_interface *intf,
 	if (le16_to_cpu(udev->descriptor.idVendor) == 0x0bc2)
 		flags |= US_FL_NO_ATA_1X;
 
+	/*
+	 * RTL9210-based enclosure from HIKSEMI, MD202 reportedly have issues
+	 * with UAS.  This isn't distinguishable with just idVendor and
+	 * idProduct, use manufacturer and product too.
+	 *
+	 * Reported-by: Hongling Zeng <zenghongling@kylinos.cn>
+	 */
+	if (le16_to_cpu(udev->descriptor.idVendor) == 0x0bda &&
+			le16_to_cpu(udev->descriptor.idProduct) == 0x9210 &&
+			(udev->manufacturer && !strcmp(udev->manufacturer, "HIKSEMI")) &&
+			(udev->product && !strcmp(udev->product, "MD202")))
+		flags |= US_FL_IGNORE_UAS;
+
 	usb_stor_adjust_quirks(udev, &flags);
 
 	if (flags & US_FL_IGNORE_UAS) {
diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 251778d14e2d..c7b763d6d102 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -83,13 +83,6 @@ UNUSUAL_DEV(0x0bc2, 0x331a, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_REPORT_LUNS),
 
-/* Reported-by: Hongling Zeng <zenghongling@kylinos.cn> */
-UNUSUAL_DEV(0x0bda, 0x9210, 0x0000, 0x9999,
-		"Hiksemi",
-		"External HDD",
-		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_IGNORE_UAS),
-
 /* Reported-by: Benjamin Tissoires <benjamin.tissoires@redhat.com> */
 UNUSUAL_DEV(0x13fd, 0x3940, 0x0000, 0x9999,
 		"Initio Corporation",
-- 
2.39.0

