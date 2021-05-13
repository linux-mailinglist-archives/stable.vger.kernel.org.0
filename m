Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE6837FACC
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbhEMPfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:35:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234923AbhEMPf3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:35:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4136D611AC;
        Thu, 13 May 2021 15:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620920059;
        bh=pkGC05wZpDVYw1F2MtVYchvdkVVhkAv80I8SXeqxJbs=;
        h=Subject:To:From:Date:From;
        b=2hQzCUAiOTFQ2L8KTI6Jf/n9z7l54Av1EIpdvZqfTm6bxJx6P7fzDQsm0clhhzceG
         k4ZVfRKBzNCPv115BTqqott0FDc3sBg6VBr5np2nt11Tdz5TZHVxgyoNDTCN6K6U+i
         CJ9xkasAnt/bUk/kZrzsk73FqOyZemQHWsFBMzcs=
Subject: patch "ethernet: sun: niu: fix missing checks of niu_pci_eeprom_read()" added to char-misc-linus
To:     ducheng2@gmail.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, shannon.lee.nelson@gmail.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 17:34:12 +0200
Message-ID: <1620920052203212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    ethernet: sun: niu: fix missing checks of niu_pci_eeprom_read()

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e6e337708c22f80824b82d4af645f20715730ad0 Mon Sep 17 00:00:00 2001
From: Du Cheng <ducheng2@gmail.com>
Date: Mon, 3 May 2021 13:56:50 +0200
Subject: ethernet: sun: niu: fix missing checks of niu_pci_eeprom_read()

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


