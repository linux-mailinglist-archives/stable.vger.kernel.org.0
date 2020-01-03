Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F87A12FB24
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 18:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgACRKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 12:10:37 -0500
Received: from ale.deltatee.com ([207.54.116.67]:49104 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727952AbgACRKh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jan 2020 12:10:37 -0500
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <gunthorp@deltatee.com>)
        id 1inQT3-0000cz-S1; Fri, 03 Jan 2020 10:10:34 -0700
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.92)
        (envelope-from <gunthorp@deltatee.com>)
        id 1inQT2-0006ii-5T; Fri, 03 Jan 2020 10:10:32 -0700
From:   Logan Gunthorpe <logang@deltatee.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>,
        Doug Meyer <dmeyer@gigaio.com>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org,
        Kelvin Cao <Kelvin.Cao@microchip.com>
Date:   Fri,  3 Jan 2020 10:10:29 -0700
Message-Id: <20200103171029.25790-1-logang@deltatee.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: gregkh@linuxfoundation.org, sashal@kernel.org, logang@deltatee.com, dmeyer@gigaio.com, bhelgaas@google.com, stable@vger.kernel.org, Kelvin.Cao@microchip.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        MYRULES_NO_TEXT autolearn=no autolearn_force=no version=3.4.2
Subject: [PATCH v2] PCI/switchtec: Read all 64 bits of part_event_bitmap
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 6acdf7e19b37cb3a9258603d0eab315079c19c5e upstream.

The part_event_bitmap register is 64 bits wide, so read it with ioread64()
instead of the 32-bit ioread32().

Fixes: 52eabba5bcdb ("switchtec: Add IOCTLs to the Switchtec driver")
Link: https://lore.kernel.org/r/20190910195833.3891-1-logang@deltatee.com
Reported-by: Doug Meyer <dmeyer@gigaio.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org	# v4.12+
Cc: Kelvin Cao <Kelvin.Cao@microchip.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/switch/switchtec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

v2 of this patch adds the missing header that provides readq() on
non-64bit architectures.

diff --git a/drivers/pci/switch/switchtec.c b/drivers/pci/switch/switchtec.c
index e3aefdafae89..0941555b84a5 100644
--- a/drivers/pci/switch/switchtec.c
+++ b/drivers/pci/switch/switchtec.c
@@ -23,7 +23,7 @@
 #include <linux/pci.h>
 #include <linux/cdev.h>
 #include <linux/wait.h>
-
+#include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/nospec.h>

 MODULE_DESCRIPTION("Microsemi Switchtec(tm) PCIe Management Driver");
@@ -898,7 +898,7 @@ static int ioctl_event_summary(struct switchtec_dev *stdev,
 	u32 reg;

 	s.global = ioread32(&stdev->mmio_sw_event->global_summary);
-	s.part_bitmap = ioread32(&stdev->mmio_sw_event->part_event_bitmap);
+	s.part_bitmap = readq(&stdev->mmio_sw_event->part_event_bitmap);
 	s.local_part = ioread32(&stdev->mmio_part_cfg->part_event_summary);

 	for (i = 0; i < stdev->partition_count; i++) {
--
2.20.1
