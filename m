Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E6C37FAD3
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbhEMPgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:36:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234918AbhEMPgA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:36:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37B40613BF;
        Thu, 13 May 2021 15:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620920089;
        bh=QROQ5hlsmXUD6TUTSg4rrqr+P6JTs+7Q/JvxKhHLLPY=;
        h=Subject:To:From:Date:From;
        b=YwU6rxDKBxKr3usWq4kf/8vO6I1BPIuHhFtQ3K8UeBMhnyybOfldCJfTD49CcgT5N
         cLCUW11uX3Yq0YyXx07sOa4xsAMlx9d/FBnpjUnaw4znxaX1C8eDyO5QzMY+2TygHJ
         9Z/Fikw/KRnoIYBPRA+ENbkcNIqnm6O0qUbRxnqM=
Subject: patch "Revert "video: hgafb: fix potential NULL pointer dereference"" added to char-misc-linus
To:     gregkh@linuxfoundation.org, b.zolnierkie@samsung.com,
        fero@drama.obuda.kando.hu, kjlu@umn.edu, pakki001@umn.edu,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 17:34:20 +0200
Message-ID: <1620920060132148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "video: hgafb: fix potential NULL pointer dereference"

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 58c0cc2d90f1e37c4eb63ae7f164c83830833f78 Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 3 May 2021 13:57:05 +0200
Subject: Revert "video: hgafb: fix potential NULL pointer dereference"

This reverts commit ec7f6aad57ad29e4e66cc2e18e1e1599ddb02542.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

This patch "looks" correct, but the driver keeps on running and will
fail horribly right afterward if this error condition ever trips.

So points for trying to resolve an issue, but a huge NEGATIVE value for
providing a "fake" fix for the problem as nothing actually got resolved
at all.  I'll go fix this up properly...

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Aditya Pakki <pakki001@umn.edu>
Cc: Ferenc Bakonyi <fero@drama.obuda.kando.hu>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Fixes: ec7f6aad57ad ("video: hgafb: fix potential NULL pointer dereference")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-39-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/hgafb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/video/fbdev/hgafb.c b/drivers/video/fbdev/hgafb.c
index 8bbac7182ad3..fca29f219f8b 100644
--- a/drivers/video/fbdev/hgafb.c
+++ b/drivers/video/fbdev/hgafb.c
@@ -285,8 +285,6 @@ static int hga_card_detect(void)
 	hga_vram_len  = 0x08000;
 
 	hga_vram = ioremap(0xb0000, hga_vram_len);
-	if (!hga_vram)
-		goto error;
 
 	if (request_region(0x3b0, 12, "hgafb"))
 		release_io_ports = 1;
-- 
2.31.1


