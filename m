Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039DC38ED31
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbhEXPex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:34:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233234AbhEXPdb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:33:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69ED0613DB;
        Mon, 24 May 2021 15:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870264;
        bh=Wcu1d9Mug0WrHSlaZvr6VdvPqy1pPkbAFqQgwV4UK3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F3ChjgpT9iTsNcc+Sf9ONPocmUSG74HHiFOTe9twj9vokLT+73vF1li9YZw9pofwp
         WWeJE328Ty7LFYU8uOJ8WmSyVh55UkXqVy3BCq4H8YPi9QG/OUlZ+7AOT73ClcoVus
         rSgrr3tDz1FzWKEYnPdNURQHuE57LGpoFXU/LKFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Du Cheng <ducheng2@gmail.com>,
        Shannon Nelson <shannon.lee.nelson@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 23/31] ethernet: sun: niu: fix missing checks of niu_pci_eeprom_read()
Date:   Mon, 24 May 2021 17:25:06 +0200
Message-Id: <20210524152323.681213510@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152322.919918360@linuxfoundation.org>
References: <20210524152322.919918360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Du Cheng <ducheng2@gmail.com>

commit e6e337708c22f80824b82d4af645f20715730ad0 upstream.

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
Link: https://lore.kernel.org/r/20210503115736.2104747-24-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sun/niu.c |   34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -8119,6 +8119,8 @@ static int niu_pci_vpd_scan_props(struct
 		start += 3;
 
 		prop_len = niu_pci_eeprom_read(np, start + 4);
+		if (prop_len < 0)
+			return prop_len;
 		err = niu_pci_vpd_get_propname(np, start + 5, namebuf, 64);
 		if (err < 0)
 			return err;
@@ -8163,8 +8165,12 @@ static int niu_pci_vpd_scan_props(struct
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
@@ -8174,14 +8180,14 @@ static int niu_pci_vpd_scan_props(struct
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
 
@@ -8190,12 +8196,14 @@ static void niu_pci_vpd_fetch(struct niu
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
@@ -8203,9 +8211,12 @@ static void niu_pci_vpd_fetch(struct niu
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
@@ -9298,8 +9309,11 @@ static int niu_get_invariants(struct niu
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


