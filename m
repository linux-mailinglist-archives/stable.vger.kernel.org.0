Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942DD38C771
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 15:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbhEUNF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 09:05:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231621AbhEUNFx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 09:05:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B2CE61244;
        Fri, 21 May 2021 13:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621602270;
        bh=c1yEs6KCk3BEhBzfm6fEyY+vHaNpSTMxOZ1Q2orkkMI=;
        h=Subject:To:From:Date:From;
        b=aRgoZnQM57zVppgoRdGTeAS7Ayqje+YJ/Mz784nxJ/FFMCVDstms+9b1IxtdgLQSd
         3/mbki1bfl6oAhH1rlnPakdQHZe4Ff1vOMJzU7MuBXKT1xuQ05P7vzU2mAzgM1neMp
         w0Bh5/bGVpFG11CrpQTh9L5pKP9Vzy2/n6eQDR/4=
Subject: patch "video: hgafb: correctly handle card detect failure during probe" added to char-misc-linus
To:     mail@anirudhrb.com, dan.carpenter@oracle.com,
        gregkh@linuxfoundation.org, igormtorrente@gmail.com,
        oliver.sang@intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 21 May 2021 15:04:28 +0200
Message-ID: <1621602268122200@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    video: hgafb: correctly handle card detect failure during probe

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 02625c965239b71869326dd0461615f27307ecb3 Mon Sep 17 00:00:00 2001
From: Anirudh Rayabharam <mail@anirudhrb.com>
Date: Mon, 17 May 2021 00:57:14 +0530
Subject: video: hgafb: correctly handle card detect failure during probe

The return value of hga_card_detect() is not properly handled causing
the probe to succeed even though hga_card_detect() failed. Since probe
succeeds, hgafb_open() can be called which will end up operating on an
unmapped hga_vram. This results in an out-of-bounds access as reported
by kernel test robot [1].

To fix this, correctly detect failure of hga_card_detect() by checking
for a non-zero error code.

[1]: https://lore.kernel.org/lkml/20210516150019.GB25903@xsang-OptiPlex-9020/

Fixes: dc13cac4862c ("video: hgafb: fix potential NULL pointer dereference")
Cc: stable <stable@vger.kernel.org>
Reported-by: kernel test robot <oliver.sang@intel.com>
Reviewed-by: Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20210516192714.25823-1-mail@anirudhrb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/hgafb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/hgafb.c b/drivers/video/fbdev/hgafb.c
index cc8e62ae93f6..bd3d07aa4f0e 100644
--- a/drivers/video/fbdev/hgafb.c
+++ b/drivers/video/fbdev/hgafb.c
@@ -558,7 +558,7 @@ static int hgafb_probe(struct platform_device *pdev)
 	int ret;
 
 	ret = hga_card_detect();
-	if (!ret)
+	if (ret)
 		return ret;
 
 	printk(KERN_INFO "hgafb: %s with %ldK of memory detected.\n",
-- 
2.31.1


