Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE794971EE
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236710AbiAWOOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:14:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55912 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236705AbiAWOOa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:14:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B261B80CF0
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C0BC340E2;
        Sun, 23 Jan 2022 14:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642947268;
        bh=tNBL1yFQ4wCShY6Ojbl3BsfRa6zGtQq02RljTV3Hn9g=;
        h=Subject:To:Cc:From:Date:From;
        b=i4ACQBqQDyYpwDsAmwtGS6z+n0cg2t+YdrvOd7jhQU0iOv5v4404pBdii2Ybfa3rF
         R79AJIavXHykaS3A4cQfjyPH17EtjTLdR8/AvWLfyWop6k/TuPgXvT0k+OelaOEi1p
         Vi0WmpqxL8RYE8UaLFgUcni+yEyGbezXiOUZNIkk=
Subject: FAILED: patch "[PATCH] platform/x86: intel_pmc_core: fix memleak on registration" failed to apply to 5.15-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org, hdegoede@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 15:14:17 +0100
Message-ID: <1642947257232202@kroah.com>
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

