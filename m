Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B02B713C106
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 13:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbgAOMaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 07:30:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbgAOMaw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jan 2020 07:30:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD244222C3;
        Wed, 15 Jan 2020 12:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579091451;
        bh=m8IEXAEOSPSfaJCsEcmTrSurYOfbfDJcePnMZcS1JFk=;
        h=Subject:To:From:Date:From;
        b=T99/BnR9i2LJs9uYSKsn8uUSN2+pybH2jbQ39jBduxEvpCXWGPULxj9RgT7PhR1BL
         gU0RqxVm1y6aB4dkfzCpbu1mD6NfbSF+QU8gtssjoFYV2jY/vXUYHTYBMgFlla+iY/
         MfKAlC8IUFBLPk64EzIfcooI8T5dc2RSGAZkCSKI=
Subject: patch "staging: comedi: ni_routes: allow partial routing information" added to staging-linus
To:     abbotti@mev.co.uk, gregkh@linuxfoundation.org, olsonse@umich.edu,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Jan 2020 13:30:47 +0100
Message-ID: <157909144761100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: comedi: ni_routes: allow partial routing information

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9fea3a40f6b07de977a2783270c8c3bc82544d45 Mon Sep 17 00:00:00 2001
From: Ian Abbott <abbotti@mev.co.uk>
Date: Tue, 14 Jan 2020 18:25:32 +0000
Subject: staging: comedi: ni_routes: allow partial routing information

This patch fixes a regression on setting up asynchronous commands to use
external trigger sources when board-specific routing information is
missing.

`ni_find_device_routes()` (called via `ni_assign_device_routes()`) finds
the table of register values for the device family and the set of valid
routes for the specific board.  If both are found,
`tables->route_values` is set to point to the table of register values
for the device family and `tables->valid_routes` is set to point to the
list of valid routes for the specific board.  If either is not found,
both `tables->route_values` and `tables->valid_routes` are left set at
their initial null values (initialized by `ni_assign_device_routes()`)
and the function returns `-ENODATA`.

Returning an error results in some routing functionality being disabled.
Unfortunately, leaving `table->route_values` set to `NULL` also breaks
the setting up of asynchronous commands that are configured to use
external trigger sources.  Calls to `ni_check_trigger_arg()` or
`ni_check_trigger_arg_roffs()` while checking the asynchronous command
set-up would result in a null pointer dereference if
`table->route_values` is `NULL`.  The null pointer dereference is fixed
in another patch, but it now results in failure to set up the
asynchronous command.  That is a regression from the behavior prior to
commit 347e244884c3 ("staging: comedi: tio: implement global tio/ctr
routing") and commit 56d0b826d39f ("staging: comedi: ni_mio_common:
implement new routing for TRIG_EXT").

Change `ni_find_device_routes()` to set `tables->route_values` and/or
`tables->valid_routes` to valid information even if the other one can
only be set to `NULL` due to missing information.  The function will
still return an error in that case.  This should result in
`tables->valid_routes` being valid for all currently supported device
families even if the board-specific routing information is missing.
That should be enough to fix the regression on setting up asynchronous
commands to use external triggers for boards with missing routing
information.

Fixes: 347e244884c3 ("staging: comedi: tio: implement global tio/ctr routing")
Fixes: 56d0b826d39f ("staging: comedi: ni_mio_common: implement new routing for TRIG_EXT").
Cc: <stable@vger.kernel.org> # 4.20+
Cc: Spencer E. Olson <olsonse@umich.edu>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20200114182532.132058-3-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_routes.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_routes.c b/drivers/staging/comedi/drivers/ni_routes.c
index 9627bd1d2a78..8f398b30f5bf 100644
--- a/drivers/staging/comedi/drivers/ni_routes.c
+++ b/drivers/staging/comedi/drivers/ni_routes.c
@@ -72,9 +72,6 @@ static int ni_find_device_routes(const char *device_family,
 		}
 	}
 
-	if (!rv)
-		return -ENODATA;
-
 	/* Second, find the set of routes valid for this device. */
 	for (i = 0; ni_device_routes_list[i]; ++i) {
 		if (memcmp(ni_device_routes_list[i]->device, board_name,
@@ -84,12 +81,12 @@ static int ni_find_device_routes(const char *device_family,
 		}
 	}
 
-	if (!dr)
-		return -ENODATA;
-
 	tables->route_values = rv;
 	tables->valid_routes = dr;
 
+	if (!rv || !dr)
+		return -ENODATA;
+
 	return 0;
 }
 
-- 
2.24.1


