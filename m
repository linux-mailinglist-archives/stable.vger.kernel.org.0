Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2AC4971F3
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236712AbiAWOOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236705AbiAWOOw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:14:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B486C06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 06:14:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9ABEB80CF1
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268CEC340E2;
        Sun, 23 Jan 2022 14:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642947289;
        bh=RMGEhChgfxBx0OCmKwelZDtV5F+J7AsGBmUUbwdHQdA=;
        h=Subject:To:Cc:From:Date:From;
        b=I6BPJmxDW5OqKRDyOflRIwZs5eY841KfELi9a8gDR48sR2oWKyuuJ8ioqe3Hc4rZG
         r06NQp/cK5FDPdw8BwAqVdDgV2Vdwhue1mWLQ1yNH1J0+Fn4Q2cnlSPrqb/vM4ck5H
         UPh1Qhc6/GMAVEIpINau/qt8v6ob6xMR+TQNU5Eg=
Subject: FAILED: patch "[PATCH] platform/x86: amd-pmc: only use callbacks for suspend" failed to apply to 5.16-stable tree
To:     mario.limonciello@amd.com, hdegoede@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 15:14:44 +0100
Message-ID: <1642947284246237@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d386f7ef9f410266bc1f364ad6a11cb28dae09a8 Mon Sep 17 00:00:00 2001
From: Mario Limonciello <mario.limonciello@amd.com>
Date: Fri, 10 Dec 2021 08:35:29 -0600
Subject: [PATCH] platform/x86: amd-pmc: only use callbacks for suspend

This driver is intended to be used exclusively for suspend to idle
so callbacks to send OS_HINT during hibernate and S5 will set OS_HINT
at the wrong time leading to an undefined behavior.

Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20211210143529.10594-1-mario.limonciello@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>

diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pmc.c
index c709ff993e8b..f794343d6aaa 100644
--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -585,7 +585,8 @@ static int __maybe_unused amd_pmc_resume(struct device *dev)
 }
 
 static const struct dev_pm_ops amd_pmc_pm_ops = {
-	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(amd_pmc_suspend, amd_pmc_resume)
+	.suspend_noirq = amd_pmc_suspend,
+	.resume_noirq = amd_pmc_resume,
 };
 
 static const struct pci_device_id pmc_pci_ids[] = {

