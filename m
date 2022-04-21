Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23BAF50A58F
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 18:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiDUQgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 12:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiDUQgR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 12:36:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1110E3B3CC
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 09:33:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A002A61D5B
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 16:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF21C385AA;
        Thu, 21 Apr 2022 16:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650558805;
        bh=r/AuHhNBb2APuc70tFynpNaJvWU6anBaVvyonuQXPNo=;
        h=Subject:To:From:Date:From;
        b=F6bG3DlfSSAQMncVdgjIttP+hFIb2fErud6MSQdjZGrzlcyLF+0Io9mfZdSYSEoL2
         C68elTh8j0go5vEtkYF7KyoRLbpzxrNKTkNj1iNmb5oR0Fbcr2H5HBiLC9vr4oHDm4
         4NP5Ph5D7Za7TlkpMEEaAdKe6Pe1rFzSlt95rYeU=
Subject: patch "usb: xhci: tegra:Fix PM usage reference leak of" added to usb-linus
To:     zhangqilong3@huawei.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 21 Apr 2022 18:33:21 +0200
Message-ID: <16505588011639@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: xhci: tegra:Fix PM usage reference leak of

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 8771039482d965bdc8cefd972bcabac2b76944a8 Mon Sep 17 00:00:00 2001
From: zhangqilong <zhangqilong3@huawei.com>
Date: Sat, 19 Mar 2022 10:38:22 +0800
Subject: usb: xhci: tegra:Fix PM usage reference leak of
 tegra_xusb_unpowergate_partitions

pm_runtime_get_sync will increment pm usage counter
even it failed. Forgetting to putting operation will
result in reference leak here. We fix it by replacing
it with pm_runtime_resume_and_get to keep usage counter
balanced.

Fixes: 41a7426d25fa ("usb: xhci: tegra: Unlink power domain devices")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20220319023822.145641-1-zhangqilong3@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-tegra.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-tegra.c b/drivers/usb/host/xhci-tegra.c
index c8af2cd2216d..996958a6565c 100644
--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -1034,13 +1034,13 @@ static int tegra_xusb_unpowergate_partitions(struct tegra_xusb *tegra)
 	int rc;
 
 	if (tegra->use_genpd) {
-		rc = pm_runtime_get_sync(tegra->genpd_dev_ss);
+		rc = pm_runtime_resume_and_get(tegra->genpd_dev_ss);
 		if (rc < 0) {
 			dev_err(dev, "failed to enable XUSB SS partition\n");
 			return rc;
 		}
 
-		rc = pm_runtime_get_sync(tegra->genpd_dev_host);
+		rc = pm_runtime_resume_and_get(tegra->genpd_dev_host);
 		if (rc < 0) {
 			dev_err(dev, "failed to enable XUSB Host partition\n");
 			pm_runtime_put_sync(tegra->genpd_dev_ss);
-- 
2.36.0


