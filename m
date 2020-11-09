Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F702AC26D
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 18:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730565AbgKIRe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 12:34:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:39242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729879AbgKIRe5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 12:34:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 821D42083B;
        Mon,  9 Nov 2020 17:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604943297;
        bh=WOz2r84zuf/e0rPpEQJrjhamEinApEVHUzULldZlnUY=;
        h=Subject:To:From:Date:From;
        b=Ly4Cg6FrHaF8mh6vwcTq4hGPbJ2oQXqmeeHveKHXoMk5rv//bZkSfzX9VS21FDYmp
         X7pPpUBJ0AR8RbEj+rDi89L/OJxn/wnqNaLXDGEYeaSBznBsmHNYoU/MtE/Xnth/rc
         cpi73m825NPGEpwzQ0l57DJgyN6OOmXJfNNyZbyI=
Subject: patch "firmware: xilinx: fix out-of-bounds access" added to char-misc-linus
To:     arnd@arndb.de, gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Nov 2020 18:35:55 +0100
Message-ID: <1604943355780@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    firmware: xilinx: fix out-of-bounds access

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f3217d6f2f7a76b36a3326ad58c8897f4d5fbe31 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 26 Oct 2020 16:54:36 +0100
Subject: firmware: xilinx: fix out-of-bounds access

The zynqmp_pm_set_suspend_mode() and zynqmp_pm_get_trustzone_version()
functions pass values as api_id into zynqmp_pm_invoke_fn
that are beyond PM_API_MAX, resulting in an out-of-bounds access:

drivers/firmware/xilinx/zynqmp.c: In function 'zynqmp_pm_set_suspend_mode':
drivers/firmware/xilinx/zynqmp.c:150:24: warning: array subscript 2562 is above array bounds of 'u32[64]' {aka 'unsigned int[64]'} [-Warray-bounds]
  150 |  if (zynqmp_pm_features[api_id] != PM_FEATURE_UNCHECKED)
      |      ~~~~~~~~~~~~~~~~~~^~~~~~~~
drivers/firmware/xilinx/zynqmp.c:28:12: note: while referencing 'zynqmp_pm_features'
   28 | static u32 zynqmp_pm_features[PM_API_MAX];
      |            ^~~~~~~~~~~~~~~~~~

Replace the resulting undefined behavior with an error return.
This may break some things that happen to work at the moment
but seems better than randomly overwriting kernel data.

I assume we need additional fixes for the two functions that now
return an error.

Fixes: 76582671eb5d ("firmware: xilinx: Add Zynqmp firmware driver")
Fixes: e178df31cf41 ("firmware: xilinx: Implement ZynqMP power management APIs")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20201026155449.3703142-1-arnd@kernel.org
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/xilinx/zynqmp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/xilinx/zynqmp.c b/drivers/firmware/xilinx/zynqmp.c
index 8d1ff2454e2e..efb8a66efc68 100644
--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -147,6 +147,9 @@ static int zynqmp_pm_feature(u32 api_id)
 		return 0;
 
 	/* Return value if feature is already checked */
+	if (api_id > ARRAY_SIZE(zynqmp_pm_features))
+		return PM_FEATURE_INVALID;
+
 	if (zynqmp_pm_features[api_id] != PM_FEATURE_UNCHECKED)
 		return zynqmp_pm_features[api_id];
 
-- 
2.29.2


