Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6890CED970
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 07:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbfKDG54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 01:57:56 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46472 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfKDG54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 01:57:56 -0500
Received: by mail-pf1-f193.google.com with SMTP id 193so10221199pfc.13;
        Sun, 03 Nov 2019 22:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5e303ed1MF4p7zVkraxYDUxrGD23hQsLGv9jCmd4szc=;
        b=LNARHNUHLOP+RJTqasVXtMjn6XIvB9yyy445v5o5VpGuhGCOIxrcDD9oHRF4vQbWD5
         OS6d0rgPERnaAK30Pd4WTdTu3J7qWtxHfFeosfzLSOyJP8FhWl9U7oI8HqTzvt0x6Bax
         oJXeNi6gzv7uhY5k68AYKsjNmky3jiBmhk3FcffSHIoRLi9TWkOE3gGD7NDqupA3/3fe
         WU/QCdn4qB5oFC3uu5UMXojl08lWKuVxVXP+6X/xjO/GzVWt4v1DTf6zVqDvTRcSYAWf
         Hy3QOC609QswdAlhQ9w2LkEHv0Lca9q8qzeU+VOzgEplB/ZekO8h/OqWgka2kqculkMB
         YzVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5e303ed1MF4p7zVkraxYDUxrGD23hQsLGv9jCmd4szc=;
        b=gk2R7NEpgFDAVUp0Bu9lTCDjf604N4fdlanfJY0yhmZ12u4ia975b175MS3QVobyns
         Ikz3mBLVTMfTri4vyicZqZBo702UxKCVSnUCOd63zH0yGjRhm/HejIYCN8JxxjCNhCkw
         pz5BtjU9i6VRa0wnJArAECE1HXlei4NndqVJMkqShhugawVPb6AzbbF6sXVS37mKmzbs
         +FskVl18+EiiTLKDYuTwgYhheoG3fmZ2+397lFRhBoEnTkG93LIVilGHzY4tb4IyI/fs
         YPh8eFZN/ixstBhchYMxlDCE64zmy6T9b8CVOTA9/2584ALgUHDd7/me+ectArmBN5mE
         2o+w==
X-Gm-Message-State: APjAAAV68YDqZFBsn8zaUO4xb/ZNv6AruF3lUcgm1CQ3KjGuIfRuMkyl
        bGu8vbQQH/tCXwrUydZHv4a5+/b0
X-Google-Smtp-Source: APXvYqxKyigsdF6rPBjZQuLRna36jaAVhqAT5919gQ7ng0TPscOhYbvhrnxCplXPxVgsS6CkiJckow==
X-Received: by 2002:a62:18d8:: with SMTP id 207mr19844761pfy.15.1572850675242;
        Sun, 03 Nov 2019 22:57:55 -0800 (PST)
Received: from hyd1358.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id x9sm19154497pje.27.2019.11.03.22.57.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 03 Nov 2019 22:57:54 -0800 (PST)
From:   sundeep.lkml@gmail.com
To:     helgaas@kernel.org, bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, sgoutham@marvell.com,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [v2 PATCH] PCI: Do not use bus number zero from EA capability
Date:   Mon,  4 Nov 2019 12:27:44 +0530
Message-Id: <1572850664-9861-1-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

As per the spec, "Enhanced Allocation (EA) for Memory
and I/O Resources" ECN, approved 23 October 2014,
sec 6.9.1.2, fixed bus numbers of a bridge must be zero
when no function that uses EA is located behind it.
Hence assign bus numbers normally instead of assigning
zeroes from EA capability. Failing to do this and using
zeroes from EA would make the bridges non-functional.

Fixes: '2dbce5901179 ("PCI: Assign bus numbers present in
EA capability for bridges")'
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Cc: stable@vger.kernel.org	# v5.2+
---
 drivers/pci/probe.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 3d5271a..116b276 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1090,27 +1090,28 @@ static unsigned int pci_scan_child_bus_extend(struct pci_bus *bus,
  * @sub: updated with subordinate bus number from EA
  *
  * If @dev is a bridge with EA capability, update @sec and @sub with
- * fixed bus numbers from the capability and return true.  Otherwise,
- * return false.
+ * fixed bus numbers from the capability. Otherwise @sec and @sub
+ * will be zeroed.
  */
-static bool pci_ea_fixed_busnrs(struct pci_dev *dev, u8 *sec, u8 *sub)
+static void pci_ea_fixed_busnrs(struct pci_dev *dev, u8 *sec, u8 *sub)
 {
 	int ea, offset;
 	u32 dw;
 
+	*sec = *sub = 0;
+
 	if (dev->hdr_type != PCI_HEADER_TYPE_BRIDGE)
-		return false;
+		return;
 
 	/* find PCI EA capability in list */
 	ea = pci_find_capability(dev, PCI_CAP_ID_EA);
 	if (!ea)
-		return false;
+		return;
 
 	offset = ea + PCI_EA_FIRST_ENT;
 	pci_read_config_dword(dev, offset, &dw);
 	*sec =  dw & PCI_EA_SEC_BUS_MASK;
 	*sub = (dw & PCI_EA_SUB_BUS_MASK) >> PCI_EA_SUB_BUS_SHIFT;
-	return true;
 }
 
 /*
@@ -1146,7 +1147,6 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 	u16 bctl;
 	u8 primary, secondary, subordinate;
 	int broken = 0;
-	bool fixed_buses;
 	u8 fixed_sec, fixed_sub;
 	int next_busnr;
 
@@ -1249,11 +1249,12 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 		pci_write_config_word(dev, PCI_STATUS, 0xffff);
 
 		/* Read bus numbers from EA Capability (if present) */
-		fixed_buses = pci_ea_fixed_busnrs(dev, &fixed_sec, &fixed_sub);
-		if (fixed_buses)
+		pci_ea_fixed_busnrs(dev, &fixed_sec, &fixed_sub);
+
+		next_busnr = max + 1;
+		/* Use secondary bus number in EA */
+		if (fixed_sec)
 			next_busnr = fixed_sec;
-		else
-			next_busnr = max + 1;
 
 		/*
 		 * Prevent assigning a bus number that already exists.
@@ -1331,7 +1332,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 		 * If fixed subordinate bus number exists from EA
 		 * capability then use it.
 		 */
-		if (fixed_buses)
+		if (fixed_sub)
 			max = fixed_sub;
 		pci_bus_update_busn_res_end(child, max);
 		pci_write_config_byte(dev, PCI_SUBORDINATE_BUS, max);
-- 
2.7.4

