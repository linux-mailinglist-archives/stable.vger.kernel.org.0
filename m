Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0963714B8
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 14:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbhECMA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 08:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233527AbhECMAU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 08:00:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55CB76127A;
        Mon,  3 May 2021 11:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620043166;
        bh=iB+97Pz4ESnaMRp2W+AYh/9PT653VTU0bZ+ASzxl26c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZR+rAkQfHLusGUytZbu6T2EjtG/ZFkhz3qZx6Sl3BgY63ANObQuNiT47L9/IZSjn
         LUHjIrUIcX51DQUS/TS8/FyGaHMImOvcwcgtmxkZcJWcRdPpvnpfhyJ2dTUNCGoxm/
         7MAoKyz33W6m0cHPTEPlgpNIVAx6zbhdrCR3xC94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Du Cheng <ducheng2@gmail.com>,
        Shannon Nelson <shannon.lee.nelson@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 23/69] ethernet: sun: niu: fix missing checks of niu_pci_eeprom_read()
Date:   Mon,  3 May 2021 13:56:50 +0200
Message-Id: <20210503115736.2104747-24-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Du Cheng <ducheng2@gmail.com>

niu_pci_eeprom_read() may fail, so add checks to its return value and
propagate the error up the callstack.

An examination of the callstack up to niu_pci_eeprom_read shows that:

niu_pci_eeprom_read() // returns int
    niu_pci_vpd_scan_props() // returns int
        niu_pci_vpd_fetch() // returns *void*
            niu_get_invariants() // returns int

since niu_pci_vpd_fetch() returns void which breaks the bubbling up,
change its return type to int so that error is propagated upwards.

Signed-off-by: Du Cheng <ducheng2@gmail.com>
Cc: Shannon Nelson <shannon.lee.nelson@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sun/niu.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index d70cdea756d1..74e748662ec0 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -8097,6 +8097,8 @@ static int niu_pci_vpd_scan_props(struct niu *np, u32 start, u32 end)
 		start += 3;
 
 		prop_len = niu_pci_eeprom_read(np, start + 4);
+		if (prop_len < 0)
+			return prop_len;
 		err = niu_pci_vpd_get_propname(np, start + 5, namebuf, 64);
 		if (err < 0)
 			return err;
@@ -8141,8 +8143,12 @@ static int niu_pci_vpd_scan_props(struct niu *np, u32 start, u32 end)
 			netif_printk(np, probe, KERN_DEBUG, np->dev,
 				     "VPD_SCAN: Reading in property [%s] len[%d]\n",
 				     namebuf, prop_len);
-			for (i = 0; i < prop_len; i++)
-				*prop_buf++ = niu_pci_eeprom_read(np, off + i);
+			for (i = 0; i < prop_len; i++) {
+				err =  niu_pci_eeprom_read(np, off + i);
+				if (err < 0)
+					return err;
+				*prop_buf++ = err;
+			}
 		}
 
 		start += len;
@@ -8152,14 +8158,14 @@ static int niu_pci_vpd_scan_props(struct niu *np, u32 start, u32 end)
 }
 
 /* ESPC_PIO_EN_ENABLE must be set */
-static void niu_pci_vpd_fetch(struct niu *np, u32 start)
+static int niu_pci_vpd_fetch(struct niu *np, u32 start)
 {
 	u32 offset;
 	int err;
 
 	err = niu_pci_eeprom_read16_swp(np, start + 1);
 	if (err < 0)
-		return;
+		return err;
 
 	offset = err + 3;
 
@@ -8168,12 +8174,14 @@ static void niu_pci_vpd_fetch(struct niu *np, u32 start)
 		u32 end;
 
 		err = niu_pci_eeprom_read(np, here);
+		if (err < 0)
+			return err;
 		if (err != 0x90)
-			return;
+			return -EINVAL;
 
 		err = niu_pci_eeprom_read16_swp(np, here + 1);
 		if (err < 0)
-			return;
+			return err;
 
 		here = start + offset + 3;
 		end = start + offset + err;
@@ -8181,9 +8189,12 @@ static void niu_pci_vpd_fetch(struct niu *np, u32 start)
 		offset += err;
 
 		err = niu_pci_vpd_scan_props(np, here, end);
-		if (err < 0 || err == 1)
-			return;
+		if (err < 0)
+			return err;
+		if (err == 1)
+			return -EINVAL;
 	}
+	return 0;
 }
 
 /* ESPC_PIO_EN_ENABLE must be set */
@@ -9274,8 +9285,11 @@ static int niu_get_invariants(struct niu *np)
 		offset = niu_pci_vpd_offset(np);
 		netif_printk(np, probe, KERN_DEBUG, np->dev,
 			     "%s() VPD offset [%08x]\n", __func__, offset);
-		if (offset)
-			niu_pci_vpd_fetch(np, offset);
+		if (offset) {
+			err = niu_pci_vpd_fetch(np, offset);
+			if (err < 0)
+				return err;
+		}
 		nw64(ESPC_PIO_EN, 0);
 
 		if (np->flags & NIU_FLAGS_VPD_VALID) {
-- 
2.31.1

