Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9F33A9E8E
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234447AbhFPPId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:08:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234445AbhFPPIb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:08:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45798600EF;
        Wed, 16 Jun 2021 15:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623855985;
        bh=pSXJDGlv63s0nm+bKJEHXvtYz1xyOzdiAFiZfKn9uiw=;
        h=Subject:To:From:Date:From;
        b=2MCZmat1W/C8sYIj6dGDYSTZ+DIOzZ4/YRY0QAMMb5Hx430ySwsnt0FseTW3h49tK
         SWf6g4jKsycPKLKmxjBV1HEZKRnBPLn/w/AAOBPxiRBPEmZhtmBPnZ0YGzIYUJHXXY
         WAlY6Y1UIt3t3qPHNLMNWBXhmh1bQ82g9D3fatQc=
Subject: patch "fpga: stratix10-soc: Add missing fpga_mgr_free() call" added to char-misc-next
To:     russell.h.weight@intel.com, gregkh@linuxfoundation.org,
        mdf@kernel.org, stable@vger.kernel.org, yilun.xu@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 16 Jun 2021 17:06:21 +0200
Message-ID: <162385598150236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    fpga: stratix10-soc: Add missing fpga_mgr_free() call

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From d9ec9daa20eb8de1efe6abae78c9835ec8ed86f9 Mon Sep 17 00:00:00 2001
From: Russ Weight <russell.h.weight@intel.com>
Date: Mon, 14 Jun 2021 10:09:03 -0700
Subject: fpga: stratix10-soc: Add missing fpga_mgr_free() call

The stratix10-soc driver uses fpga_mgr_create() function and is therefore
responsible to call fpga_mgr_free() to release the class driver resources.
Add a missing call to fpga_mgr_free in the s10_remove() function.

Signed-off-by: Russ Weight <russell.h.weight@intel.com>
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Moritz Fischer <mdf@kernel.org>
Fixes: e7eef1d7633a ("fpga: add intel stratix10 soc fpga manager driver")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210614170909.232415-3-mdf@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/stratix10-soc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/fpga/stratix10-soc.c b/drivers/fpga/stratix10-soc.c
index 2aeb53f8e9d0..a2cea500f7cc 100644
--- a/drivers/fpga/stratix10-soc.c
+++ b/drivers/fpga/stratix10-soc.c
@@ -454,6 +454,7 @@ static int s10_remove(struct platform_device *pdev)
 	struct s10_priv *priv = mgr->priv;
 
 	fpga_mgr_unregister(mgr);
+	fpga_mgr_free(mgr);
 	stratix10_svc_free_channel(priv->chan);
 
 	return 0;
-- 
2.32.0


