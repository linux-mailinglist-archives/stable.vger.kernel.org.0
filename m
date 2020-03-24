Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D54C1905A4
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 07:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgCXGVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 02:21:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbgCXGVL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 02:21:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBF7E2073E;
        Tue, 24 Mar 2020 06:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585030871;
        bh=ngavZve41g+9oP2InKwVbg8PKuwt/mY/0KOBFNawSXI=;
        h=Subject:To:From:Date:From;
        b=OYl1fxcX0p231S9/LbU2ASud0R2UzsXo5Kfht/7EFNYY3yHxel+9fCi4w0e8luonD
         mVqEtWS/w0nqW5iPITkniZgbgq2W4VXNa+ANI4rM7eVGBdUUBzpOoEknhoKVGqKAkd
         uGfwVPunr/Cd7HcpVDnoUBdTG8ylH89Mw1xLy6DU=
Subject: patch "nvmem: sprd: Fix the block lock operation" added to char-misc-next
To:     freeman.liu@unisoc.com, baolin.wang7@gmail.com,
        gregkh@linuxfoundation.org, srinivas.kandagatla@linaro.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 24 Mar 2020 07:18:34 +0100
Message-ID: <158503071476241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    nvmem: sprd: Fix the block lock operation

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From c66ebde4d988b592e8f0008e04c47cc4950a49d3 Mon Sep 17 00:00:00 2001
From: Freeman Liu <freeman.liu@unisoc.com>
Date: Mon, 23 Mar 2020 15:00:03 +0000
Subject: nvmem: sprd: Fix the block lock operation

According to the Spreadtrum eFuse specification, we should write 0 to
the block to trigger the lock operation.

Fixes: 096030e7f449 ("nvmem: sprd: Add Spreadtrum SoCs eFuse support")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Freeman Liu <freeman.liu@unisoc.com>
Signed-off-by: Baolin Wang <baolin.wang7@gmail.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20200323150007.7487-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/sprd-efuse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvmem/sprd-efuse.c b/drivers/nvmem/sprd-efuse.c
index 2f1e0fbd1901..7a189ef52333 100644
--- a/drivers/nvmem/sprd-efuse.c
+++ b/drivers/nvmem/sprd-efuse.c
@@ -239,7 +239,7 @@ static int sprd_efuse_raw_prog(struct sprd_efuse *efuse, u32 blk, bool doub,
 		ret = -EBUSY;
 	} else {
 		sprd_efuse_set_prog_lock(efuse, lock);
-		writel(*data, efuse->base + SPRD_EFUSE_MEM(blk));
+		writel(0, efuse->base + SPRD_EFUSE_MEM(blk));
 		sprd_efuse_set_prog_lock(efuse, false);
 	}
 
-- 
2.25.2


