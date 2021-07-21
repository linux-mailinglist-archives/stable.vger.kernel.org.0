Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0E63D11AE
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 16:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbhGUON3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 10:13:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239299AbhGUON2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 10:13:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5234F61245;
        Wed, 21 Jul 2021 14:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626879244;
        bh=PWwe9/KwYeb/EUi0rOsgG9DcygED/OjA81VU93PhZ+8=;
        h=Subject:To:From:Date:From;
        b=pxXYhJujSI3L75psMYrRlv+37nT6lvjto8yQ++gI2MkGOQVZ2Fh3Qm37i2MOIf7Cf
         zFr4h3kH3XDe8NT63o/9XqM1EOWwzzTJ1vMiSmnqkx549wrrBHXE3OoZGgam/g0sA/
         WfAkktT49KiP0dwOvxBowA1fj70zqw9rHKf5k040=
Subject: patch "driver core: auxiliary bus: Fix memory leak when driver_register()" added to driver-core-linus
To:     peter.ujfalusi@linux.intel.com, dan.j.williams@intel.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 21 Jul 2021 16:54:02 +0200
Message-ID: <1626879242215223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    driver core: auxiliary bus: Fix memory leak when driver_register()

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4afa0c22eed33cfe0c590742387f0d16f32412f3 Mon Sep 17 00:00:00 2001
From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Date: Tue, 13 Jul 2021 12:34:38 +0300
Subject: driver core: auxiliary bus: Fix memory leak when driver_register()
 fail

If driver_register() returns with error we need to free the memory
allocated for auxdrv->driver.name before returning from
__auxiliary_driver_register()

Fixes: 7de3697e9cbd4 ("Add auxiliary bus support")
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20210713093438.3173-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/auxiliary.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/base/auxiliary.c b/drivers/base/auxiliary.c
index adc199dfba3c..6a30264ab2ba 100644
--- a/drivers/base/auxiliary.c
+++ b/drivers/base/auxiliary.c
@@ -231,6 +231,8 @@ EXPORT_SYMBOL_GPL(auxiliary_find_device);
 int __auxiliary_driver_register(struct auxiliary_driver *auxdrv,
 				struct module *owner, const char *modname)
 {
+	int ret;
+
 	if (WARN_ON(!auxdrv->probe) || WARN_ON(!auxdrv->id_table))
 		return -EINVAL;
 
@@ -246,7 +248,11 @@ int __auxiliary_driver_register(struct auxiliary_driver *auxdrv,
 	auxdrv->driver.bus = &auxiliary_bus_type;
 	auxdrv->driver.mod_name = modname;
 
-	return driver_register(&auxdrv->driver);
+	ret = driver_register(&auxdrv->driver);
+	if (ret)
+		kfree(auxdrv->driver.name);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(__auxiliary_driver_register);
 
-- 
2.32.0


