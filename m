Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9D43714B7
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 14:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbhECMAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 08:00:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233608AbhECMAR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 08:00:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E884061278;
        Mon,  3 May 2021 11:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620043164;
        bh=73VzYlz/1SbBx7J36/SZlSRuTOcNuBkD3rlnJCI1wUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zK1YN8aum9ilnjNUc823dk2EkRzGOHtkxQmHwWZmhKD6VyYwllTr390XWyr45YbUe
         daIZV8rWrz1BYTiK6eVkFdjvldnrTg3BPMCuxlM8frlFy1e3avVG5C38WPtKVKa4Xf
         0toJytobyk3bbFuevXkF7GMfVWDxxaveR5hQSlGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>,
        Shannon Nelson <shannon.lee.nelson@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 22/69] Revert "niu: fix missing checks of niu_pci_eeprom_read"
Date:   Mon,  3 May 2021 13:56:49 +0200
Message-Id: <20210503115736.2104747-23-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sun/niu.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 707ccdd03b19..d70cdea756d1 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -8097,8 +8097,6 @@ static int niu_pci_vpd_scan_props(struct niu *np, u32 start, u32 end)
 		start += 3;
 
 		prop_len = niu_pci_eeprom_read(np, start + 4);
-		if (prop_len < 0)
-			return prop_len;
 		err = niu_pci_vpd_get_propname(np, start + 5, namebuf, 64);
 		if (err < 0)
 			return err;
@@ -8143,12 +8141,8 @@ static int niu_pci_vpd_scan_props(struct niu *np, u32 start, u32 end)
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
-- 
2.31.1

