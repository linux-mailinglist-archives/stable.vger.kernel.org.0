Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4544971F2
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236711AbiAWOOt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:14:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56004 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236705AbiAWOOt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:14:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D209B80CF1
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF90C340E2;
        Sun, 23 Jan 2022 14:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642947286;
        bh=4OfSzFnjXE08vFy+zy88PlpYF5qMU6j3FL6BwzEF+f4=;
        h=Subject:To:Cc:From:Date:From;
        b=UIq6i9ipNzmnjFLoM98ZIiVHAkhTW8r9wWSwsCGbDHuFTGdLPHXE2CtQ4m1DW/Alu
         90MTwDlaoJYBHG817A3xWHkGv2tKqY5FVNBHJ+zWUOq7m5yhWM7/4ZmloM6EBM0zv0
         StToafzUXa+/rg6ujS6ebzYqFVEDpCWJlp/pvqB4=
Subject: FAILED: patch "[PATCH] platform/x86: amd-pmc: only use callbacks for suspend" failed to apply to 5.15-stable tree
To:     mario.limonciello@amd.com, hdegoede@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 15:14:43 +0100
Message-ID: <164294728341125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
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

