Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0973949CA70
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 14:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbiAZNLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 08:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234995AbiAZNLg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 08:11:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC94C06161C
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 05:11:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDB9960AF9
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 13:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7D6C340E3;
        Wed, 26 Jan 2022 13:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643202695;
        bh=TME6f5735nlSkysF1CdcrcNeGidMdqptq3/MuzcpRNU=;
        h=Subject:To:From:Date:From;
        b=Ko6XIjxU9DZ1UYZGq52GNNl1SHf5I/ZOfXij7ko4rd+ge5Qqx6R9xhSA3/Q8mzM9Q
         BLLVoB0+JkTYXeIAtuGuxFfe/XE4rjBOOuTHJC2GAu/oAO6li+YUrqXNFSjct7GsS+
         zSs1LXQ9AkQGuMsH/kbvIl4JKuqaN3SupUbg2WEw=
Subject: patch "usb: cdnsp: Fix segmentation fault in cdns_lost_power function" added to usb-linus
To:     pawell@cadence.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Jan 2022 14:11:32 +0100
Message-ID: <1643202692183120@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdnsp: Fix segmentation fault in cdns_lost_power function

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 79aa3e19fe8f5be30e846df8a436bfe306e8b1a6 Mon Sep 17 00:00:00 2001
From: Pawel Laszczak <pawell@cadence.com>
Date: Tue, 11 Jan 2022 10:07:37 +0100
Subject: usb: cdnsp: Fix segmentation fault in cdns_lost_power function

CDNSP driver read not initialized cdns->otg_v0_regs
which lead to segmentation fault. Patch fixes this issue.

Fixes: 2cf2581cd229 ("usb: cdns3: add power lost support for system resume")
cc: <stable@vger.kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20220111090737.10345-1-pawell@gli-login.cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/drd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/cdns3/drd.c b/drivers/usb/cdns3/drd.c
index 55c73b1d8704..d00ff98dffab 100644
--- a/drivers/usb/cdns3/drd.c
+++ b/drivers/usb/cdns3/drd.c
@@ -483,11 +483,11 @@ int cdns_drd_exit(struct cdns *cdns)
 /* Indicate the cdns3 core was power lost before */
 bool cdns_power_is_lost(struct cdns *cdns)
 {
-	if (cdns->version == CDNS3_CONTROLLER_V1) {
-		if (!(readl(&cdns->otg_v1_regs->simulate) & BIT(0)))
+	if (cdns->version == CDNS3_CONTROLLER_V0) {
+		if (!(readl(&cdns->otg_v0_regs->simulate) & BIT(0)))
 			return true;
 	} else {
-		if (!(readl(&cdns->otg_v0_regs->simulate) & BIT(0)))
+		if (!(readl(&cdns->otg_v1_regs->simulate) & BIT(0)))
 			return true;
 	}
 	return false;
-- 
2.35.0


