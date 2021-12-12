Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F879471AAD
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 15:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhLLOXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 09:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbhLLOXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 09:23:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F09C061714
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 06:23:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E6A5B80D17
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 14:23:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66B7C341C6;
        Sun, 12 Dec 2021 14:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639319018;
        bh=AytKpmODB1A4/oudwsOkSqS/ROFlwVLZlACQmm3Bz+M=;
        h=Subject:To:Cc:From:Date:From;
        b=fNzvpEnKzyeP+BFbV6Rr2GfQubMOTx0dtB2orsQosC9hF+bbVcKKtsYNBq0TVG8Wm
         PsuWB4AKebV9ZcBvwDa1oJAjtiJ9rEojUC21iCt+KKq4W4anaIR8Fmr4dvsTBUOwmu
         119jQpx53SriWRfUcXS1POVeu1c0FGPx1y73GjLE=
Subject: FAILED: patch "[PATCH] hwmon: (dell-smm) Fix warning on /proc/i8k creation error" failed to apply to 4.4-stable tree
To:     W_Armin@gmx.de, linux@roeck-us.net, pali@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 12 Dec 2021 15:23:35 +0100
Message-ID: <163931901519118@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dbd3e6eaf3d813939b28e8a66e29d81cdc836445 Mon Sep 17 00:00:00 2001
From: Armin Wolf <W_Armin@gmx.de>
Date: Fri, 12 Nov 2021 18:14:40 +0100
Subject: [PATCH] hwmon: (dell-smm) Fix warning on /proc/i8k creation error
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The removal function is called regardless of whether
/proc/i8k was created successfully or not, the later
causing a WARN() on module removal.
Fix that by only registering the removal function
if /proc/i8k was created successfully.

Tested on a Inspiron 3505.

Fixes: 039ae58503f3 ("hwmon: Allow to compile dell-smm-hwmon driver without /proc/i8k")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Acked-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20211112171440.59006-1-W_Armin@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>

diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
index eaace478f508..5596c211f38d 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -627,10 +627,9 @@ static void __init i8k_init_procfs(struct device *dev)
 {
 	struct dell_smm_data *data = dev_get_drvdata(dev);
 
-	/* Register the proc entry */
-	proc_create_data("i8k", 0, NULL, &i8k_proc_ops, data);
-
-	devm_add_action_or_reset(dev, i8k_exit_procfs, NULL);
+	/* Only register exit function if creation was successful */
+	if (proc_create_data("i8k", 0, NULL, &i8k_proc_ops, data))
+		devm_add_action_or_reset(dev, i8k_exit_procfs, NULL);
 }
 
 #else

