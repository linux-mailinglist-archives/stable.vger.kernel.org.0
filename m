Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE92499F0
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 09:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbfFRHK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 03:10:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbfFRHK6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jun 2019 03:10:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F086D20679;
        Tue, 18 Jun 2019 07:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560841857;
        bh=sYAy74i6KJ3u+l87uskrheOKbfhTyV6tVL4ZoHFpFVc=;
        h=Subject:To:From:Date:From;
        b=B/FDAgCqkPlF9ZTrDxhvzFCohlhST3T7nSSxCifukuRBw3dF0hVxNxCYDW4V21e/6
         0dDCGwjOY1ssYRfzS0LN0EsfDwARrERSjbS+nd6dMsl+aZ58CCBgKmRxF5D08OKiA/
         2INybpMTUmhSjOxraXHk99ylqKKit16F8N0opKo8=
Subject: patch "firmware: improve LSM/IMA security behaviour" added to driver-core-testing
To:     thesven73@gmail.com, TheSven73@gmail.com,
        gregkh@linuxfoundation.org, keescook@chromium.org,
        mcgrof@kernel.org, rafael@kernel.org, stable@vger.kernel.org,
        zohar@linux.ibm.com, zohar@linux.vnet.ibm.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Jun 2019 09:10:55 +0200
Message-ID: <1560841855116208@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    firmware: improve LSM/IMA security behaviour

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the driver-core-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 2472d64af2d3561954e2f05365a67692bb852f2a Mon Sep 17 00:00:00 2001
From: Sven Van Asbroeck <thesven73@gmail.com>
Date: Mon, 17 Jun 2019 14:23:54 -0400
Subject: firmware: improve LSM/IMA security behaviour

The firmware loader queries if LSM/IMA permits it to load firmware
via the sysfs fallback. Unfortunately, the code does the opposite:
it expressly permits sysfs fw loading if security_kernel_load_data(
LOADING_FIRMWARE) returns -EACCES. This happens because a
zero-on-success return value is cast to a bool that's true on success.

Fix the return value handling so we get the correct behaviour.

Fixes: 6e852651f28e ("firmware: add call to LSM hook before firmware sysfs fallback")
Cc: Stable <stable@vger.kernel.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Kees Cook <keescook@chromium.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/firmware_loader/fallback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/firmware_loader/fallback.c b/drivers/base/firmware_loader/fallback.c
index b5cd96fd0e77..29becea1910d 100644
--- a/drivers/base/firmware_loader/fallback.c
+++ b/drivers/base/firmware_loader/fallback.c
@@ -659,7 +659,7 @@ static bool fw_run_sysfs_fallback(enum fw_opt opt_flags)
 	/* Also permit LSMs and IMA to fail firmware sysfs fallback */
 	ret = security_kernel_load_data(LOADING_FIRMWARE);
 	if (ret < 0)
-		return ret;
+		return false;
 
 	return fw_force_sysfs_fallback(opt_flags);
 }
-- 
2.22.0


