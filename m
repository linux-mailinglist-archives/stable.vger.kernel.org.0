Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFCC68E673
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 04:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjBHDIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 22:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjBHDIe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 22:08:34 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE2624C86
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 19:08:33 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id q9so11798124pgq.5
        for <stable@vger.kernel.org>; Tue, 07 Feb 2023 19:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qVCaQKOLzAXaA2gXMDse/LMPSxT7SMwEZbw1H8JfjCQ=;
        b=jL20HcKTsSRJ+UX89awBoUNQYJa+NYSWH334ThuFiznF4gjw4niBTuYadDjkES5Y90
         WO8k3lm/FXEwHeDyXatz3RMxy2bdWHLlASWrlDE4tVBTr4WuZBNA5rzwR/tc56+EENcX
         CYRgywNX0L8tpmCGmM0Dvgx3iOCkQRWdYGT8w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qVCaQKOLzAXaA2gXMDse/LMPSxT7SMwEZbw1H8JfjCQ=;
        b=MhO0SwAessAhwV1fp5OT1k+Gp23KJVKlKsUhGRa7NBomXF6/2vTLEYHK0X91Chq9DF
         1O0n+Is/AT8rm117Sz38teJxuzAyvxRFzjYKmKCRxb87f8RaSCVBnj1C2+OGzDWwxL7U
         iam0IertB3Wa/WQ1BhNb1TWS3JxTCnEWTPV+7pbAgeEsZ4tm0iCbHORenAAgpI6TBzVz
         iGcuvXgibthLZsGBJN/bZkE4Ib5n3fEVjPJv6bQSiM3ozfkFMuem9rCEtlhGLVH68GQj
         tAgAK0C3IAqKpAI2AYLd0bhs42SF9E5TyzNtWPa6ncRYD6BB26KY9Koc6d+vbe52Jw4V
         3sdg==
X-Gm-Message-State: AO0yUKX7+Heri7dNd8+5txvRZTB7N5emNJMCQkz+6EW3lVmtAEfy7c8T
        8rA9l6lO0xBvuV7WUIosGTR4JhawGnydYGXd
X-Google-Smtp-Source: AK7set+i/EmTRdJ7lp+jOV7Y43IhsmG8jWH+YkB3SwVc8Xmkz3dst7NTNoyOFCFw0/MEQS+JLdsp2Q==
X-Received: by 2002:a62:1913:0:b0:592:3e51:d881 with SMTP id 19-20020a621913000000b005923e51d881mr4878146pfz.14.1675825713380;
        Tue, 07 Feb 2023 19:08:33 -0800 (PST)
Received: from localhost ([2620:15c:9d:2:2c60:caa1:67b7:15bb])
        by smtp.gmail.com with UTF8SMTPSA id c2-20020aa78802000000b005907716bf8bsm9993637pfo.60.2023.02.07.19.08.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 19:08:32 -0800 (PST)
From:   Gwendal Grignou <gwendal@chromium.org>
To:     andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Gwendal Grignou <gwendal@chromium.org>
Subject: [PATCH 5.4] nvme-pci: Move enumeration by class to be last in the table
Date:   Tue,  7 Feb 2023 19:08:24 -0800
Message-Id: <20230208030824.235941-1-gwendal@chromium.org>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

It's unusual that we have enumeration by class in the middle of the table.
It might potentially be problematic in the future if we add another entry
after it.

So, move class matching entry to be the last in the ID table.

[ Upstream commit 0b85f59d30b91bd2b93ea7ef0816a4b7e7039e8c ]

Without this change, quirks set in driver_data added after the catch-all
are ignored.

Cc: <stable@vger.kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 5d62d1042c0e6..a58711c488509 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3199,7 +3199,6 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(0x1c5c, 0x1504),   /* SK Hynix PC400 */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
-	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_EXPRESS, 0xffffff) },
 	{ PCI_DEVICE(0x2646, 0x2263),   /* KINGSTON A2000 NVMe SSD  */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2001),
@@ -3209,6 +3208,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_SINGLE_VECTOR |
 				NVME_QUIRK_128_BYTES_SQES |
 				NVME_QUIRK_SHARED_TAGS },
+
+	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_EXPRESS, 0xffffff) },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, nvme_id_table);
-- 
2.39.1.519.gcb327c4b5f-goog

