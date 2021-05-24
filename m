Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C62C38ED1C
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbhEXPdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:33:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233282AbhEXPcm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:32:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 436E6613D6;
        Mon, 24 May 2021 15:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870262;
        bh=JcxVFKDU4gEX9O9BbO2qPk70r7MNtDFiSttP3s94KYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D1eKWlCUAm2E15my9kJREsYg6U02YyKcKUS7YrNTUw639nIUFI4OFky8Rw5HCSeTM
         RiTjxwGgDRFLCEd3KRgFMKZye8NzDGVMk3AGo/6qlmQgbKFDUo3EHd8DSYAS1+qF1m
         IE7rUVHpA0m6+CfHdWkDjUg/mIcmX7A4P7QzoO/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Shannon Nelson <shannon.lee.nelson@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 22/31] Revert "niu: fix missing checks of niu_pci_eeprom_read"
Date:   Mon, 24 May 2021 17:25:05 +0200
Message-Id: <20210524152323.645739342@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 7930742d6a0ff091c85b92ef4e076432d8d8cb79 upstream.

This reverts commit 26fd962bde0b15e54234fe762d86bc0349df1de4.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The change here was incorrect.  While it is nice to check if
niu_pci_eeprom_read() succeeded or not when using the data, any error
that might have happened was not propagated upwards properly, causing
the kernel to assume that these reads were successful, which results in
invalid data in the buffer that was to contain the successfully read
data.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Shannon Nelson <shannon.lee.nelson@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Fixes: 26fd962bde0b ("niu: fix missing checks of niu_pci_eeprom_read")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-23-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sun/niu.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -8119,8 +8119,6 @@ static int niu_pci_vpd_scan_props(struct
 		start += 3;
 
 		prop_len = niu_pci_eeprom_read(np, start + 4);
-		if (prop_len < 0)
-			return prop_len;
 		err = niu_pci_vpd_get_propname(np, start + 5, namebuf, 64);
 		if (err < 0)
 			return err;
@@ -8165,12 +8163,8 @@ static int niu_pci_vpd_scan_props(struct
 			netif_printk(np, probe, KERN_DEBUG, np->dev,
 				     "VPD_SCAN: Reading in property [%s] len[%d]\n",
 				     namebuf, prop_len);
-			for (i = 0; i < prop_len; i++) {
-				err = niu_pci_eeprom_read(np, off + i);
-				if (err >= 0)
-					*prop_buf = err;
-				++prop_buf;
-			}
+			for (i = 0; i < prop_len; i++)
+				*prop_buf++ = niu_pci_eeprom_read(np, off + i);
 		}
 
 		start += len;


