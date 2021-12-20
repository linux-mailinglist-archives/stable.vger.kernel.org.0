Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B175647AE74
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237970AbhLTPBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238985AbhLTO61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:58:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71018C061761;
        Mon, 20 Dec 2021 06:49:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 121FA611BB;
        Mon, 20 Dec 2021 14:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7190C36AE7;
        Mon, 20 Dec 2021 14:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011761;
        bh=oaHS0BAFXeaga1D93lXRlFFtUqZXNAx5WkttJn3B8OM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Owh3jGX3spsOwfrZdUiKuIZz8eAdFsNFstAyKHNDAcXWhB+W+NmflufldAjG1YeM2
         +KudhQkJSXNWr7Fd3L7lCzxB3D0OLlZkdQKzVjjjeBkOBfoJTqe0hLxUqjuBJOv0tV
         ECx1yOv5AKXkVaSt/6rZU+NijFO4Pit+NaKoVOww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jann Horn <jannh@google.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 65/99] Revert "usb: early: convert to readl_poll_timeout_atomic()"
Date:   Mon, 20 Dec 2021 15:34:38 +0100
Message-Id: <20211220143031.577633812@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit c4d936efa46d8ea183df16c0f3fa4423327da51d ]

This reverts commit 796eed4b2342c9d6b26c958e92af91253a2390e1.

This change causes boot lockups when using "arlyprintk=xdbc" because
ktime can not be used at this point in time in the boot process.  Also,
it is not needed for very small delays like this.

Reported-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Cc: Jann Horn <jannh@google.com>
Cc: Chunfeng Yun <chunfeng.yun@mediatek.com>
Fixes: 796eed4b2342 ("usb: early: convert to readl_poll_timeout_atomic()")
Link: https://lore.kernel.org/r/c2b5c9bb-1b75-bf56-3754-b5b18812d65e@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/early/xhci-dbc.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/early/xhci-dbc.c b/drivers/usb/early/xhci-dbc.c
index be4ecbabdd586..6c0434100e38c 100644
--- a/drivers/usb/early/xhci-dbc.c
+++ b/drivers/usb/early/xhci-dbc.c
@@ -14,7 +14,6 @@
 #include <linux/pci_ids.h>
 #include <linux/memblock.h>
 #include <linux/io.h>
-#include <linux/iopoll.h>
 #include <asm/pci-direct.h>
 #include <asm/fixmap.h>
 #include <linux/bcd.h>
@@ -136,9 +135,17 @@ static int handshake(void __iomem *ptr, u32 mask, u32 done, int wait, int delay)
 {
 	u32 result;
 
-	return readl_poll_timeout_atomic(ptr, result,
-					 ((result & mask) == done),
-					 delay, wait);
+	/* Can not use readl_poll_timeout_atomic() for early boot things */
+	do {
+		result = readl(ptr);
+		result &= mask;
+		if (result == done)
+			return 0;
+		udelay(delay);
+		wait -= delay;
+	} while (wait > 0);
+
+	return -ETIMEDOUT;
 }
 
 static void __init xdbc_bios_handoff(void)
-- 
2.34.1



