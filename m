Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D664E4971EF
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236708AbiAWOOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:14:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55920 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236705AbiAWOOd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:14:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C8ECB80CF5
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795ACC340E2;
        Sun, 23 Jan 2022 14:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642947271;
        bh=0vasEVHYkvagvJYhBL7hUP7Y7XL6CMvRkNyFdq3wt/A=;
        h=Subject:To:Cc:From:Date:From;
        b=mym/JlPCMTN6jeMo5CLTc+GzCbkoyo4VS8L2XvL0n5toPsAOr/dQTaAlbvBqRYn/O
         EWIZ/C5QEcFQMpOpiZtFtnDsi1n9U6Kv6ehBbSltwVI3bs3MCNmxAC658QBV3zpMH1
         VLE6AYFpRVnTnUujlh5XVgKIq2P6+t0NbvaduArU=
Subject: FAILED: patch "[PATCH] platform/x86: intel_pmc_core: fix memleak on registration" failed to apply to 5.10-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org, hdegoede@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 15:14:18 +0100
Message-ID: <1642947258206251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7c4f5cd18cb169a4ce8610b1696ec152d62b4820 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 22 Dec 2021 11:50:23 +0100
Subject: [PATCH] platform/x86: intel_pmc_core: fix memleak on registration
 failure

In case device registration fails during module initialisation, the
platform device structure needs to be freed using platform_device_put()
to properly free all resources (e.g. the device name).

Fixes: 938835aa903a ("platform/x86: intel_pmc_core: do not create a static struct device")
Cc: stable@vger.kernel.org      # 5.9
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20211222105023.6205-1-johan@kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>

diff --git a/drivers/platform/x86/intel/pmc/pltdrv.c b/drivers/platform/x86/intel/pmc/pltdrv.c
index 73797680b895..15ca8afdd973 100644
--- a/drivers/platform/x86/intel/pmc/pltdrv.c
+++ b/drivers/platform/x86/intel/pmc/pltdrv.c
@@ -65,7 +65,7 @@ static int __init pmc_core_platform_init(void)
 
 	retval = platform_device_register(pmc_core_device);
 	if (retval)
-		kfree(pmc_core_device);
+		platform_device_put(pmc_core_device);
 
 	return retval;
 }

